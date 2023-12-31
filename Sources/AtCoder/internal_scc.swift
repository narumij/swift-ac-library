import Foundation

extension _Internal {
    
    struct scc_graph {
//      public:
        init(_ n: Int) { _n = n }

        func num_vertices() -> Int { return _n; }

        mutating func add_edge(_ from: Int,_ to: Int) { edges.append((from, .init(to: to))); }

        // @return pair of (# of scc, scc id)
        func scc_ids() -> (first: Int, second: [Int]) {
            let g = csr<edge>(_n, edges);
            var now_ord = 0, group_num = 0;
            var visited: [Int] = [], low = [Int](repeating: 0, count:_n), ord = [Int](repeating: -1, count:_n), ids = [Int](repeating: 0, count:_n);
            visited.reserveCapacity(_n);
            func dfs(_ v: Int) {
                low[v] = now_ord; ord[v] = now_ord; now_ord += 1
                visited.append(v);
//                for (int i = g.start[v]; i < g.start[v + 1]; i++) {
                for i in g.start[v]..<g.start[v + 1] {
                    let to = g.elist[i]!.to;
                    if (ord[to] == -1) {
                        dfs(to);
                        low[v] = min(low[v], low[to]);
                    } else {
                        low[v] = min(low[v], ord[to]);
                    }
                }
                if (low[v] == ord[v]) {
                    while (true) {
                        let u = visited.last!;
                        visited.removeLast();
                        ord[u] = _n;
                        ids[u] = group_num;
                        if (u == v) { break; }
                    }
                    group_num += 1;
                }
            };
//            for (int i = 0; i < _n; i++) {
            for i in 0..<_n {
                if (ord[i] == -1) { dfs(i); }
            }
//            for (auto& x : ids) {
//                x = group_num - 1 - x;
            for i in 0..<ids.endIndex {
                ids[i] = group_num - 1 - ids[i];
            }
            return (group_num, ids);
        }

        func scc() -> [[Int]] {
            let ids = scc_ids();
            let group_num = ids.first;
            var counts = [Int](repeating: 0, count: group_num);
//            for (auto x : ids.second) counts[x]++;
            for x in ids.second { counts[x] += 1; }
            var groups = [[Int]](repeating: [], count: ids.first);
//            for (int i = 0; i < group_num; i++) {
            for i in 0..<group_num {
                groups[i].reserveCapacity(counts[i]);
            }
//            for (int i = 0; i < _n; i++) {
            for i in 0..<_n {
                groups[ids.second[i]].append(i);
            }
            return groups;
        }

//      private:
        var _n: Int;
        struct edge {
            var to: Int
        }
        var edges: [(Int,edge)] = [];
    };
    
}
