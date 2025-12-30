import Testing
import Core

@Suite("BrewServiceManager Tests")
struct BrewServiceManagerTests {
    
    @Test("Parse empty output returns empty array")
    func parseEmptyOutput() async throws {
        let manager = BrewServiceManager()
        let result = manager.parseBrewServicesList(output: "")
        #expect(result.isEmpty, "Empty output should return empty array")
    }
    
    @Test("Parse services list with header")
    func parseServicesWithHeader() async throws {
        let manager = BrewServiceManager()
        let output = """
        Name    Status  User File
        mysql   none
        nginx   started dchichmarev ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist
        """
        
        let result = manager.parseBrewServicesList(output: output)
        #expect(result.count == 2, "Should parse 2 services")
        
        if let mysql = result.first(where: { $0.name == "mysql" }) {
            #expect(mysql.status == "none")
            #expect(!mysql.autostart)
        }
        
        if let nginx = result.first(where: { $0.name == "nginx" }) {
            #expect(nginx.status == "started")
            #expect(nginx.autostart)
            #expect(nginx.user == "dchichmarev")
        }
    }
}
