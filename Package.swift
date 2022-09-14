// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "Select",
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
