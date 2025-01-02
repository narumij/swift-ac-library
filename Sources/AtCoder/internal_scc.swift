import Foundation

extension _Internal {

  @usableFromInline
  struct scc_graph<edge: FixedWidthInteger> {

    @inlinable
    public init(_ n: Int) { _n = n }

    @inlinable
    public func num_vertices() -> Int { return _n }

    @inlinable
    public mutating func add_edge(_ from: Int, _ to: Int) { edges.append((from, edge(to))) }

    // @return pair of (# of scc, scc id)
    @inlinable
    public func scc_ids() -> (number_of_scc: Int, scc: [Int]) {
      let g = _Internal.csr<edge>(_n, edges)
      var now_ord = 0
      var group_num = 0
      var visited: [edge] = []
      var low = [Int](repeating: 0, count: _n)
      var ord = [Int](repeating: -1, count: _n)
      var ids = [Int](repeating: 0, count: _n)
      visited.reserveCapacity(_n)
      func dfs(_ v: edge) {
        low[Int(v)] = now_ord
        ord[Int(v)] = now_ord
        now_ord += 1
        visited.append(v)
        for i in g.start[Int(v)]..<g.start[Int(v) + 1] {
          let to = g.elist[i]
          if ord[Int(to)] == -1 {
            dfs(to)
            low[Int(v)] = min(low[Int(v)], low[Int(to)])
          } else {
            low[Int(v)] = min(low[Int(v)], ord[Int(to)])
          }
        }
        if low[Int(v)] == ord[Int(v)] {
          while true {
            let u = visited.last!
            visited.removeLast()
            ord[Int(u)] = _n
            ids[Int(u)] = group_num
            if u == v { break }
          }
          group_num += 1
        }
      }
      for i in 0..<edge(_n) {
        if ord[Int(i)] == -1 { dfs(i) }
      }
      for i in 0..<ids.endIndex {
        ids[i] = group_num - 1 - ids[i]
      }
      return (group_num, ids)
    }

    @inlinable
    public func scc() -> [[Int]] {
      let ids = scc_ids()
      let group_num = ids.number_of_scc
      var counts = [Int](repeating: 0, count: group_num)
      for x in ids.scc { counts[x] += 1 }
      var groups = [[Int]](repeating: [], count: ids.number_of_scc)
      for i in 0..<group_num {
        groups[i].reserveCapacity(counts[i])
      }
      for i in 0..<_n {
        groups[ids.scc[i]].append(i)
      }
      return groups
    }

    @usableFromInline
    var _n: Int
    public typealias edge = edge
    @usableFromInline
    var edges: [(Int, edge)] = []
  }

}
