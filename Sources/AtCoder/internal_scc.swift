import Collections

extension _Internal {

  @usableFromInline
  struct scc_graph: ~Copyable {

    @inlinable
    public init(_ n: Int) {
      _n = n
      edges.reserveCapacity(_n)
    }

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
      var visited: [Int] = []
      let ids = [Int](unsafeUninitializedCapacity: _n) { ids, initializedCount in
        initializedCount = _n
        withUnsafeMutablePointer(to: &now_ord) { now_ord in
          withUnsafeMutablePointer(to: &group_num) { group_num in
            withUnsafeTemporaryAllocation(of: Int.self, capacity: _n * 2) { buffer in

              let low = buffer.baseAddress!
              let ord = buffer.baseAddress! + _n
              let ids = ids.baseAddress!

              low.initialize(repeating: 0, count: _n)
              ord.initialize(repeating: -1, count: _n)
              ids.initialize(repeating: 0, count: _n)

              #if false
              // 比較・再検討用の元の再帰実装。長い鎖ではスタックが溢れる。
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
              #else
              // DFSの復帰位置をヒープ上に保持する。長い鎖でも呼出しスタックを消費しない。
              // visitedはSCC未確定の頂点、framesは探索中の呼出しに相当する別のスタック。
              var frames: [(vertex: Int, nextEdge: Int)] = []
              for root in 0..<_n {
                if ord[root] != -1 { continue }
                low[root] = now_ord.pointee
                ord[root] = now_ord.pointee
                now_ord.pointee += 1
                visited.append(root)
                frames.append((root, g.start[root]))

                while let frame = frames.last {
                  let v = frame.vertex
                  if frame.nextEdge < g.start[v + 1] {
                    let to = g.elist[frame.nextEdge].to
                    frames[frames.count - 1].nextEdge += 1
                    if ord[to] == -1 {
                      low[to] = now_ord.pointee
                      ord[to] = now_ord.pointee
                      now_ord.pointee += 1
                      visited.append(to)
                      frames.append((to, g.start[to]))
                    } else {
                      low[v] = min(low[v], ord[to])
                    }
                    continue
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
                  frames.removeLast()
                  // 再帰版と同じく、子の探索を終えてから親のlowを更新する。
                  if let parent = frames.last {
                    low[parent.vertex] = min(low[parent.vertex], low[v])
                  }
                }
              }
              #endif
              for i in 0..<_n {
                ids[i] = group_num.pointee - 1 - ids[i]
              }
              
              buffer.baseAddress!.deinitialize(count: _n * 2)
            }
          }
        }
      }
      return (group_num, ids)
    }

    @inlinable
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

extension _Internal.scc_graph {
  
  @inlinable
  internal init(other: borrowing Self) {
    self._n = other._n
    self.edges = other.edges
  }

  @inlinable
  func clone() -> Self {
    return .init(other: self)
  }
}

extension Int {
  @inlinable @inline(__always) var to: Int { self }
}
