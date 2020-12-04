// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftProgressBar",
    products: [
        .library(
            name: "SwiftProgressBar",
            targets: ["SwiftProgressBar"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftProgressBar",
            dependencies: []),
        .testTarget(
            name: "SwiftProgressBarTests",
            dependencies: ["SwiftProgressBar"]),
    ]
)
