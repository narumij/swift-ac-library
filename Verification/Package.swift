// swift-tools-version: 6.2
import PackageDescription

let package = Package(
  name: "LibraryCheckerVerification",
  dependencies: [.package(path: "..")],
  targets: [
    .executableTarget(
      name: "UnionFind",
      dependencies: [.product(name: "AtCoder", package: "swift-ac-library")],
      path: "UnionFind")
  ]
)
