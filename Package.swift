// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "atcoder",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "atcoder",
            targets: ["atcoder"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.1.0"),
        .package(url: "https://github.com/johnno1962/Fortify", from: "1.0.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "atcoder"),
        .testTarget(
            name: "atcoderTests",
            dependencies: [
                "atcoder",
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Fortify", package: "Fortify"),
            ]),
    ]
)
