// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-ac-library",
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "AtCoder",
      targets: ["AtCoder"])
  ],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-algorithms.git",
      .upToNextMajor(from: "1.2.0")),
    .package(
      url: "https://github.com/apple/swift-collections.git",
      .upToNextMajor(from: "1.1.4")),
    .package(
      url: "https://github.com/apple/swift-numerics",
      branch: "main"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "AtCoder",
      dependencies: [
        .product(name: "Collections", package: "swift-collections")
      ]),
    .testTarget(
      name: "AtCoderTests",
      dependencies: [
        "AtCoder",
        .product(name: "Algorithms", package: "swift-algorithms"),
        .product(name: "Collections", package: "swift-collections"),
        .product(name: "Numerics", package: "swift-numerics"),
      ]),
  ]
)
