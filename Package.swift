// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

var defines: [String] = [
//  "AC_LIBRARY_INTERNAL_CHECKS",
//  "DISABLE_COPY_ON_WRITE",
]

var _settings: [SwiftSetting] = defines.map { .define($0) }

// フラグが原因でトラブるようなケースへの迂回策として環境変数での対処を盛り込んでいる
// 環境変数 "NOT_ATCODER_JUDGE_ENV" または "XCODE_VERSION_ACTUAL" が存在するか確認
func isUncheckedModeEnabled() -> Bool {
    let flag = ProcessInfo.processInfo.environment["SWIFT_USE_UNCHECKED"] == "true"
    print("SWIFT_USE_UNCHECKED is \(flag ? "enabled" : "disabled")")
    return flag
}

let Ounchecked: [SwiftSetting] = isUncheckedModeEnabled() ? [
  // unsafeフラグがあるとコンパイルではじかれる場合がある。
  // tag指定の場合そうなるが、revisions指定の場合通るようなので、再度トライすることに。
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
      swiftSettings: _settings + Ounchecked),
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
