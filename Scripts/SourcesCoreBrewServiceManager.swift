import Foundation

public enum BrewError: Error {
    case brewNotFound
    case executionFailed(String)
}

public final class BrewServiceManager {
    public init() {}

    func brewPath() -> String? {
        let candidates = ["/opt/homebrew/bin/brew", "/usr/local/bin/brew", "/bin/brew", "/usr/bin/brew", "brew"]
        for c in candidates {
            if c == "brew" { return c } // rely on PATH
            if FileManager.default.isExecutableFile(atPath: c) {
                return c
            }
        }
        return nil
    }

    public func servicesList() throws -> [BrewService] {
        guard let brew = brewPath() else { throw BrewError.brewNotFound }

        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: brew)
        proc.arguments = ["services", "list"]

        let out = Pipe()
        let err = Pipe()
        proc.standardOutput = out
        proc.standardError = err

        try proc.run()
        proc.waitUntilExit()

        let data = out.fileHandleForReading.readDataToEndOfFile()
        let errData = err.fileHandleForReading.readDataToEndOfFile()

        if proc.terminationStatus != 0 {
            let s = String(data: errData, encoding: .utf8) ?? "error"
            throw BrewError.executionFailed(s)
        }

        let text = String(data: data, encoding: .utf8) ?? ""
        return parseBrewServicesList(output: text)
    }

    // Very simple parser for default `brew services list` table output
    func parseBrewServicesList(output: String) -> [BrewService] {
        var results: [BrewService] = []
        let lines = output.components(separatedBy: .newlines)
        guard lines.count > 1 else { return [] }

        // Find header line index (first line containing "Status" and "Name" typically)
        var startIndex = 0
        for (i, l) in lines.enumerated() {
            if l.lowercased().contains("status") && l.lowercased().contains("name") {
                startIndex = i + 1
                break
            }
        }

        // Parse lines using regex: name, status, rest
        // Example lines:
        // mysql   none
        // nginx   started dchichmarev ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist
        let pattern = "^(\\S+)\\s+(\\S+)(?:\\s+(.*))?$"
        let regex: NSRegularExpression?
        do {
            regex = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            return []
        }

        for i in startIndex..<lines.count {
            let line = lines[i].trimmingCharacters(in: .whitespaces)
            if line.isEmpty { continue }

            let nsLine = line as NSString
            guard let match = regex?.firstMatch(in: line, options: [], range: NSRange(location: 0, length: nsLine.length)) else { continue }

            let name = nsLine.substring(with: match.range(at: 1))
            let status = nsLine.substring(with: match.range(at: 2))
            var user = ""
            var pid: Int? = nil
            if match.range(at: 3).location != NSNotFound {
                let rest = nsLine.substring(with: match.range(at: 3))
                // rest may contain user and file path; attempt to extract first token as user
                let parts = rest.split(separator: " ", omittingEmptySubsequences: true).map { String($0) }
                if parts.count > 0 {
                    user = parts[0]
                    // if next token is a pid, parse it
                    if parts.count > 1, let possiblePid = Int(parts[1]) {
                        pid = possiblePid
                    }
                }
            }

            let autostart = status.lowercased().contains("started")
            let svc = BrewService(name: name, status: status, user: user, pid: pid, autostart: autostart, version: nil)
            results.append(svc)
        }

        return results
    }

    // Run an arbitrary `brew services <action> <service>` command and return stdout
    public func runService(action: String, service: String) throws -> String {
        guard let brew = brewPath() else { throw BrewError.brewNotFound }

        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: brew)
        proc.arguments = ["services", action, service]

        let out = Pipe()
        let err = Pipe()
        proc.standardOutput = out
        proc.standardError = err

        try proc.run()
        proc.waitUntilExit()

        let data = out.fileHandleForReading.readDataToEndOfFile()
        let errData = err.fileHandleForReading.readDataToEndOfFile()

        let outStr = String(data: data, encoding: .utf8) ?? ""
        if proc.terminationStatus != 0 {
            let s = String(data: errData, encoding: .utf8) ?? outStr
            throw BrewError.executionFailed(s)
        }

        return outStr
    }

    public func start(service: String) throws -> String { try runService(action: "start", service: service) }
    public func stop(service: String) throws -> String { try runService(action: "stop", service: service) }
    public func restart(service: String) throws -> String { try runService(action: "restart", service: service) }
    public func reload(service: String) throws -> String { try runService(action: "reload", service: service) }
}
