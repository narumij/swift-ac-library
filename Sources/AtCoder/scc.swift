import Foundation

#if USE_NON_COPYABLE
  @frozen
  public struct SCCGraph {

    @inlinable
    public init() { _internal = .init(0) }

    @inlinable
    public init(_ n: Int) { _internal = .init(n) }

    @inlinable
    public mutating func add_edge(_ from: Int, _ to: Int) {
      #if DEBUG
        let n = _internal.num_vertices()
        assert(0 <= from && from < n)
        assert(0 <= to && to < n)
      #endif
      _internal.add_edge(from, to)
    }

    @inlinable
    public func scc() -> [[Int]] { return _internal.scc() }

    @usableFromInline
    var _internal: _Internal.scc_graph
  }
#endif

extension SCCGraph: @unchecked Sendable {}
