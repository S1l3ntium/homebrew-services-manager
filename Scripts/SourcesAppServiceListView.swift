import SwiftUI

struct ServiceRowView: View {
    let name: String
    let status: String
    var body: some View {
        HStack {
            Text(name).font(.system(size: 13, weight: .medium))
            Spacer()
            Text(status)
                .foregroundColor(status.lowercased().contains("started") ? .green : (status.lowercased().contains("error") ? .red : .secondary))
                .font(.system(size: 12))
        }
        .padding(.vertical, 6)
    }
}

import Core
import SystemModule
import SwiftUI

struct ServiceListView: View {
    @ObservedObject var viewModel: ServiceListViewModel
    @State private var query: String = ""
    @State private var searchFocused: Bool = false

    var filtered: [BrewService] {
        if query.isEmpty { return viewModel.services }
        return viewModel.services.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        NavigationSplitView {
            VStack(spacing: 0) {
                HStack {
                    FocusableTextField(text: $query, placeholder: "Search services", isFirstResponder: $searchFocused)
                        .frame(minHeight: 22)
                    Button(action: { viewModel.refreshSync() }) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .help("Refresh")
                }
                .padding()

                List(selection: $viewModel.selectedService) {
                    ForEach(filtered) { svc in
                        HStack {
                            Circle()
                                .fill(color(for: svc.status))
                                .frame(width: 10, height: 10)
                            Text(svc.name)
                            Spacer()
                        }
                        .tag(svc)
                        .contextMenu {
                            Button("Start") { Task { await viewModel.perform(action: "start", for: svc, source: .app) } }
                            Button("Stop") { Task { await viewModel.perform(action: "stop", for: svc, source: .app) } }
                            Button("Restart") { Task { await viewModel.perform(action: "restart", for: svc, source: .app) } }
                        }
                    }
                }
            }
        } detail: {
            ServiceDetailView(service: viewModel.selectedService)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.ultraThinMaterial)
        }
        .onAppear {
            viewModel.refreshSync()
            // request notification permission and attach menu bar (best-effort)
            Task {
                do {
                    try await NotificationsManager.shared.requestAuthorization()
                } catch {
                    // ignore
                }
            }
            MenuBarController.shared.attach(viewModel: viewModel)
            // try to make window key so text input works reliably
            Task { @MainActor in
                NSApp.activate(ignoringOtherApps: true)
                if let w = NSApp.windows.first {
                    w.makeKeyAndOrderFront(nil)
                }
                // request focus for search field after a short delay to ensure window is key
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                    searchFocused = true
                    print("[ServiceListView] requested search focus")
                }
            }
        }
        .onChange(of: searchFocused) { new in
            print("[ServiceListView] searchFocused -> \(new)")
        }
        .onChange(of: query) { q in
            print("[ServiceListView] query changed: \(q)")
        }
        .onReceive(viewModel.$toastMessage) { msg in
            if msg != nil {
                showingActionResult = true
                // auto clear after 3s
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    viewModel.clearToast()
                }
            } else {
                showingActionResult = false
            }
        }
        .overlay(alignment: .topTrailing) {
            if showingActionResult, let msg = viewModel.toastMessage {
                Text(msg)
                    .padding(10)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                    .padding()
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
    @State private var showingActionResult: Bool = false

    func color(for status: String) -> Color {
        let s = status.lowercased()
        if s.contains("start") || s.contains("started") { return .green }
        if s.contains("error") { return .red }
        if s.contains("none") || s.contains("stopped") { return .gray }
        return .yellow
    }
}

struct ServiceListView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = ServiceListViewModel()
        vm.services = [
            BrewService(name: "postgresql", status: "started", user: "user", pid: 1234, autostart: true, version: "14.1"),
            BrewService(name: "redis", status: "stopped", user: "user", pid: nil, autostart: false, version: "6.0"),
        ]
        return ServiceListView(viewModel: vm)
    }
}
