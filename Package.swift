// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "HomebrewServicesManager",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "hsmanager-cli", targets: ["CLI"]),
        .executable(name: "HomebrewServicesManager", targets: ["App"]),
    ],
    targets: [
        .executableTarget(
            name: "CLI",
            dependencies: ["Core"],
            path: "Sources/CLI"
        ),
        .executableTarget(
            name: "App",
            dependencies: ["Core", "SystemModule"],
            path: "Sources/App"
        ),
        .target(
            name: "Core",
            dependencies: [],
            path: "Sources/Core"
        ),
        .target(
            name: "SystemModule",
            dependencies: [],
            path: "Sources/SystemModule"
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"],
            path: "Tests/CoreTests"
        )
    ]
)
