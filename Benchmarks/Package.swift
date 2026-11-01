// swift-tools-version: 6.2
import Foundation
import PackageDescription
let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().path
let package = Package(
  name: "ACLBenchmarks",
  platforms: [.macOS(.v15)],
  dependencies: [
    .package(path: ".."),
    .package(url: "https://github.com/apple/swift-collections-benchmark", revision: "e9e8df493e3d8f9285103415176e52966c37a764"),
  ],
  targets: [
    .target(name: "CppACL", cxxSettings: [
      .unsafeFlags(["-I" + root + "/.build/ac-library"]),
      .define("NDEBUG", .when(configuration: .release)),
      .unsafeFlags(["-O3"], .when(configuration: .release)),
    ]),
    .executableTarget(name: "benchmark", dependencies: [
      "CppACL", .product(name: "AtCoder", package: "swift-ac-library"),
      .product(name: "CollectionsBenchmark", package: "swift-collections-benchmark"),
    ]),
  ],
  cxxLanguageStandard: .cxx17
)
