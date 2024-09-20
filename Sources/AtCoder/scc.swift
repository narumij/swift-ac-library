import Foundation

public struct SCCGraph {

  @inlinable
  public init() { __internal = .init(0) }

  @inlinable
  public init<Index: FixedWidthInteger>(_ n: Index) { __internal = .init(Int(n)) }

  @inlinable
  public mutating func add_edge<Index: FixedWidthInteger>(_ from: Index, _ to: Index) {
    let from = Int(from)
    let to = Int(to)
    let n = __internal.num_vertices()
    assert(0 <= from && from < n)
    assert(0 <= to && to < n)
    __internal.add_edge(from, to)
  }

  @inlinable
  public func scc() -> [[Int]] { return __internal.scc() }

  @usableFromInline
  var __internal: _Internal.scc_graph<CInt>
}
