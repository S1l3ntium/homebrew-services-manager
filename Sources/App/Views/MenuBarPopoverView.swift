import SwiftUI
import Core

/// Главный view для popover в menu bar с Liquid Glass дизайном
struct MenuBarPopoverView: View {
    @ObservedObject var viewModel: ServiceListViewModel
    @State private var searchText = ""
    @State private var hoveredService: String?
    @State private var selectedService: BrewService?
    @State private var operationInProgress: String?
    @State private var operationStatus: String = ""
    @State private var isInitialLoad = true
    @State private var operatingServiceName: String?
    @State private var pulseScale: CGFloat = 1.0

    var filteredServices: [BrewService] {
        if searchText.isEmpty {
            return viewModel.services
        }
        return viewModel.services.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Поиск (без заголовка с иконкой)
            searchView
                .padding(.horizontal, 12)
                .padding(.vertical, 10)

            Divider()

            // Список сервисов или детали выбранного сервиса
            if let selected = selectedService {
                serviceDetailView(for: selected)
            } else if isInitialLoad && viewModel.isLoading {
                loadingView
            } else if filteredServices.isEmpty {
                emptyView
            } else {
                servicesListView
            }

            Divider()

            // Футер с кнопками
            footerView
        }
        .frame(width: 360, height: 500)
        .background(Color(nsColor: .windowBackgroundColor).opacity(0.95))
        .onChange(of: viewModel.services) { newServices in
            if isInitialLoad && !newServices.isEmpty {
                isInitialLoad = false
            }
        }
    }

    // MARK: - Service Detail View

    private func serviceDetailView(for service: BrewService) -> some View {
        VStack(spacing: 12) {
            // Кнопка назад
            HStack {
                Button(action: {
                    selectedService = nil
                    operationInProgress = nil
                    operationStatus = ""
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)

                Text(service.name)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(1)

                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)

            Divider()

            if let operation = operationInProgress {
                // Статус выполняющейся операции с пульсирующим индикатором
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        // Пульсирующий кружок
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 16, height: 16)
                                .scaleEffect(pulseScale)

                            Circle()
                                .fill(Color.blue)
                                .frame(width: 10, height: 10)
                        }
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                                pulseScale = 1.6
                            }
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(operation.capitalized + "ing...")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.blue)

                            if !operationStatus.isEmpty {
                                Text(operationStatus)
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                        }

                        Spacer()
                    }
                    .padding(12)
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(8)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .frame(maxHeight: .infinity, alignment: .top)
            } else {
                // Информация о сервисе
                VStack(alignment: .leading, spacing: 10) {
                    infoRow(label: "Статус", value: service.status)
                    infoRow(label: "Пользователь", value: service.user.isEmpty ? "—" : service.user)
                    if let pid = service.pid {
                        infoRow(label: "PID", value: String(pid))
                    }
                    if let version = service.version {
                        infoRow(label: "Версия", value: version)
                    }
                    infoRow(label: "Авто-старт", value: service.autostart ? "Включён" : "Отключён")

                    // Кнопки для открытия конфига и логов
                    HStack(spacing: 12) {
                        if let plistPath = BrewServiceManager().getServicePlist(service: service.name) {
                            Button(action: {
                                NSWorkspace.shared.open(URL(fileURLWithPath: plistPath))
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "doc.text")
                                        .font(.system(size: 11, weight: .medium))
                                    Text("Конфиг")
                                        .font(.system(size: 11, weight: .medium))
                                }
                                .foregroundColor(.blue)
                            }
                            .buttonStyle(.plain)
                        }

                        if let logsDir = BrewServiceManager().getServiceLogsDirectory(service: service.name) {
                            Button(action: {
                                NSWorkspace.shared.open(URL(fileURLWithPath: logsDir))
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "list.bullet.clipboard")
                                        .font(.system(size: 11, weight: .medium))
                                    Text("Логи")
                                        .font(.system(size: 11, weight: .medium))
                                }
                                .foregroundColor(.blue)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.top, 6)
                }
                .padding(.horizontal, 12)

                Spacer()
            }

            // Кнопки управления
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    actionButtonSmall(icon: "play.fill", label: "Start", color: .green, isDisabled: operationInProgress != nil) {
                        operationInProgress = "start"
                        operationStatus = "Запуск сервиса..."
                        Task {
                            await viewModel.perform(action: "start", for: service, source: .menuBar)
                            operationInProgress = nil
                            operationStatus = ""
                            try? await Task.sleep(nanoseconds: 500_000_000)
                            selectedService = nil
                        }
                    }

                    actionButtonSmall(icon: "stop.fill", label: "Stop", color: .red, isDisabled: operationInProgress != nil) {
                        operationInProgress = "stop"
                        operationStatus = "Остановка сервиса..."
                        Task {
                            await viewModel.perform(action: "stop", for: service, source: .menuBar)
                            operationInProgress = nil
                            operationStatus = ""
                            try? await Task.sleep(nanoseconds: 500_000_000)
                            selectedService = nil
                        }
                    }

                    actionButtonSmall(icon: "arrow.clockwise", label: "Restart", color: .blue, isDisabled: operationInProgress != nil) {
                        operationInProgress = "restart"
                        operationStatus = "Перезагрузка сервиса..."
                        Task {
                            await viewModel.perform(action: "restart", for: service, source: .menuBar)
                            operationInProgress = nil
                            operationStatus = ""
                            try? await Task.sleep(nanoseconds: 500_000_000)
                            selectedService = nil
                        }
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
        }
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.primary)
                .lineLimit(1)
        }
    }

    private func actionButtonSmall(icon: String, label: String, color: Color, isDisabled: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .medium))
                    .frame(height: 16)
                Text(label)
                    .font(.system(size: 10, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .foregroundColor(isDisabled ? color.opacity(0.5) : color)
        }
        .buttonStyle(GlassButtonStyle(variant: .compact))
        .disabled(isDisabled)
    }

    // MARK: - Search

    private var searchView: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.system(size: 13))

            TextField("Search services...", text: $searchText)
                .textFieldStyle(.plain)
                .font(.system(size: 12))

            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.system(size: 13))
                }
                .buttonStyle(.plain)
            }

            Spacer()

            // Кнопка обновления маленькая
            Button(action: {
                Task {
                    await viewModel.refresh()
                }
            }) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.primary)
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isLoading)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(nsColor: .controlBackgroundColor))
        )
    }

    // MARK: - Services List

    private var servicesListView: some View {
        ScrollView {
            LazyVStack(spacing: 4) {
                ForEach(filteredServices, id: \.name) { service in
                    MenuBarServiceRowView(
                        service: service,
                        isHovered: hoveredService == service.name,
                        onStart: {
                            Task {
                                await viewModel.perform(action: "start", for: service, source: .menuBar)
                            }
                        },
                        onStop: {
                            Task {
                                await viewModel.perform(action: "stop", for: service, source: .menuBar)
                            }
                        },
                        onRestart: {
                            Task {
                                await viewModel.perform(action: "restart", for: service, source: .menuBar)
                            }
                        },
                        onSelect: {
                            selectedService = service
                        }
                    )
                    .onHover { hovering in
                        hoveredService = hovering ? service.name : nil
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
        }
    }

    // MARK: - Loading & Empty States

    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(0.8)
            Text("Loading services...")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 40))
                .foregroundColor(.secondary)

            Text(searchText.isEmpty ? "No services found" : "No results")
                .font(.system(size: 14, weight: .medium))

            if searchText.isEmpty {
                Text("Run 'brew services' to see services")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Footer

    private var footerView: some View {
        HStack(spacing: 8) {
            Text("\(filteredServices.count) service(s)")
                .font(.system(size: 11))
                .foregroundColor(.secondary)

            Spacer()

            Button("Quit") {
                NSApp.terminate(nil)
            }
            .buttonStyle(GlassButtonStyle(variant: .subtle))
            .keyboardShortcut("q", modifiers: .command)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

// MARK: - Service Row with Liquid Glass

struct MenuBarServiceRowView: View {
    let service: BrewService
    let isHovered: Bool
    let onStart: () -> Void
    let onStop: () -> Void
    let onRestart: () -> Void
    let onSelect: () -> Void

    @State private var showActions = false

    private var statusColor: Color {
        let status = service.status.lowercased()
        if status.contains("start") {
            return .green
        } else if status.contains("error") {
            return .red
        } else if status.contains("none") || status.contains("stopped") {
            return .gray
        } else {
            return .orange
        }
    }

    var body: some View {
        ZStack {
            // Фон с Liquid Glass эффектом при наведении
            if isHovered {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                    )
            }

            HStack(spacing: 12) {
                // Статус индикатор
                Circle()
                    .fill(statusColor)
                    .frame(width: 8, height: 8)

                // Название сервиса
                VStack(alignment: .leading, spacing: 2) {
                    Text(service.name)
                        .font(.system(size: 13, weight: .medium))
                        .lineLimit(1)

                    Text(service.status)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                // Кнопки управления (показываются при наведении)
                if isHovered || showActions {
                    HStack(spacing: 6) {
                        actionButton(icon: "play.fill", color: .green, action: onStart)
                        actionButton(icon: "stop.fill", color: .red, action: onStop)
                        actionButton(icon: "arrow.clockwise", color: .blue, action: onRestart)
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.primary)
        }
        .animation(.easeInOut(duration: 0.15), value: isHovered)
        .contentShape(Rectangle())
        .onTapGesture {
            onSelect()
        }
    }

    private func actionButton(icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24, height: 24)
        }
        .buttonStyle(GlassButtonStyle(variant: .compact))
    }
}

// MARK: - Custom Glass Button Style

struct GlassButtonStyle: ButtonStyle {
    enum Variant {
        case standard
        case compact
        case subtle
    }

    let variant: Variant
    @State private var isHovered = false

    init(variant: Variant = .standard) {
        self.variant = variant
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .strokeBorder(
                                Color.white.opacity(isHovered ? 0.4 : 0.2),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.15)) {
                    isHovered = hovering
                }
            }
    }

    private var padding: EdgeInsets {
        switch variant {
        case .standard:
            return EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
        case .compact:
            return EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        case .subtle:
            return EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10)
        }
    }

    private var cornerRadius: CGFloat {
        switch variant {
        case .standard:
            return 6
        case .compact:
            return 5
        case .subtle:
            return 5
        }
    }
}

// MARK: - Simple Button Style

struct SimpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

// MARK: - Preview

struct MenuBarPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = ServiceListViewModel()
        vm.services = [
            BrewService(name: "postgresql@14", status: "started", user: "user", pid: 12345, autostart: true, version: "14.0"),
            BrewService(name: "redis", status: "stopped", user: "user", pid: nil, autostart: false, version: "7.0"),
            BrewService(name: "nginx", status: "error", user: "user", pid: nil, autostart: true, version: "1.25"),
        ]
        return MenuBarPopoverView(viewModel: vm)
    }
}
