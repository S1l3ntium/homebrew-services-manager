import Foundation
import Core

@main
struct HomebrewServicesCLI {
    static func main() async {
        let manager = BrewServiceManager()

        do {
            let services = try await manager.servicesList()
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(services)

            guard let json = String(data: data, encoding: .utf8) else {
                throw BrewError.invalidOutput("Cannot encode JSON output")
            }
            print(json)
        } catch let error as BrewError {
            fputs(error.errorDescription ?? "Unknown error\n", stderr)
            Darwin.exit(exitCode(for: error))
        } catch {
            fputs("Unexpected error: \(error)\n", stderr)
            Darwin.exit(1)
        }
    }

    private static func exitCode(for error: BrewError) -> Int32 {
        switch error {
        case .brewNotFound:
            return 2
        case .executionFailed:
            return 3
        case .invalidOutput:
            return 4
        case .operationCancelled:
            return 130
        case .requiresAuthentication:
            return 77
        }
    }
}
