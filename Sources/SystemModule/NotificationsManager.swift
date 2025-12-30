import Foundation
import UserNotifications

public final class NotificationsManager {
    public static let shared = NotificationsManager()

    private init() {}
    private var isAppBundle: Bool {
        let ext = Bundle.main.bundleURL.pathExtension.lowercased()
        return ext == "app"
    }

    public func requestAuthorization() async throws {
        // When running via SwiftPM (`swift run`) the main bundle is not an .app bundle and
        // `UNUserNotificationCenter.current()` can assert. Guard against that by no‑op in CLI contexts.
        guard isAppBundle else { return }

        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let err = error { cont.resume(throwing: err); return }
                if !granted {
                    cont.resume(throwing: NSError(domain: "Notifications", code: 1, userInfo: [NSLocalizedDescriptionKey: "User denied notification permission"]))
                    return
                }
                cont.resume(returning: ())
            }
        }
    }

    public func send(title: String, body: String) {
        if isAppBundle {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default

            let req = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            print("[NotificationsManager] sending UN notification: \(title) - \(body)")
            UNUserNotificationCenter.current().add(req) { error in
                if let e = error {
                    fputs("Notification error: \(e)\n", stderr)
                }
            }
            return
        }

        // Fallback for non-bundle runs (e.g. `swift run`) — use the older NSUserNotification API.
        if #available(macOS 10.14, *) {
            print("[NotificationsManager] sending NSUserNotification fallback: \(title) - \(body)")
            let n = NSUserNotification()
            n.title = title
            n.informativeText = body
            n.soundName = NSUserNotificationDefaultSoundName
            NSUserNotificationCenter.default.deliver(n)
        }
    }
}
