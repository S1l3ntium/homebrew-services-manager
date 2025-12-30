import AppKit
import SwiftUI
import Core
import SystemModule
import Combine

final class MenuBarController {
    public static let shared = MenuBarController()

    private var statusItem: NSStatusItem?
    private var viewModel: ServiceListViewModel?
    private var popover: NSPopover?
    private var eventMonitor: EventMonitor?

    private init() {}

    @MainActor public func attach(viewModel: ServiceListViewModel) {
        self.viewModel = viewModel
    }

    @MainActor public func setup() {
        // Создаем ViewModel
        self.viewModel = ServiceListViewModel()
        
        // Создаем status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "server.rack", accessibilityDescription: "Homebrew Services")
            button.action = #selector(togglePopover(_:))
            button.target = self
        }
        
        // Создаем popover с Liquid Glass дизайном
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 360, height: 500)
        popover?.behavior = .transient
        popover?.contentViewController = NSHostingController(
            rootView: MenuBarPopoverView(viewModel: viewModel!)
        )
        
        // Event monitor для закрытия popover при клике вне его
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let popover = self?.popover, popover.isShown {
                self?.closePopover()
            }
        }
        
        // Загружаем сервисы
        Task {
            await viewModel?.refresh()
        }
        
        print("[MenuBarController] setup complete")
    }

    @objc private func togglePopover(_ sender: AnyObject?) {
        if let popover = popover {
            if popover.isShown {
                closePopover()
            } else {
                showPopover()
            }
        }
    }

    private func showPopover() {
        if let button = statusItem?.button, let popover = popover {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            eventMonitor?.start()
            print("[MenuBarController] popover shown")
        }
    }

    private func closePopover() {
        popover?.performClose(nil)
        eventMonitor?.stop()
        print("[MenuBarController] popover closed")
    }
}

// Event monitor для обнаружения кликов вне popover
class EventMonitor {
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent?) -> Void

    init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void) {
        self.mask = mask
        self.handler = handler
    }

    deinit {
        stop()
    }

    func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }

    func stop() {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
            self.monitor = nil
        }
    }
}
