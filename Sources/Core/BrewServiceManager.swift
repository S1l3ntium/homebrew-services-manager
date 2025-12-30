import Foundation

public enum BrewError: Error, LocalizedError {
    case brewNotFound
    case executionFailed(String)
    case invalidOutput(String)
    case operationCancelled
    case requiresAuthentication(String)

    public var errorDescription: String? {
        switch self {
        case .brewNotFound:
            return "Homebrew не найден. Убедитесь, что Homebrew установлен и находится в PATH"
        case .executionFailed(let msg):
            return "Ошибка выполнения brew: \(msg)"
        case .invalidOutput(let msg):
            return "Некорректный вывод от brew: \(msg)"
        case .operationCancelled:
            return "Операция отменена"
        case .requiresAuthentication(let action):
            return "Операция '\(action)' требует прав администратора"
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .brewNotFound:
            return "Установите Homebrew с https://brew.sh"
        case .executionFailed:
            return "Проверьте доступность сервиса и наличие необходимых прав"
        case .invalidOutput:
            return "Попробуйте обновить Homebrew: brew update"
        case .operationCancelled:
            return "Повторите операцию"
        case .requiresAuthentication:
            return "Операция требует пароль администратора"
        }
    }
}

public final class BrewServiceManager {
    private let fileManager = FileManager.default
    private var _brewPath: String?

    public init() {}

    public func brewPath() -> String? {
        if let cached = _brewPath {
            return cached
        }

        let candidates = ["/opt/homebrew/bin/brew", "/usr/local/bin/brew", "/bin/brew", "/usr/bin/brew", "brew"]
        for candidate in candidates {
            if candidate == "brew" {
                _brewPath = candidate
                return candidate
            }
            if fileManager.isExecutableFile(atPath: candidate) {
                _brewPath = candidate
                return candidate
            }
        }
        return nil
    }

    public func servicesList() async throws -> [BrewService] {
        guard brewPath() != nil else { throw BrewError.brewNotFound }

        let output = try await executeBrewCommand(arguments: ["services", "list"])
        return parseBrewServicesList(output: output)
    }

    private func executeBrewCommand(arguments: [String]) async throws -> String {
        guard let brew = brewPath() else { throw BrewError.brewNotFound }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: brew)
        process.arguments = arguments

        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe

        try await Task.sleep(nanoseconds: 0)

        try process.run()
        process.waitUntilExit()

        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

        guard process.terminationStatus == 0 else {
            let errorMessage = String(data: errorData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Unknown error"

            if errorMessage.contains("requires authentication") {
                throw BrewError.requiresAuthentication(arguments.joined(separator: " "))
            }
            throw BrewError.executionFailed(errorMessage)
        }

        guard let output = String(data: outputData, encoding: .utf8) else {
            throw BrewError.invalidOutput("Cannot decode command output")
        }

        return output
    }

    func parseBrewServicesList(output: String) -> [BrewService] {
        let lines = output.split(separator: "\n", omittingEmptySubsequences: true)
        guard lines.count > 1 else { return [] }

        let headerIndex = lines.firstIndex { line in
            line.lowercased().contains("status") && line.lowercased().contains("name")
        }

        guard let startIndex = headerIndex else { return [] }

        let serviceLines = lines[(lines.index(after: startIndex))...]

        let regex = try? NSRegularExpression(pattern: "^(\\S+)\\s+(\\S+)(?:\\s+(.*))?$", options: [])

        return serviceLines.compactMap { line in
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty else { return nil }

            let nsLine = trimmed as NSString
            let range = NSRange(location: 0, length: nsLine.length)

            guard let match = regex?.firstMatch(in: trimmed, options: [], range: range) else {
                return nil
            }

            let name = nsLine.substring(with: match.range(at: 1))
            let status = nsLine.substring(with: match.range(at: 2))

            var user = ""
            var pid: Int?

            if match.range(at: 3).location != NSNotFound {
                let rest = nsLine.substring(with: match.range(at: 3))
                let parts = rest.split(separator: " ", omittingEmptySubsequences: true).map(String.init)

                if !parts.isEmpty {
                    user = parts[0]
                    if parts.count > 1, let parsedPid = Int(parts[1]) {
                        pid = parsedPid
                    }
                }
            }

            return BrewService(
                name: name,
                status: status,
                user: user,
                pid: pid,
                autostart: status.lowercased().contains("started"),
                version: nil
            )
        }
    }

    public func runService(action: String, service: String) async throws -> String {
        try await executeBrewCommand(arguments: ["services", action, service])
    }

    public func start(service: String) async throws -> String {
        try await runService(action: "start", service: service)
    }

    public func stop(service: String) async throws -> String {
        try await runService(action: "stop", service: service)
    }

    public func restart(service: String) async throws -> String {
        try await runService(action: "restart", service: service)
    }

    public func reload(service: String) async throws -> String {
        try await runService(action: "reload", service: service)
    }

    public func info(service: String) async throws -> String {
        try await runService(action: "info", service: service)
    }

    public func startAll() async throws -> String {
        try await executeBrewCommand(arguments: ["services", "start", "--all"])
    }

    public func stopAll() async throws -> String {
        try await executeBrewCommand(arguments: ["services", "stop", "--all"])
    }
}
