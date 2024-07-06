import Foundation

public struct SCCGraph {
    public init() { __internal = .init(0) }
    public init<Index: FixedWidthInteger>(_ n: Index) { __internal = .init(Int(n)) }

    public mutating func add_edge<Index: FixedWidthInteger>(_ from: Index,_ to: Index) {
        let from = Int(from)
        let to = Int(to)
        let n = __internal.num_vertices();
        assert(0 <= from && from < n);
        assert(0 <= to && to < n);
        __internal.add_edge(from, to);
    }

    public func scc() -> [[Int]] { return __internal.scc(); }

    var __internal: _Internal.scc_graph<CInt>;
};
