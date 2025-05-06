// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

var defines: [String] = [
//  "AC_LIBRARY_INTERNAL_CHECKS",
//  "DISABLE_COPY_ON_WRITE",
]

var _settings: [SwiftSetting] = defines.map { .define($0) } + [
  .enableExperimentalFeature("ValueGenerics"),
  .unsafeFlags(["-Xfrontend", "-disable-availability-checking"])
]

// 環境変数 "SWIFT_AC_LIBRARY_USES_O_UNCHECKED" が存在するか確認
func isUncheckedModeEnabled() -> Bool {
    let flag = ProcessInfo.processInfo.environment["SWIFT_AC_LIBRARY_USES_O_UNCHECKED"] == "true"
    print("SWIFT_AC_LIBRARY_USES_O_UNCHECKED is \(flag ? "enabled" : "disabled")")
    return flag
}

let Ounchecked: [SwiftSetting] = isUncheckedModeEnabled() ? [
  // unsafeフラグがあるとパッケージの解決ではじかれる。利用するには迂回策が必要
  // https://github.com/ggerganov/whisper.spm/issues/4
  .unsafeFlags(["-Ounchecked"], .when(configuration: .release))
] : []

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
      url: "https://github.com/apple/swift-algorithms",
      exact: "1.2.0"),
    .package(
      url: "https://github.com/apple/swift-collections",
      exact: "1.1.4"),
    .package(
      url: "https://github.com/apple/swift-numerics",
      revision: "e30276bff2ff5ed80566fbdca49f50aa160b0e83"),
//      branch: "main"), // e30276b (after 1.0.2)
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
      ],
      swiftSettings: _settings),
  ]
)
