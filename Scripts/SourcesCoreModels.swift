import Foundation

public struct BrewService: Codable, Identifiable, Hashable {
    public let name: String
    public let status: String
    public let user: String
    public let pid: Int?
    public let autostart: Bool
    public var version: String?

    public var id: String { name }

    public init(name: String, status: String, user: String, pid: Int?, autostart: Bool, version: String?) {
        self.name = name
        self.status = status
        self.user = user
        self.pid = pid
        self.autostart = autostart
        self.version = version
    }
}
