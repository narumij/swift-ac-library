import Foundation

extension _Internal {
    
    struct scc_graph {
        
        init(_ n: Int) { _n = n }

        func num_vertices() -> Int { return _n }

        mutating func add_edge(_ from: Int,_ to: Int) {
            edges.append((from, .init(to: to)))
        }

        // @return pair of (# of scc, scc id)
        func scc_ids() -> (first: Int, second: [Int]) {
            let g = csr<edge>(_n, edges)
            var now_ord = 0, group_num = 0
            var visited = [Int](), low = [Int](repeating: 0, count:_n)
            var ord = [Int?](repeating: nil, count:_n), ids = [Int](repeating: 0, count:_n)
            visited.reserveCapacity(_n)
            func dfs(_ v: Int) {
                low[v] = now_ord; ord[v] = now_ord; now_ord += 1
                visited.append(v)
                for i in g.start[v] ..< g.start[v + 1] {
                    let to = g.elist[i]!.to
                    if ord[to] == nil {
                        dfs(to)
                        low[v] = min(low[v], low[to])
                    } else {
                        low[v] = min(low[v], ord[to]!)
                    }
                }
                if low[v] == ord[v] {
                    while true {
                        let u = visited.popLast()!
                        ord[u] = _n
                        ids[u] = group_num
                        if u == v { break }
                    }
                    group_num += 1
                }
            }
            for i in 0 ..< _n where ord[i] == nil {
                dfs(i)
            }
            ids = ids.map { x in
                group_num - 1 - x
            }
            return (group_num, ids)
        }

        func scc() -> [[Int]] {
            let ids = scc_ids()
            let group_num = ids.first
            var counts = [Int](repeating: 0, count: group_num)
            for x in ids.second { counts[x] += 1 }
            var groups = [[Int]](repeating: [], count: ids.first)
            for i in 0 ..< group_num {
                groups[i].reserveCapacity(counts[i])
            }
            for i in 0 ..< _n {
                groups[ids.second[i]].append(i)
            }
            return groups
        }

        let _n: Int
        struct edge {
            let to: Int
        }
        var edges: [(Int,edge)] = []
    }
}
