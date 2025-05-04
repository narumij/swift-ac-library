import Foundation

/// Reference:
/// B. Aspvall, M. Plass, and R. Tarjan,
/// A Linear-Time Algorithm for Testing the Truth of Certain Quantified Boolean
/// Formulas
public struct TwoSAT {
  @usableFromInline let _n: Int
  @usableFromInline var _answer: [Bool]
  @usableFromInline var scc: _Internal.scc_graph
}

extension TwoSAT {

  @inlinable
  public init() {
    _n = 0
    _answer = []
    scc = .init(0)
  }

  @inlinable
  public init(_ n: Int) {
    _n = n
    _answer = [Bool](repeating: false, count: n)
    scc = .init(2 * n)
  }

  @inlinable
  public mutating func add_clause(_ i: Int, _ f: Bool, _ j: Int, _ g: Bool) {
    assert(0 <= i && i < _n)
    assert(0 <= j && j < _n)
    scc.add_edge(2 * i + (f ? 0 : 1), 2 * j + (g ? 1 : 0))
    scc.add_edge(2 * j + (g ? 0 : 1), 2 * i + (f ? 1 : 0))
  }

  @inlinable
  public mutating func satisfiable() -> Bool {
    let id = scc.scc_ids().scc
    for i in 0..<_n {
      if id[2 * i] == id[2 * i + 1] { return false }
      _answer[i] = id[2 * i] < id[2 * i + 1]
    }
    return true
  }

  @inlinable
  public func answer() -> [Bool] { return _answer }
}
