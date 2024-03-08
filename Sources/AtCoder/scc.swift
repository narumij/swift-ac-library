import Foundation

public struct SCCGraph {
    @usableFromInline var _internal: _Internal.scc_graph
}

public extension SCCGraph {
    
    @inlinable
    init() { _internal = _Internal.scc_graph.init(0) }
    
    @inlinable
    init(_ n: Int) { _internal = _Internal.scc_graph.init(n) }

    @inlinable
    mutating func add_edge(_ from: Int,_ to: Int) {
        let n = _internal.num_vertices()
        assert(0 <= from && from < n)
        assert(0 <= to && to < n)
        _internal.add_edge(from, to)
    }

    @inlinable
    func scc() -> [[Int]] { return _internal.scc() }
}
