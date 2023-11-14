import Foundation

public struct scc_graph {
//  public:
    public init() { `internal` = _internal.scc_graph.init(0) }
    public init<Index: FixedWidthInteger>(_ n: Index) { `internal` = _internal.scc_graph.init(Int(n)) }

    public mutating func add_edge<Index: FixedWidthInteger>(_ from: Index,_ to: Index) {
        let from = Int(from)
        let to = Int(to)
        let n = `internal`.num_vertices();
        assert(0 <= from && from < n);
        assert(0 <= to && to < n);
        `internal`.add_edge(from, to);
    }

    public func scc() -> [[Int]] { return `internal`.scc(); }

//  private:
    var `internal`: _internal.scc_graph;
};
