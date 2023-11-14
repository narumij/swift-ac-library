import Foundation

struct two_sat {
//  public:
    init() { _n = 0; _answer = []; scc = _internal.scc_graph(0) }
    init<Index: FixedWidthInteger>(_ n: Index) { let n = Int(n); _n = n; _answer = [Bool](repeating: false, count: n); scc = _internal.scc_graph(2 * n) }

    mutating func add_clause<Index: FixedWidthInteger>(_ i: Index,_ f: Bool,_ j: Index,_ g: Bool) {
        let i = Int(i)
        let j = Int(j)
        assert(0 <= i && i < _n);
        assert(0 <= j && j < _n);
        scc.add_edge(2 * i + (f ? 0 : 1), 2 * j + (g ? 1 : 0));
        scc.add_edge(2 * j + (g ? 0 : 1), 2 * i + (f ? 1 : 0));
    }
    mutating func satisfiable() -> Bool {
        let id = scc.scc_ids().second;
//        for (int i = 0; i < _n; i++) {
        for i in 0..<_n {
            if (id[2 * i] == id[2 * i + 1]) { return false; }
            _answer[i] = id[2 * i] < id[2 * i + 1];
        }
        return true;
    }
    func answer() -> [Bool] { return _answer; }

//  private:
    private var _n: Int;
    private var _answer: [Bool];
    private var scc: _internal.scc_graph;
};
