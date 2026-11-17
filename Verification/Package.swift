// swift-tools-version: 6.2
import PackageDescription

let problems = [
  "UnionFind", "PointAddRangeSum", "SumOfFloorOfLinear", "Convolution",
  "StronglyConnectedComponents", "NumberOfSubstrings", "RangeAffineRangeSum",
  "SuffixArray",
  "ZAlgorithm",
  "PointSetRangeComposite",
  "BipartiteMatching",
  "Assignment",
  "TwoSAT",
  "BinomialCoefficientPrimeMod",
  "BinomialCoefficientPrimeModPow",
  "ConvolutionMod1000000007",
]

let package = Package(
  name: "LibraryCheckerVerification",
  dependencies: [.package(path: "..")],
  targets: [.target(name: "VerificationIO", path: "VerificationIO")]
    + problems.map { name in
      .executableTarget(
        name: name,
        dependencies: [
          "VerificationIO",
          .product(name: "AtCoder", package: "swift-ac-library"),
        ],
        path: name)
    }
)
