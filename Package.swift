// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

var defines: [String] = [
  //  "AC_LIBRARY_INTERNAL_CHECKS",
  //  "DISABLE_COPY_ON_WRITE",
  "USE_NON_COPYABLE"
]

var _settings: [SwiftSetting] =
  [
    // .define("COMPATIBLE_ATCODER_2025"),

    //    .define("USE_NON_COPYABLE"),

    .define("BENCHMARK", .when(traits: ["BENCHMARK"])),

    .define("DEATH_TEST", .when(platforms: [.macOS])),

    // 一応用意してあるが、あまり効果が無いどころか逆効果かもしれない
    .unsafeFlags(["-Ounchecked"], .when(configuration: .release, traits: ["_O_UNCHECKED"])),
  ] + defines.map { .define($0) }

// 環境変数 "SWIFT_AC_LIBRARY_USES_O_UNCHECKED" が存在するか確認
func isUncheckedModeEnabled() -> Bool {
  let flag = ProcessInfo.processInfo.environment["SWIFT_AC_LIBRARY_USES_O_UNCHECKED"] == "true"
  //    print("SWIFT_AC_LIBRARY_USES_O_UNCHECKED is \(flag ? "enabled" : "disabled")")
  return flag
}

let Ounchecked: [SwiftSetting] =
  isUncheckedModeEnabled()
  ? [
    // unsafeフラグがあるとパッケージの解決ではじかれる。利用するには迂回策が必要
    // https://github.com/ggerganov/whisper.spm/issues/4
    .unsafeFlags(["-Ounchecked"], .when(configuration: .release))
  ] : []

let package = Package(
  name: "swift-ac-library",
  //  platforms: [.macOS(.v14), .iOS(.v17), .tvOS(.v17), .watchOS(.v10), .macCatalyst(.v17)],
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
      from: "1.2.0"),
    .package(
      url: "https://github.com/apple/swift-collections",
      from: "1.2.0"),
    .package(
      url: "https://github.com/apple/swift-numerics",
      branch: "main"),
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
      swiftSettings: _settings + Ounchecked),
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
