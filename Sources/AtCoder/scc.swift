import Foundation

public struct SCCGraph {

  @inlinable
  public init() { _internal = .init(0) }

  @inlinable
  public init(_ n: Int) { _internal = .init(n) }

  @inlinable
  public mutating func add_edge(_ from: Int, _ to: Int) {
    let n = _internal.num_vertices()
    assert(0 <= from && from < n)
    assert(0 <= to && to < n)
    _internal.add_edge(from, to)
  }

  @inlinable
  public func scc() -> [[Int]] { return _internal.scc() }

  // CIntをしばらくつかっていたが、キャストのオーバーヘッドを懸念して、Intに切り替えている(2025/1/2)
  // TODO: 十分にテストできたのち、scc_graphの型変数を取り除くリファクタリングをすること
  @usableFromInline
  var _internal: _Internal.scc_graph<Int>
}
