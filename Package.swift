// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FlipText",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v10),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "FlipText",
            targets: ["FlipText"])
    ],
    targets: [
        .target(
            name: "FlipText",
            dependencies: []),
        .testTarget(
            name: "FlipTextTests",
            dependencies: ["FlipText"])
    ]
)
