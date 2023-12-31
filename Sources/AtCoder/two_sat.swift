import Foundation

public struct two_sat {
    var _n: Int
    var _answer: [Bool]
    var scc: _Internal.scc_graph
};

public extension two_sat {
    
    init() { _n = 0; _answer = []; scc = _Internal.scc_graph(0) }
    init(_ n: Int) {
        _n = n
        _answer = [Bool](repeating: false, count: n)
        scc = _Internal.scc_graph(2 * n)
    }
    mutating func add_clause(_ i: Int,_ f: Bool,_ j: Int,_ g: Bool) {
        assert(0 <= i && i < _n)
        assert(0 <= j && j < _n)
        scc.add_edge(2 * i + (f ? 0 : 1), 2 * j + (g ? 1 : 0))
        scc.add_edge(2 * j + (g ? 0 : 1), 2 * i + (f ? 1 : 0))
    }
    mutating func satisfiable() -> Bool {
        let id = scc.scc_ids().second
        for i in 0..<_n {
            if (id[2 * i] == id[2 * i + 1]) { return false }
            _answer[i] = id[2 * i] < id[2 * i + 1]
        }
        return true
    }
    func answer() -> [Bool] { return _answer }
}
