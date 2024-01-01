import Foundation

public struct SCCGraph {
    var _internal: _Internal.scc_graph
}

public extension SCCGraph {
    
    init() { _internal = _Internal.scc_graph.init(0) }
    init(_ n: Int) { _internal = _Internal.scc_graph.init(n) }

    mutating func addEdge(_ from: Int,_ to: Int) {
        let n = _internal.num_vertices()
        assert(0 <= from && from < n)
        assert(0 <= to && to < n)
        _internal.add_edge(from, to)
    }

    func scc() -> [[Int]] { return _internal.scc() }
}
