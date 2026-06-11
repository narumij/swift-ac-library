// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

var defines: [String] = []

var _settings: [SwiftSetting] =
  [
    .define("BENCHMARK", .when(traits: ["BENCHMARK"])),

    .define("DEATH_TEST", .when(platforms: [.macOS])),

    .unsafeFlags(["-Ounchecked"], .when(configuration: .release, traits: ["_O_UNCHECKED"])),

  ] + defines.map { .define($0) }

let package = Package(
  name: "swift-ac-library",
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "AtCoder",
      targets: ["AtCoder"])
  ],
  traits: [
    .trait(
      name: "BENCHMARK"
    ),
    .trait(
      name: "_O_UNCHECKED"
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-algorithms",
      from: "1.2.1"),
    .package(
      url: "https://github.com/apple/swift-collections",
      from: "1.6.0"),
    .package(
      url: "https://github.com/apple/swift-numerics",
      from: "1.1.1"),
    .package(
      url: "https://github.com/attaswift/BigInt",
      from: "5.6.0"),
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
        .product(name: "Numerics", package: "swift-numerics"),
        .product(name: "BigInt", package: "BigInt"),
      ],
      swiftSettings: _settings),
    .executableTarget(
      name: "Executable",
      dependencies: [
        "AtCoder"
      ],
      path: "Tests/Executable",
      swiftSettings: _settings
    ),
    .executableTarget(
      name: "TopLevel",
      dependencies: [
        "AtCoder"
      ],
      path: "Tests/TopLevel",
      swiftSettings: _settings
    ),
  ]
)
