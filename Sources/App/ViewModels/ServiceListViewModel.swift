import Foundation
import Combine
import Core
import SystemModule

@MainActor
final class ServiceListViewModel: ObservableObject {
    @Published var services: [BrewService] = []
    @Published var selectedService: BrewService? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var actionInProgress: Bool = false
    @Published var lastActionMessage: String? = nil
    @Published var toastMessage: String? = nil

    public enum ActionSource {
        case app
        case menuBar
    }

    func refresh() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let manager = BrewServiceManager()
            var list = try await Task.detached { try await manager.servicesList() }.value

            // Fetch version information for each service in parallel
            var versionDict: [String: String] = [:]
            await withTaskGroup(of: (String, String?).self) { group in
                for service in list {
                    group.addTask {
                        let version = try? await manager.getServiceVersion(service: service.name)
                        return (service.name, version)
                    }
                }

                for await (name, version) in group {
                    if let version = version {
                        versionDict[name] = version
                    }
                }
            }

            list = list.map { service in
                var updated = service
                updated.version = versionDict[service.name]
                if let version = updated.version {
                    print("[ServiceListViewModel] Updated version for '\(service.name)': \(version)")
                }
                return updated
            }

            services = list
            print("[ServiceListViewModel] Refresh complete. Services: \(list.count)")
        } catch {
            let localizedError = error as? LocalizedError
            errorMessage = localizedError?.errorDescription ?? String(describing: error)
        }
    }

    func refreshSync() {
        Task {
            await refresh()
        }
    }

    func perform(action: String, for service: BrewService, source: ActionSource = .app) async {
        actionInProgress = true
        lastActionMessage = nil
        defer { actionInProgress = false }

        do {
            _ = try await Task.detached { try await BrewServiceManager().runService(action: action, service: service.name) }.value

            let successMessage = "✓ Действие '\(action)' для '\(service.name)' выполнено"
            if source == .menuBar {
                NotificationsManager.shared.send(title: "✓ \(action)", body: service.name)
            } else {
                toastMessage = successMessage
            }

            // Выполняем обновление списка в фоне без блокирования UI
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)  // Ждем 1 сек перед обновлением
                await refresh()
            }
        } catch let error as BrewError {
            let errorDescription = error.errorDescription ?? String(describing: error)
            if source == .menuBar {
                NotificationsManager.shared.send(title: "✗ Ошибка \(action)", body: "\(service.name): \(errorDescription)")
            } else {
                toastMessage = "✗ \(action) на '\(service.name)' не удалась: \(errorDescription)"
            }
        } catch {
            let message = "Ошибка при выполнении \(action) на \(service.name)"
            if source == .menuBar {
                NotificationsManager.shared.send(title: "✗ Ошибка", body: message)
            } else {
                toastMessage = message
            }
        }
    }

    func clearToast() {
        toastMessage = nil
    }
}
