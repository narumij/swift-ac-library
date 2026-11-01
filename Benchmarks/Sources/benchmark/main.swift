import AtCoder
import CollectionsBenchmark
import CppACL

// Fixed SplitMix64 stream: identical inputs for Swift and C++, independent of task order.
struct Input {
  let a: [Int]
  let b: [Int]
  init(_ count: Int) {
    var state: UInt64 = 0xAC1_2026
    func next() -> Int {
      state &+= 0x9e3779b97f4a7c15
      var z = state
      z = (z ^ (z >> 30)) &* 0xbf58476d1ce4e5b9
      z = (z ^ (z >> 27)) &* 0x94d049bb133111eb
      return Int((z ^ (z >> 31)) % UInt64(count))
    }
    a = (0..<count).map { _ in next() }
    b = (0..<count).map { _ in next() }
  }
}

enum Sum: SegTreeOperator {
  static var e: Int { 0 }
  static func op(_ a: Int, _ b: Int) -> Int { a + b }
}

enum Scenario: String, CaseIterable {
  case dsu = "DSU merge and size"
  case update = "SegTree random updates"
  case query = "SegTree range sums"

  func swift(_ input: Input) -> [Int] {
    let n = input.a.count
    var out = [Int](repeating: 0, count: n)
    switch self {
    case .dsu:
      var tree = DSU(n)
      for i in 0..<n {
        _ = tree.merge(input.a[i], input.b[i])
        out[i] = tree.size(input.a[i])
      }
    case .update:
      var tree = SegTree<Sum>(n)
      for i in 0..<n {
        tree.set(input.a[i], input.b[i])
        out[i] = tree.all_prod()
      }
    case .query:
      let tree = SegTree<Sum>([Int](repeating: 1, count: n))
      for i in 0..<n {
        out[i] = tree.prod(min(input.a[i], input.b[i]), max(input.a[i], input.b[i]) + 1)
      }
    }
    return out
  }

  func cpp(_ input: Input) -> [Int] {
    var out = [Int](repeating: 0, count: input.a.count)
    input.a.withUnsafeBufferPointer { a in
      input.b.withUnsafeBufferPointer { b in
        out.withUnsafeMutableBufferPointer { result in
          switch self {
          case .dsu: acl_dsu(a.count, a.baseAddress, b.baseAddress, result.baseAddress)
          case .update: acl_seg_update(a.count, a.baseAddress, b.baseAddress, result.baseAddress)
          case .query: acl_seg_query(a.count, a.baseAddress, b.baseAddress, result.baseAddress)
          }
        }
      }
    }
    return out
  }
}

if CommandLine.arguments.dropFirst().first == "verify-flow-phases" {
  verifyFlowPhases()
} else if CommandLine.arguments.dropFirst().first == "verify-extended" {
  verifyExtended()
} else if CommandLine.arguments.dropFirst().first == "verify" {
  for n in [1, 2, 3, 17, 256, 4096, 65536] {
    let input = Input(n)
    for scenario in Scenario.allCases {
      let actual = scenario.swift(input)
      precondition(actual == scenario.cpp(input), "Mismatch: \(scenario.rawValue), n=\(n)")
      if scenario == .query {
        precondition(actual == zip(input.a, input.b).map { abs($0 - $1) + 1 })
      }
      print("PASS \(scenario.rawValue), n=\(n)")
    }
  }
} else {
  var benchmark = Benchmark(title: "swift-ac-library vs C++ AtCoder Library")
  benchmark.registerInputGenerator(for: Input.self) { Input($0) }
  for scenario in Scenario.allCases {
    benchmark.addSimple(title: "Swift " + scenario.rawValue, input: Input.self) { input in
      blackHole(scenario.swift(input))
    }
    benchmark.addSimple(title: "C++ " + scenario.rawValue, input: Input.self) { input in
      blackHole(scenario.cpp(input))
    }
  }
  benchmark.addExtended()
  benchmark.addFlowPhases()
  benchmark.main()
}
