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
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.4"),
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "atcoder",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
            ]),
        .testTarget(
            name: "atcoderTests",
            dependencies: [
                "atcoder",
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Algorithms", package: "swift-algorithms"),
            ]),
    ]
)
