import Foundation

extension _Internal {

  @usableFromInline
  struct scc_graph {

    @inlinable @inline(__always)
    public init(_ n: Int) {
      _n = n
      edges.reserveCapacity(_n)
    }

    @inlinable @inline(__always)
    public func num_vertices() -> Int { return _n }

    @inlinable @inline(__always)
    public mutating func add_edge(_ from: Int, _ to: Int) { edges.append((from, edge(to))) }

    // @return pair of (# of scc, scc id)
    @inlinable @inline(never)
    public func scc_ids() -> (number_of_scc: Int, scc: [Int]) {
      let g = _Internal.csr<edge>(_n, edges)
      var now_ord = 0
      var group_num = 0
      var visited: [Int] = []
      let ids = [Int](unsafeUninitializedCapacity: _n) { ids, initializedCount in
        initializedCount = _n
        withUnsafeMutablePointer(to: &now_ord) { now_ord in
          withUnsafeMutablePointer(to: &group_num) { group_num in
            g.start.withUnsafeBufferPointer { start in
              g.elist.withUnsafeBufferPointer { elist in
                withUnsafeTemporaryAllocation(of: Int.self, capacity: _n) { low in
                  withUnsafeTemporaryAllocation(of: Int.self, capacity: _n) { ord in
                    withUnsafeTemporaryAllocation(of: Bool.self, capacity: _n) { stk in

                      let g = (start: start.baseAddress!, elist: elist.baseAddress!)
                      let (low, ord, ids) = (low.baseAddress!, ord.baseAddress!, ids.baseAddress!)
                      low.initialize(repeating: 0, count: _n)
                      ord.initialize(repeating: -1, count: _n)
                      ids.initialize(repeating: 0, count: _n)
                      func dfs(_ v: Int) {
                        low[v] = now_ord.pointee
                        ord[v] = now_ord.pointee
                        now_ord.pointee += 1
                        visited.append(v)
                        for i in g.start[v]..<g.start[v + 1] {
                          let to = g.elist[i].to
                          if ord[to] == -1 {
                            dfs(to)
                            low[v] = min(low[v], low[to])
                          } else {
                            low[v] = min(low[v], ord[to])
                          }
                        }
                        if low[v] == ord[v] {
                          while true {
                            let u = visited.removeLast()
                            ord[u] = _n
                            ids[u] = group_num.pointee
                            if u == v { break }
                          }
                          group_num.pointee += 1
                        }
                      }
                      for i in 0..<_n {
                        if ord[i] == -1 { dfs(i) }
                      }
                      for i in 0..<_n {
                        ids[i] = group_num.pointee - 1 - ids[i]
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
      return (group_num, ids)
    }

    @inlinable @inline(__always)
    public func scc() -> [[Int]] {
      let ids = scc_ids()
      let group_num = ids.number_of_scc
      var groups = [[Int]](repeating: [], count: ids.number_of_scc)
      var counts = [Int](repeating: 0, count: group_num)
      for x in ids.scc { counts[x] += 1 }
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
    @usableFromInline typealias edge = Int
    // @usableFromInline
    // struct edge {
    //   @inlinable @inline(__always) init(_ to: Int) { self.to = to }
    //   @usableFromInline let to: Int
    // }
    @usableFromInline
    var edges: [(Int, edge)] = []
  }
}

extension Int {
  @inlinable @inline(__always) var to: Int { self }
}
