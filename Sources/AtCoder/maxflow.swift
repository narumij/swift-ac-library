import Collections
import Foundation

@frozen
public struct MFGraph<Cap>
where Cap: ___numeric_limit & Comparable {
  @usableFromInline
  let _n: Int
  @usableFromInline
  var pos: [(first: Int, second: Int)] = []
  @usableFromInline
  var g: [[_Edge]]
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
    g = [[_Edge]].init(repeating: [], count: n)
  }
  @inlinable
  @discardableResult
  public mutating func add_edge(_ from: Int, _ to: Int, _ cap: Cap) -> Int {
    assert(0 <= from && from < _n)
    assert(0 <= to && to < _n)
    assert(0 <= cap)
    let m = pos.count
    pos.append((from, g[from].count))
    let from_id = g[from].count
    var to_id = g[to].count
    if from == to { to_id += 1 }
    g[from].append(_Edge(to: to, rev: to_id, cap: cap))
    g[to].append(_Edge(to: from, rev: from_id, cap: 0))
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
    return Edge(from: pos[i].first, to: _e.to, cap: _e.cap + _re.cap, flow: _re.cap)
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
    _e.cap = new_cap - new_flow
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
    var que = Deque<Int>()

    func bfs() {
      level.withUnsafeMutableBufferPointer { $0.update(repeating: -1) }
      level[s] = 0
      que.removeAll()
      que.append(s)
      while let v = que.popFirst() {
        for e in g[v] {
          if e.cap == 0 || level[e.to] >= 0 { continue }
          level[e.to] = level[v] + 1
          if e.to == t { return }
          que.append(e.to)
        }
      }
    }

#if false
    func dfs(_ v: Int, _ up: Cap) -> Cap {
      if v == s { return up }
      var res: Cap = 0
      let level_v = level[v]

      var i: Int?
      func next() -> Int? {
        i = i.map { $0 + 1 } ?? iter[v]
        iter[v] = i!
        return i! < g[v].count ? i : nil
      }

      while let i = next() {
        let to = g[v][i].to
        let rev = g[v][i].rev
        if level_v <= level[to] || g[to][rev].cap == 0 { continue }
        let d = dfs(to, min(up - res, g[to][rev].cap))
        if d <= 0 { continue }
        g[v][i].cap += d
        g[to][rev].cap -= d
        res += d
        if res == up { return res }
      }
      
      level[v] = _n
      return res
    }
#else
    // https://judge.yosupo.jp/problem/bipartitematching
    // が通らないので、
    // https://github.com/kzrnm/ac-library-csharp/blob/main/Source/ac-library-csharp/Graph/MaxFlow.cs
    // からの部分移植に変更
    func dfs(_ v: Int, _ up: Cap) -> Cap {
      var lastRes: Cap = .zero
      var stack: [(v: Int, up: Cap, res: Cap, childOk: Bool)] = []
      stack.append((v, up, .zero, true))
      DFS: while var (v, up, res, childOk) = stack.popLast() {
        if (v == s)
        {
          lastRes = up
          continue
        }
        var itrv: Int?
        func next() -> Int? {
          itrv = itrv.map { $0 + 1 } ?? iter[v]
          iter[v] = itrv!
          return itrv! < g[v].count ? itrv : nil
        }
        while let itrv = next() {
          var (to,rev,cap) = g[v][itrv].properties
          if childOk {
            if level[v] <= level[to] || g[to][rev].cap == .zero { continue }
            let up1 = up - res
            let up2 = g[to][rev].cap
            stack.append((v, up, res, false))
            stack.append((to, up1 < up2 ? up1 : up2, .zero, true))
            continue DFS
          }
          else {
            var d = lastRes
            if d > .zero {
                g[v][itrv].cap = cap + d
                g[to][rev].cap = g[to][rev].cap - d
                res = res + d
                if res == up {
                    lastRes = res;
                    continue DFS
                }
            }
            childOk = true;
          }
        }
        level[v] = _n
        lastRes = res
      }
      return lastRes
    }
#endif

    var flow: Cap = 0
    while flow < flow_limit {
      bfs()
      if level[t] == -1 { break }
      iter.withUnsafeMutableBufferPointer { $0.update(repeating: 0) }
      let f = dfs(t, flow_limit - flow)
      if f == 0 { break }
      flow += f
    }
    return flow
  }

  @inlinable
  public func min_cut(_ s: Int) -> [Bool] {
    var visited = [Bool](repeating: false, count: _n)
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
    return visited
  }
}

extension MFGraph {
  @frozen
  @usableFromInline
  struct _Edge {
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
    @usableFromInline
    var properties: (to: Int,rev: Int, cap: Cap) {
      (to, rev, cap)
    }
  }
}
