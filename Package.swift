// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Select",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .library(
            name: "Select",
            targets: ["Select"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JochenBe/Terminal", branch: "main")
    ],
    targets: [
        .target(
            name: "Select",
            dependencies: ["Terminal"]),
        .testTarget(
            name: "SelectTests",
            dependencies: ["Select"]),
    ]
)
