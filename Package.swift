// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SwiftNES",
    dependencies: [
        
    ],
    targets: [
        .executableTarget(name: "SwiftNES", dependencies: []),
        .testTarget(name: "SwiftNESTests", dependencies: ["SwiftNES"]),
    ]
)
