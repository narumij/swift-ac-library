import Foundation
import AtCoder
import CollectionsBenchmark
import CppACL

struct Cell { var sum: Int; var count: Int }
enum RangeAdd: LazySegTreeOperator {
  static var e: Cell { Cell(sum: 0, count: 0) }
  static var id: Int { 0 }
  static func op(_ a: Cell, _ b: Cell) -> Cell { Cell(sum: a.sum &+ b.sum, count: a.count &+ b.count) }
  static func mapping(_ f: Int, _ x: Cell) -> Cell { Cell(sum: x.sum &+ (f &* x.count), count: x.count) }
  static func composition(_ f: Int, _ g: Int) -> Int { f &+ g }
}

enum Extended: Int32, CaseIterable {
  case fenwick, lazy, scc, sat, flow, cost, convolution, suffix, z, modint
  var title: String {
    ["Fenwick add and prefix sum", "LazySegTree range add and sum", "SCC grouped cycles",
     "TwoSAT planted clauses", "MaxFlow sparse network", "MinCostFlow sparse network",
     "Convolution modulo 998244353", "Suffix array alphabet 26", "Z algorithm alphabet 26",
     "ModInt multiply and add"][Int(rawValue)]
  }
  var maxSize: Int {
    switch self {
    case .cost: return 1024
    case .flow: return 32768
    case .scc, .sat: return 131072
    case .convolution, .suffix, .z, .lazy: return 262144
    default: return 2097152
    }
  }
  func outputCount(_ n: Int) -> Int {
    switch self {
    case .sat, .flow: return 1
    case .cost: return 2
    case .convolution: return 2*n-1
    default: return n
    }
  }
  func cpp(_ input: Input) -> [Int] {
    var out = [Int](repeating: 0, count: outputCount(input.a.count))
    input.a.withUnsafeBufferPointer { a in
      input.b.withUnsafeBufferPointer { b in
        out.withUnsafeMutableBufferPointer { result in
          acl_extra(rawValue, a.count, a.baseAddress, b.baseAddress, result.baseAddress)
        }
      }
    }
    return out
  }
  func swift(_ input: Input) -> [Int] {
    let a = input.a, b = input.b, n = a.count
    var out = [Int](repeating: 0, count: outputCount(n))
    switch self {
    case .fenwick:
      var t = FenwickTree<Int>(n)
      for i in 0..<n { t.add(a[i], b[i]); out[i] = t.sum(0, a[i]+1) }
    case .lazy:
      var t = LazySegTree<RangeAdd>([Cell](repeating: Cell(sum: 0, count: 1), count: n))
      for i in 0..<n {
        let l = min(a[i],b[i]), r = max(a[i],b[i])+1
        t.apply(l,r,1); out[i] = t.prod(l,r).sum
      }
    case .scc:
      var g = SCCGraph(n)
      for i in 0..<n {
        let start = i/16*16, end = min(start+16,n)
        g.add_edge(i,i+1 < end ? i+1 : start)
        if a[i]/16 != b[i]/16 { g.add_edge(min(a[i],b[i]),max(a[i],b[i])) }
      }
      for group in g.scc() { let label = group.min()!; for v in group { out[v] = label } }
    case .sat:
      var g = TwoSAT(n)
      for i in 0..<n { g.add_clause(a[i],a[i]%2 == 0,b[i],i%2 == 0) }
      out[0] = g.satisfiable() ? 1 : 0
    case .flow:
      var g = MFGraph<Int>(count: n+2)
      for i in 0..<n {
        _ = g.add_edge(0,i+1,a[i]%16+1); _ = g.add_edge(i+1,n+1,b[i]%16+1)
        if i+1<n { _ = g.add_edge(i+1,i+2,8) }
      }
      out[0] = g.flow(0,n+1)
    case .cost:
      var g = MCFGraph<Int,Int>(count: n+2)
      for i in 0..<n {
        _ = g.add_edge(0,i+1,a[i]%16+1,0); _ = g.add_edge(i+1,n+1,b[i]%16+1,b[i]%8)
        if i+1<n { _ = g.add_edge(i+1,i+2,8,1) }
      }
      let result = g.flow(0,n+1); out[0] = result.0; out[1] = result.1
    case .convolution:
      out = AtCoder.convolution(mod_998_244_353.self,a.map { $0%100 },b.map { $0%100 })
    case .suffix:
      out = suffix_array(a.map { $0%26 },25)
    case .z:
      out = z_algorithm(a.map { $0%26 })
    case .modint:
      var x = modint998244353(1)
      for i in 0..<n { x = x * modint998244353(a[i]) + modint998244353(b[i]); out[i] = x.val }
    }
    return out
  }
}

func verifyExtended() {
  var failures: [String] = []
  for scenario in Extended.allCases {
    for n in Array(Set([1,2,3,17,256,min(4096,scenario.maxSize),scenario.maxSize])).sorted() {
      let input = Input(n)
      let actual = scenario.swift(input), expected = scenario.cpp(input)
      if actual != expected {
        print("FAIL \(scenario.title), n=\(n), Swift \(actual.prefix(4)), C++ \(expected.prefix(4))")
        failures.append(scenario.title); break
      }
      if scenario == .scc { precondition(actual == (0..<n).map { $0/16*16 }) }
      if scenario == .sat { precondition(actual == [1]) }
      print("PASS \(scenario.title), n=\(n)")
    }
  }
  if !failures.isEmpty { print("MISMATCHES: \(failures.joined(separator: ", "))"); exit(1) }
}

extension Benchmark {
  mutating func addExtended() {
    for scenario in Extended.allCases {
      addSimple(title: "Swift " + scenario.title, input: Input.self, maxSize: scenario.maxSize) { blackHole(scenario.swift($0)) }
      addSimple(title: "C++ " + scenario.title, input: Input.self, maxSize: scenario.maxSize) { blackHole(scenario.cpp($0)) }
    }
  }
}
