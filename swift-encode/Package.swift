// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-encode",
    platforms: [
        .macOS(.v10_13)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.1"),
        .package(url: "https://github.com/JohnSundell/Files", from: "4.1.1"),
        .package(url: "https://github.com/jamf/Subprocess", from: "1.1.0"),
        .package(name: "SwiftProgressBar", path: "../swift-progress-bar")
    ],
    targets: [
        .target(
            name: "swift-encode",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Files", package: "Files"),
                .product(name: "Subprocess", package: "Subprocess"),
                .product(name: "SwiftProgressBar", package: "SwiftProgressBar")
            ]),
        .testTarget(
            name: "swift-encodeTests",
            dependencies: ["swift-encode"]),
    ]
)
