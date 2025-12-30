import SwiftUI
import AppKit

extension Notification.Name {
    static let requestSearchFocus = Notification.Name("HomebrewServicesManager.requestSearchFocus")
}

final class FocusBridge {
    static let shared = FocusBridge()
    private init() {}
    weak var lastTextField: NSTextField?

    func requestFocus() {
        DispatchQueue.main.async {
            guard let tf = self.lastTextField else { return }
            tf.window?.makeKeyAndOrderFront(nil)
            tf.becomeFirstResponder()
        }
    }
}

struct FocusableTextField: NSViewRepresentable {
    @Binding var text: String
    var placeholder: String?
    @Binding var isFirstResponder: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, isFirstResponder: $isFirstResponder)
    }

    func makeNSView(context: Context) -> NSTextField {
        let tf = NSTextField()
        tf.isBordered = true
        tf.isBezeled = true
        tf.placeholderString = placeholder
        tf.delegate = context.coordinator
        let coord = context.coordinator
        coord.nsTextField = tf
        FocusBridge.shared.lastTextField = tf

        // observe requests to focus from other parts (menu bar)
        coord.observer = NotificationCenter.default.addObserver(forName: .requestSearchFocus, object: nil, queue: .main) { [weak coord] _ in
            coord?.attemptFocusRepeatedly()
        }

        return tf
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        if nsView.stringValue != text {
            nsView.stringValue = text
        }
        if isFirstResponder {
            if nsView.window != nil && nsView.window!.firstResponder !== nsView {
                nsView.becomeFirstResponder()
            }
        }
    }

    static func dismantleNSView(_ nsView: NSTextField, coordinator: Coordinator) {
        if let obs = coordinator.observer {
            NotificationCenter.default.removeObserver(obs)
            coordinator.observer = nil
        }
        if FocusBridge.shared.lastTextField === nsView {
            FocusBridge.shared.lastTextField = nil
        }
    }

    class Coordinator: NSObject, NSTextFieldDelegate {
        var text: Binding<String>
        var isFirstResponder: Binding<Bool>
        weak var nsTextField: NSTextField?
        var observer: NSObjectProtocol?

        init(text: Binding<String>, isFirstResponder: Binding<Bool>) {
            self.text = text
            self.isFirstResponder = isFirstResponder
        }

        func controlTextDidChange(_ obj: Notification) {
            if let tf = obj.object as? NSTextField {
                text.wrappedValue = tf.stringValue
            }
        }

        func attemptFocusRepeatedly() {
            // Try a few times to become first responder to avoid races with menu/activation
            guard let tf = nsTextField else { return }
            let tries = [0.0, 0.06, 0.14]
            for delay in tries {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self, weak tf] in
                    guard let tf = tf else { return }
                    tf.window?.makeKeyAndOrderFront(nil)
                    tf.becomeFirstResponder()
                    self?.isFirstResponder.wrappedValue = (tf.window?.firstResponder === tf)
                }
            }
        }

        deinit {
            if let obs = observer {
                NotificationCenter.default.removeObserver(obs)
            }
        }
    }
}
