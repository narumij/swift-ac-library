import Foundation

extension _Internal {
    
    /// Reference:
    /// R. Tarjan,
    /// Depth-First Search and Linear Graph Algorithms
    @usableFromInline
    struct scc_graph {
        
        @inlinable
        init(_ n: Int) { _n = n }

        @inlinable
        func num_vertices() -> Int { return _n }

        @inlinable
        mutating func add_edge(_ from: Int,_ to: Int) {
            edges.append((from, .init(to: to)))
        }

        /// @return pair of (# of scc, scc id)
        @inlinable
        func scc_ids() -> (number: Int, id: [Int]) {
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

        @inlinable
        func scc() -> [[Int]] {
            let ids = scc_ids()
            let group_num = ids.number
            var counts = [Int](repeating: 0, count: group_num)
            for x in ids.id { counts[x] += 1 }
            var groups = [[Int]](repeating: [], count: ids.number)
            for i in 0 ..< group_num {
                groups[i].reserveCapacity(counts[i])
            }
            for i in 0 ..< _n {
                groups[ids.id[i]].append(i)
            }
            return groups
        }

        @usableFromInline let _n: Int
        
        @usableFromInline struct edge {
            public init(to: Int) { self.to = to }
            public let to: Int
        }
        
        @usableFromInline var edges: [(Int,edge)] = []
    }
}
