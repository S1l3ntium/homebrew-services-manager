import Foundation

enum L10n {
    // MARK: - Header & Navigation
    static let back = NSLocalizedString("back", value: "Back", comment: "Back button")

    // MARK: - Service Information
    static let status = NSLocalizedString("status", value: "Status", comment: "Service status label")
    static let user = NSLocalizedString("user", value: "User", comment: "User running service")
    static let pid = NSLocalizedString("pid", value: "PID", comment: "Process ID")
    static let version = NSLocalizedString("version", value: "Version", comment: "Package version")
    static let autoStart = NSLocalizedString("autoStart", value: "Auto-start", comment: "Auto-start status")
    static let enabled = NSLocalizedString("enabled", value: "Enabled", comment: "Enabled status")
    static let disabled = NSLocalizedString("disabled", value: "Disabled", comment: "Disabled status")

    // MARK: - Search & List
    static let searchServices = NSLocalizedString("searchServices", value: "Search services...", comment: "Search placeholder")
    static let noServices = NSLocalizedString("noServices", value: "No services found", comment: "Empty state")
    static let noResults = NSLocalizedString("noResults", value: "No results", comment: "No search results")
    static let runBrewServices = NSLocalizedString("runBrewServices", value: "Run 'brew services' to see services", comment: "Empty state hint")
    static let loadingServices = NSLocalizedString("loadingServices", value: "Loading services...", comment: "Loading state")

    // MARK: - Actions
    static let start = NSLocalizedString("start", value: "Start", comment: "Start action")
    static let stop = NSLocalizedString("stop", value: "Stop", comment: "Stop action")
    static let restart = NSLocalizedString("restart", value: "Restart", comment: "Restart action")
    static let starting = NSLocalizedString("starting", value: "Starting...", comment: "Starting status")
    static let stopping = NSLocalizedString("stopping", value: "Stopping...", comment: "Stopping status")
    static let restarting = NSLocalizedString("restarting", value: "Restarting...", comment: "Restarting status")

    // MARK: - Service Configuration
    static let openConfig = NSLocalizedString("openConfig", value: "Config", comment: "Open config button")
    static let openLogs = NSLocalizedString("openLogs", value: "Logs", comment: "Open logs button")

    // MARK: - Footer
    static let services = NSLocalizedString("services", value: "service(s)", comment: "Service count")
    static let quit = NSLocalizedString("quit", value: "Quit", comment: "Quit button")

    // MARK: - Notifications
    static let actionSuccess = NSLocalizedString("actionSuccess", value: "✓ %@", comment: "Success notification")
    static let actionError = NSLocalizedString("actionError", value: "✗ Error %@", comment: "Error notification")

    // MARK: - Helper
    static func serviceCount(_ count: Int) -> String {
        NSLocalizedString("serviceCount", value: "%d service(s)", comment: "Service count format").replacingOccurrences(of: "%d", with: String(count))
    }
}
