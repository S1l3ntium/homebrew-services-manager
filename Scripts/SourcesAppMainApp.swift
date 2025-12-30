import SwiftUI
import AppKit
import Core

@main
struct HomebrewServicesManagerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        // Убираем WindowGroup - приложение работает только через menu bar
        Settings {
            EmptyView()
        }
    }
}
// AppDelegate для управления menu bar приложением
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Скрываем иконку в Dock
        NSApp.setActivationPolicy(.accessory)
        
        // Инициализируем menu bar controller
        Task { @MainActor in
            MenuBarController.shared.setup()
        }
        
        print("[AppDelegate] Menu bar app initialized")
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // Приложение не завершается при закрытии окон (так как окон у нас нет)
        return false
    }
}

