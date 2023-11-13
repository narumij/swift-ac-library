import Foundation

struct scc_graph {
//  public:
    init() { `internal` = atcoder._internal.scc_graph.init(0) }
    init(_ n: Int) { `internal` = atcoder._internal.scc_graph.init(n) }

    mutating func add_edge(_ from: Int,_ to: Int) {
        let n = `internal`.num_vertices();
        assert(0 <= from && from < n);
        assert(0 <= to && to < n);
        `internal`.add_edge(from, to);
    }

    func scc() -> [[Int]] { return `internal`.scc(); }

//  private:
    var `internal`: _internal.scc_graph;
};
