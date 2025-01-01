// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var defines: [String] = [
  "AC_LIBRARY_INTERNAL_CHECKS",
//  "DISABLE_COPY_ON_WRITE",
]

var _settings: [SwiftSetting] = defines.map { .define($0) }

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
      from: "1.2.0"),
    .package(
      url: "https://github.com/apple/swift-collections.git",
      from: "1.1.4"),
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
      ],
      swiftSettings: _settings),
    .testTarget(
      name: "AtCoderTests",
      dependencies: [
        "AtCoder",
        .product(name: "Algorithms", package: "swift-algorithms"),
        .product(name: "Collections", package: "swift-collections"),
        .product(name: "Numerics", package: "swift-numerics"),
      ],
      swiftSettings: _settings),
  ]
)
