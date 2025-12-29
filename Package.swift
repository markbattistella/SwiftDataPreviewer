// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SwiftDataPreviewer",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1),
        .macCatalyst(.v17),
    ],
    products: [
        .library(name: "SwiftDataPreviewer", targets: ["SwiftDataPreviewer"])
    ],
    dependencies: [
        .package(url: "https://github.com/markbattistella/SimpleLogger", from: "25.12.0")
    ],
    targets: [
        .target(name: "SwiftDataPreviewer", dependencies: ["SimpleLogger"])
    ]
)
