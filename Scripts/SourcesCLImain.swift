import Foundation
import Core

let manager = BrewServiceManager()

do {
    let services = try manager.servicesList()
    let enc = JSONEncoder()
    enc.outputFormatting = [.prettyPrinted, .sortedKeys]
    let data = try enc.encode(services)
    if let s = String(data: data, encoding: .utf8) {
        print(s)
    }
} catch BrewError.brewNotFound {
    fputs("brew not found. Ensure Homebrew is installed and in PATH.\n", stderr)
    exit(2)
} catch BrewError.executionFailed(let msg) {
    fputs("brew execution failed: \(msg)\n", stderr)
    exit(3)
} catch {
    fputs("Unexpected error: \(error)\n", stderr)
    exit(1)
}
