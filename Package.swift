// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "Select",
    products: [
        .library(
            name: "Select",
            targets: ["Select"]),
    ],
    targets: [
        .target(
            name: "Select",
            dependencies: []),
        .testTarget(
            name: "SelectTests",
            dependencies: ["Select"]),
    ]
)
