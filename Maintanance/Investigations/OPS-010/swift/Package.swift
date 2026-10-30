// swift-tools-version: 6.2
import PackageDescription
let package = Package(name: "ACLComparison", dependencies: [.package(url: "https://github.com/apple/swift-collections", exact: "1.6.0"), .package(path: "../../../..")], targets: [.executableTarget(name: "Compare", dependencies: [.product(name: "AtCoder", package: "swift-ac-library")])])
