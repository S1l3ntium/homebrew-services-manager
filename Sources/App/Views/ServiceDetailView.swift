import SwiftUI
import Core

struct ServiceDetailView: View {
    let service: BrewService?

    var body: some View {
        Group {
            if let svc = service {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .center, spacing: 8) {
                        Circle()
                            .fill(color(for: svc.status))
                            .frame(width: 12, height: 12)
                        Text(svc.name)
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(svc.status)
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("User: \(svc.user)")
                            Text("PID: \(svc.pid.map(String.init) ?? "-")")
                            Text("Autostart: \(svc.autostart ? "Yes" : "No")")
                            Text("Version: \(svc.version ?? "-")")
                        }
                        Spacer()
                    }
                    .font(.system(size: 13))

                    Divider()

                    Text("Service details and logs will appear here.")
                        .foregroundColor(.secondary)

                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial)
            } else {
                Text("Select a service to see details")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    func color(for status: String) -> Color {
        let s = status.lowercased()
        if s.contains("start") || s.contains("started") { return .green }
        if s.contains("error") { return .red }
        if s.contains("none") || s.contains("stopped") { return .gray }
        return .yellow
    }
}
