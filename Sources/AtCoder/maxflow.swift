import Foundation
import Collections

public struct mf_graph<Cap: FixedWidthInteger> {
//  public:
    public init() { _n = 0; g = [] }
    public init<Index: FixedWidthInteger>(_ n: Index) { _n = Int(n); g = [[_edge]].init(repeating: [], count: Int(n)) }

    @discardableResult
    public mutating func add_edge<Index: FixedWidthInteger>(_ from: Index,_ to: Index,_ cap: Cap) -> Int {
        let from = Int(from)
        let to = Int(to)
        assert(0 <= from && from < _n);
        assert(0 <= to && to < _n);
        assert(0 <= cap);
        let m = pos.count;
        pos.append((from, g[from].count));
        let from_id = g[from].count;
        var to_id = g[to].count;
        if (from == to) { to_id += 1; }
        g[from].append(_edge(to, to_id, cap));
        g[to].append(_edge(from, from_id, 0));
        return m;
    }

    public struct edge {
        init() {
            self.init(0, 0, 0, 0)
        }
        internal init(_ from: Int,_ to: Int,_ cap: Cap,_ flow: Cap) {
            self.from = from
            self.to = to
            self.cap = cap
            self.flow = flow
        }
        public var from, to: Int;
        public var cap, flow: Cap;
    };

    public func get_edge<Index: FixedWidthInteger>(_ i: Index) -> edge {
        let i = Int(i)
        let m = pos.count;
        assert(0 <= i && i < m);
        let _e = g[pos[i].first][pos[i].second];
        let _re = g[_e.to][_e.rev];
        return edge(pos[i].first, _e.to, _e.cap + _re.cap, _re.cap);
    }
    public func edges() -> [edge] {
        let m = pos.count;
        var result: [edge] = [];
//        for (int i = 0; i < m; i++) {
        for i in 0..<m {
            result.append(get_edge(i));
        }
        return result;
    }
    public mutating func change_edge<Index: FixedWidthInteger>(_ i: Index,_ new_cap: Cap,_ new_flow: Cap) {
        let i = Int(i)
        let m = pos.count;
        assert(0 <= i && i < m);
        assert(0 <= new_flow && new_flow <= new_cap);
        var _e = g[pos[i].first][pos[i].second];
        var _re = g[_e.to][_e.rev];
        _e.cap = new_cap - new_flow;
        _re.cap = new_flow;
        g[pos[i].first][pos[i].second] = _e
        g[_e.to][_e.rev] = _re
    }

    public mutating func flow<Index: FixedWidthInteger>(_ s: Index,_ t: Index) -> Cap {
        return flow(s, t, Cap.max);
    }
    public mutating func flow<Index: FixedWidthInteger>(_ s: Index,_ t: Index,_ flow_limit: Cap) -> Cap {
        let s = Int(s)
        let t = Int(t)
        assert(0 <= s && s < _n);
        assert(0 <= t && t < _n);
        assert(s != t);

        var level = [Int](repeating: 0, count:_n), iter = [Int](repeating: 0, count:_n);
        var que = Deque<Int>()

        func bfs() {
//            std::fill(level.begin(), level.end(), -1);
            level.withUnsafeMutableBufferPointer{ $0.update(repeating: -1) }
            level[s] = 0;
            que.removeAll();
            que.append(s);
            while let v = que.popFirst() {
                for e in g[v] {
                    if (e.cap == 0 || level[e.to] >= 0) { continue; }
                    level[e.to] = level[v] + 1;
                    if (e.to == t) { return; }
                    que.append(e.to);
                }
            }
        };
        func dfs(_ v: Int,_ up: Cap) -> Cap {
            if (v == s) { return up; }
            var res: Cap = 0;
            let level_v = level[v];
//            for (int& i = iter[v]; i < int(g[v].size()); i++) {
            for i in iter[v]..<g[v].count {
                let e = g[v][i];
                if (level_v <= level[e.to] || g[e.to][e.rev].cap == 0) { continue; }
                let d =
                    dfs(e.to, min(up - res, g[e.to][e.rev].cap));
                if (d <= 0) { continue; }
                g[v][i].cap += d;
                do {
                    let e = g[v][i];
                    g[e.to][e.rev].cap -= d;
                }
                res += d;
                if (res == up) { return res; }
            }
            level[v] = _n;
            return res;
        };

        var flow: Cap = 0;
        while (flow < flow_limit) {
            bfs();
            if (level[t] == -1) { break; }
//            std::fill(iter.begin(), iter.end(), 0);
            iter.withUnsafeMutableBufferPointer{ $0.update(repeating: 0) }
            let f = dfs(t, flow_limit - flow);
            if (!(f != 0)) { break; }
            flow += f;
        }
        return flow;
    }

    public func min_cut<Index: FixedWidthInteger>(_ s: Index) -> [Bool] {
        let s = Int(s)
        var visited = [Bool](repeating: false, count:_n);
        var que = Deque<Int>()
        que.append(s);
        while let p = que.popFirst() {
            visited[p] = true;
            for e in g[p] {
                if (e.cap != 0 && !visited[e.to]) {
                    visited[e.to] = true;
                    que.append(e.to);
                }
            }
        }
        return visited;
    }

//  private:
    private let _n: Int;
    struct _edge {
        internal init(_ to: Int,_ rev: Int,_ cap: Cap) {
            self.to = to
            self.rev = rev
            self.cap = cap
        }
        var to, rev: Int;
        var cap: Cap;
    };
    private var pos: [(first: Int, second: Int)] = []
    private var g: [[_edge]]
};

