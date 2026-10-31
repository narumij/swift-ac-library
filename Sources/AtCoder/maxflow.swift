import DequeModule

@frozen
public struct MFGraph<Cap>: ~Copyable
where Cap: ___numeric_limit & Comparable {
  @usableFromInline
  let _n: Int
  @usableFromInline
  var pos: [(first: Int, second: Int)] = []
  @usableFromInline
  var g: [[_edge]]
}

extension MFGraph {

  @inlinable
  public init() {
    _n = 0
    g = []
  }
  @inlinable
  public init(count n: Int) {
    _n = n
    g = [[_edge]].init(repeating: [], count: n)
  }
  /// Reserves storage for the expected adjacency entries at each vertex.
  /// Count both endpoints of every directed edge: `from` stores the forward edge,
  /// and `to` stores its residual reverse edge. A self-loop contributes two entries
  /// to the same vertex. Counts describe total desired capacity, not extra capacity.
  /// This only reserves storage; edge indices, capacities, and flows are unchanged.
  @inlinable
  public mutating func reserveCapacity(edgeCounts: [Int]) {
    precondition(edgeCounts.count == _n, "Expected one edge count per vertex")
    var total = 0
    g.withUnsafeMutableBufferPointer { adjacency in
      for v in 0..<_n {
        precondition(edgeCounts[v] >= 0, "Negative edge count")
        total += edgeCounts[v]
        adjacency[v].reserveCapacity(edgeCounts[v])
      }
    }
    pos.reserveCapacity(total / 2)
  }

  @inlinable
  @discardableResult
  public mutating func add_edge(_ from: Int, _ to: Int, _ cap: Cap) -> Int {
    assert(0 <= from && from < _n)
    assert(0 <= to && to < _n)
    assert(0 <= cap)
    let m = pos.count
    // 外側の隣接配列を一度だけ借用して、順方向・逆方向の辺を追加する。
    g.withUnsafeMutableBufferPointer { g in
      let from_id = g[from].count
      var to_id = g[to].count
      if from == to { to_id &+= 1 }
      pos.append((from, from_id))
      g[from].append(_edge(to: to, rev: to_id, cap: cap))
      g[to].append(_edge(to: from, rev: from_id, cap: 0))
    }
    return m
  }

  @frozen
  public struct Edge {
    @inlinable
    public init(from: Int, to: Int, cap: Cap, flow: Cap) {
      self.from = from
      self.to = to
      self.cap = cap
      self.flow = flow
    }
    public let from, to: Int
    public let cap, flow: Cap
  }

  @inlinable
  public func get_edge(_ i: Int) -> Edge {
    let m = pos.count
    assert(0 <= i && i < m)
    let _e = g[pos[i].first][pos[i].second]
    let _re = g[_e.to][_e.rev]
    return Edge(
      from: pos[i].first, to: _e.to, cap: Cap.__uncheckedAdd(_e.cap, _re.cap), flow: _re.cap)
  }

  @inlinable
  public func edges() -> [Edge] {
    let m = pos.count
    var result: [Edge] = []
    for i in 0..<m {
      result.append(get_edge(i))
    }
    return result
  }

  @inlinable
  public mutating func change_edge(_ i: Int, _ new_cap: Cap, _ new_flow: Cap) {
    let m = pos.count
    assert(0 <= i && i < m)
    assert(0 <= new_flow && new_flow <= new_cap)
    var _e = g[pos[i].first][pos[i].second]
    defer { g[pos[i].first][pos[i].second] = _e }
    var _re = g[_e.to][_e.rev]
    defer { g[_e.to][_e.rev] = _re }
    _e.cap = Cap.__uncheckedSubtract(new_cap, new_flow)
    _re.cap = new_flow
  }

  @inlinable
  public mutating func flow(_ s: Int, _ t: Int) -> Cap {
    return flow(s, t, numeric_limit<Cap>.max)
  }

