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
        do {
            // create manager inside detached task to avoid MainActor isolation
            print("[ViewModel] refresh starting")
            let list = try await Task.detached { try BrewServiceManager().servicesList() }.value
            print("[ViewModel] refresh returned \(list.count) services")
            services = list
        } catch {
            errorMessage = String(describing: error)
        }
        isLoading = false
    }

    func refreshSync() {
        Task {
            await refresh()
        }
    }

    func perform(action: String, for service: BrewService, source: ActionSource = .app) async {
        actionInProgress = true
        lastActionMessage = nil
        do {
            print("[ViewModel] perform \(action) on \(service.name) (source: \(source))")
            _ = try await Task.detached { try BrewServiceManager().runService(action: action, service: service.name) }.value
            print("[ViewModel] perform \(action) finished for \(service.name)")
            // notify differently depending on source
            if source == .menuBar {
                NotificationsManager.shared.send(title: "Service \(action)", body: "\(service.name): succeeded")
            } else {
                toastMessage = "Action \(action) on \(service.name) succeeded"
            }
            // refresh list after action
            await refresh()
        } catch {
            if source == .menuBar {
                NotificationsManager.shared.send(title: "Service \(action) failed", body: "\(service.name): \(error)")
            } else {
                toastMessage = "Action \(action) on \(service.name) failed: \(error)"
            }
        }
        actionInProgress = false
    }

    func clearToast() {
        toastMessage = nil
    }
}
