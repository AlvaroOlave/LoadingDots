// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoadingDots",
    platforms: [.iOS(.v8)],
    products: [
        .library(
            name: "LoadingDots",
            targets: ["LoadingDots"]),
    ],
    targets: [
        .target(
            name: "LoadingDots",
            dependencies: []),
    ]
)
