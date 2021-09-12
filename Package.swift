// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "SwiftNes",
    products: [
        .library(name: "SwiftNes", targets: ["SwiftNes"]),
        .executable(name: "SwiftNesMain", targets: ["SwiftNesMain"])
    ],
    dependencies: [
        
    ],
    targets: [
        .target(name: "SwiftNes"),
        .executableTarget(name: "SwiftNesMain", dependencies: [
            .target(name: "SwiftNes"),
        ]),
        .testTarget(name: "SwiftNesTests", dependencies: ["SwiftNes"]),
    ]
)