  @inlinable
  public mutating func flow(_ s: Int, _ t: Int, _ flow_limit: Cap) -> Cap {
    assert(0 <= s && s < _n)
    assert(0 <= t && t < _n)
    assert(s != t)

    var level = [Int](repeating: 0, count: _n)
    var iter = [Int](repeating: 0, count: _n)
    // 各頂点はBFSごとに一度だけ入るため、頂点数分の領域を繰り返し使える。
    var queue = [Int](repeating: 0, count: _n)
    // DFSはlevelが真に減る方向へだけ進むため、同時に積まれるフレームは頂点数以下。
    var frame = [(v: Int, up: Cap, res: Cap)](repeating: (0, 0, 0), count: _n)

    func bfs() {
      g.withUnsafeMutableBufferPointer { g in
        level.withUnsafeMutableBufferPointer { level in
          queue.withUnsafeMutableBufferPointer { queue in
            level.update(repeating: -1)
            level[s] = 0
            var head = 0
            var tail = 1
            queue[0] = s
            while head < tail {
              let v = queue[head]
              head &+= 1
              let next_level = level[v] &+ 1
              // 辺ごとに外側配列から内側配列を読み直さないよう、頂点ごとに一度借用する。
              let reached = g[v].withUnsafeBufferPointer { adj in
                for e in adj {
                  if e.cap == 0 || level[e.to] >= 0 { continue }
                  level[e.to] = next_level
                  if e.to == t { return true }
                  queue[tail] = e.to
                  tail &+= 1
                }
                return false
              }
              if reached { return }
            }
          }
        }
      }
    }

    #if false
      // https://judge.yosupo.jp/problem/bipartitematching
      // が再帰の上限でクラッシュする
      func dfs(_ v: Int, _ up: Cap) -> Cap {
        if v == s { return up }
        var res: Cap = 0
        let level_v = level[v]

        var i: Int?
        func next() -> Int? {
          i = i.map { $0 &+ 1 } ?? iter[v]
          iter[v] = i!
          return i! < g[v].count ? i : nil
        }

        while let i = next() {
          let to = g[v][i].to
          let rev = g[v][i].rev
          if level_v <= level[to] || g[to][rev].cap == 0 { continue }
          let d = dfs(to, min(Cap.__uncheckedSubtract(up, res), g[to][rev].cap))
          if d <= 0 { continue }
          g[v][i].cap = Cap.__uncheckedAdd(g[v][i].cap, d)
          g[to][rev].cap = Cap.__uncheckedSubtract(g[to][rev].cap, d)
          res = Cap.__uncheckedAdd(res, d)
          if res == up { return res }
        }

        level[v] = _n
        return res
      }
    #else
      // https://judge.yosupo.jp/problem/bipartitematching
      // が再帰の上限でクラッシュするので、
      // https://github.com/kzrnm/ac-library-csharp/blob/main/Source/ac-library-csharp/Graph/MaxFlow.cs
      // を参考にstackによるDFSに変更
      func dfs(_ v: Int, _ up: Cap) -> Cap {
        g.withUnsafeMutableBufferPointer { g in
          level.withUnsafeMutableBufferPointer { level in
            iter.withUnsafeMutableBufferPointer { iter in
              frame.withUnsafeMutableBufferPointer { frame in

                frame[0] = (v, up, 0)
                var sp = 1
                var returnValue: Cap?

                DFS: while sp > 0 {
                  sp &-= 1
                  var (v, up, res) = frame[sp]

                  if returnValue == nil, v == s {
                    // return up
                    returnValue = up
                    continue DFS
                  }

                  var i: Int?
                  func next() -> Int? {
                    i = i.map { $0 &+ 1 } ?? iter[v]
                    iter[v] = i!
                    return i! < g[v].count ? i : nil
                  }

                  while let i = next() {
                    let to = g[v][i].to
                    let rev = g[v][i].rev

                    if returnValue == nil {
                      if level[v] <= level[to] || g[to][rev].cap == 0 { continue }

                      // let d = dfs(to, min(up - res, g[to][rev].cap))
                      frame[sp] = (v, up, res)
                      frame[sp &+ 1] = (to, min(Cap.__uncheckedSubtract(up, res), g[to][rev].cap), 0)
                      sp &+= 2
                      continue DFS
                    }

                    // let d = dfs(to, min(up - res, g[to][rev].cap))
                    let d = returnValue!
                    returnValue = nil

                    if d <= 0 { continue }

                    g[v][i].cap = Cap.__uncheckedAdd(g[v][i].cap, d)
                    g[to][rev].cap = Cap.__uncheckedSubtract(g[to][rev].cap, d)
                    res = Cap.__uncheckedAdd(res, d)

                    if res == up {
                      // return res
                      returnValue = res
                      continue DFS
                    }
                  }

                  // 再帰版と同様、探索し尽くした各フレームの頂点を枝刈りする。
                  level[v] = _n
                  // return res
                  returnValue = res
                  continue DFS
                }

                // return res
                return returnValue!
              }
            }
          }
        }
      }
    #endif

    var flow: Cap = 0
    while flow < flow_limit {
      bfs()
      if level[t] == -1 { break }
      iter.withUnsafeMutableBufferPointer { $0.update(repeating: 0) }
      let f = dfs(t, Cap.__uncheckedSubtract(flow_limit, flow))
      if f == 0 { break }
      flow = Cap.__uncheckedAdd(flow, f)
    }
    return flow
  }

  @inlinable
  public func min_cut(_ s: Int) -> [Bool] {
    var visited = [Bool](repeating: false, count: _n)
    visited.withUnsafeMutableBufferPointer { visited in
      var que = Deque<Int>()
      que.append(s)
      while let p = que.popFirst() {
        visited[p] = true
        for e in g[p] {
          if e.cap != 0, !visited[e.to] {
            visited[e.to] = true
            que.append(e.to)
          }
        }
      }
    }
    return visited
  }
}

extension MFGraph {
  @frozen
  @usableFromInline
  struct _edge {
    @inlinable
    init(to: Int, rev: Int, cap: Cap) {
      self.to = to
      self.rev = rev
      self.cap = cap
    }
    @usableFromInline
    let to, rev: Int
    @usableFromInline
    var cap: Cap
  }
}

extension MFGraph {

  @inlinable
  internal init(other: borrowing Self) {
    self._n = other._n
    self.pos = other.pos
    self.g = other.g
  }

  @inlinable
  func clone() -> Self {
    return .init(other: self)
  }
}

extension MFGraph.Edge: Sendable where Cap: Sendable {}

extension MFGraph: @unchecked Sendable where Edge: Sendable {}
