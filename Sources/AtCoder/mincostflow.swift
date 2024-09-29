import Collections
import Foundation

public struct MCFGraph<Value: FixedWidthInteger & SignedInteger> {
  @usableFromInline
  var _n: Int
  @usableFromInline
  var _edges: [Edge] = []
}

extension MCFGraph {

  public typealias Cap = Value
  public typealias Cost = Value

  @inlinable
  public init() { _n = 0 }
  @inlinable
  public init(count n: Int) { _n = n }
}

extension MCFGraph {

  @inlinable
  @discardableResult
  public mutating func add_edge(_ from: Int, _ to: Int, _ cap: Cap, _ cost: Cost) -> Int {
    assert(0 <= from && from < _n)
    assert(0 <= to && to < _n)
    assert(0 <= cap)
    assert(0 <= cost)
    let m = _edges.count
    _edges.append(Edge(from: from, to: to, cap: cap, flow: 0, cost: cost))
    return m
  }

  public struct Edge {
    public init(
      from: Int, to: Int, cap: MCFGraph<Value>.Cap, flow: MCFGraph<Value>.Cap,
      cost: MCFGraph<Value>.Cost
    ) {
      self.from = from
      self.to = to
      self.cap = cap
      self.flow = flow
      self.cost = cost
    }
    public let from, to: Int
    public let cap: Cap
    public var flow: Cap
    public let cost: Cost
  }

  @inlinable
  public func get_edge(_ i: Int) -> Edge {
    let m = _edges.count
    assert(0 <= i && i < m)
    return _edges[i]
  }

  @inlinable
  public func edges() -> [Edge] { return _edges }

  @inlinable
  public mutating func flow(_ s: Int, _ t: Int) -> (Cap, Cost) {
    return flow(s, t, Cap.max)
  }
  @inlinable
  public mutating func flow(_ s: Int, _ t: Int, _ flow_limit: Cap) -> (Cap, Cost) {
    return slope(s, t, flow_limit).last!
  }
  @inlinable
  public mutating func slope(_ s: Int, _ t: Int) -> [(Cap, Cost)] {
    return slope(s, t, Cap.max)
  }
  @inlinable
  public mutating func slope(_ s: Int, _ t: Int, _ flow_limit: Cap) -> [(Cap, Cost)] {
    assert(0 <= s && s < _n)
    assert(0 <= t && t < _n)
    assert(s != t)

    let m = _edges.count
    var edge_idx = [Int](repeating: 0, count: m)

    var g = {
      var degree = [Int](repeating: 0, count: _n)
      var redge_idx = [Int](repeating: 0, count: m)
      var elist: [(Int, _Edge)] = []
      elist.reserveCapacity(2 * m)
      for i in 0..<m {
        let e = _edges[i]
        edge_idx[i] = degree[e.from]
        degree[e.from] += 1
        redge_idx[i] = degree[e.to]
        degree[e.to] += 1
        elist.append((e.from, .init(to: e.to, rev: -1, cap: e.cap - e.flow, cost: e.cost)))
        elist.append((e.to, .init(to: e.from, rev: -1, cap: e.flow, cost: -e.cost)))
      }
      var _g = _Internal.csr<_Edge>(_n, elist)
      for i in 0..<m {
        let e = _edges[i]
        edge_idx[i] += _g.start[e.from]
        redge_idx[i] += _g.start[e.to]
        _g.elist[edge_idx[i]]!.rev = redge_idx[i]
        _g.elist[redge_idx[i]]!.rev = edge_idx[i]
      }
      return _g
    }()

    let result = slope(&g, s, t, flow_limit)

    for i in 0..<m {
      let e = g.elist[edge_idx[i]]!
      _edges[i].flow = _edges[i].cap - e.cap
    }

    return result
  }
}

extension MCFGraph {

  /// inside edge
  @usableFromInline
  struct _Edge {
    @inlinable
    init(to: Int, rev: Int, cap: MCFGraph<Value>.Cap, cost: MCFGraph<Value>.Cost) {
      self.to = to
      self.rev = rev
      self.cap = cap
      self.cost = cost
    }
    @usableFromInline let to: Int
    @usableFromInline var rev: Int
    @usableFromInline var cap: Cap
    @usableFromInline let cost: Cost
  }

  @usableFromInline
  struct Q: Comparable {
    @inlinable
    init(key: MCFGraph<Value>.Cost, to: Int) {
      self.key = key
      self.to = to
    }
    @usableFromInline let key: Cost
    @usableFromInline let to: Int
    @inlinable
    static func < (lhs: Q, rhs: Q) -> Bool {
        lhs.key < rhs.key
    }
  }

  @inlinable
  func slope(
    _ g: inout _Internal.csr<_Edge>,
    _ s: Int,
    _ t: Int,
    _ flow_limit: Cap
  ) -> [(Cap, Cost)] {
    // variants (C = maxcost):
    // -(n-1)C <= dual[s] <= dual[i] <= dual[t] = 0
    // reduced cost (= e.cost + dual[e.from] - dual[e.to]) >= 0 for all edge

    // dual_dist[i] = (dual[i], dist[i])
    var dual_dist = [(first: Cost, second: Cost)](repeating: (0, 0), count: _n)
    var prev_e = [Int](repeating: 0, count: _n)
    var vis = [Bool](repeating: false, count: _n)
    var que_min = [Int]()
    var que = Queue()
    func dual_ref() -> Bool {
      // for (int i = 0; i < _n; i++) {
      for i in 0..<_n {
        dual_dist[i].second = Cost.max
      }
      // std::fill(vis.begin(), vis.end(), false);
      vis.withUnsafeMutableBufferPointer { $0.update(repeating: false) }
      que_min.removeAll()
      que = []

      // que[0..heap_r) was heapified
      var heap_r = 0

      dual_dist[s].second = 0
      que_min.append(s)
      while !que_min.isEmpty || !que.isEmpty {
        var v: Int
        if !que_min.isEmpty {
          v = que_min.popLast()!
        } else {
          while heap_r < que.count {
            heap_r += 1
            que.push_heap(que.startIndex, que.startIndex + heap_r)
          }
          v = que.popMin()!.to
          heap_r -= 1
        }
        if vis[v] { continue }
        vis[v] = true
        if v == t { break }
        // dist[v] = shortest(s, v) + dual[s] - dual[v]
        // dist[v] >= 0 (all reduced cost are positive)
        // dist[v] <= (n-1)C
        let dual_v = dual_dist[v].first
        let dist_v = dual_dist[v].second
        // for (int i = g.start[v]; i < g.start[v + 1]; i++) {
        do {
          var i = g.start[v]
          while i < g.start[v + 1] {
            defer { i += 1 }
            let e = g.elist[i]!
            if e.cap == 0 { continue }
            // |-dual[e.to] + dual[v]| <= (n-1)C
            // cost <= C - -(n-1)C + 0 = nC
            let cost = e.cost - dual_dist[e.to].first + dual_v
            if dual_dist[e.to].second - dist_v > cost {
              let dist_to = dist_v + cost
              dual_dist[e.to].second = dist_to
              prev_e[e.to] = e.rev
              if dist_to == dist_v {
                que_min.append(e.to)
              } else {
                que.insert(Q(key: dist_to, to: e.to))
              }
            }
          }
        }
      }
      if !vis[t] {
        return false
      }

      // for (int v = 0; v < _n; v++) {
      for v in 0..<_n {
        if !vis[v] { continue }
        // dual[v] = dual[v] - dist[t] + dist[v]
        //         = dual[v] - (shortest(s, t) + dual[s] - dual[t]) +
        //         (shortest(s, v) + dual[s] - dual[v]) = - shortest(s,
        //         t) + dual[t] + shortest(s, v) = shortest(s, v) -
        //         shortest(s, t) >= 0 - (n-1)C
        dual_dist[v].first -= dual_dist[t].second - dual_dist[v].second
      }
      return true
    }

    var flow: Cap = 0
    var cost: Cost = 0
    var prev_cost_per_flow: Cost = -1
    var result: [(Cap, Cost)] = [(0, 0)]
    while flow < flow_limit {
      if !dual_ref() { break }
      var c = flow_limit - flow
      // for (int v = t; v != s; v = g.elist[prev_e[v]].to) {
      do {
        var v = t
        while v != s {
          defer { v = g.elist[prev_e[v]]!.to }
          c = min(c, g.elist[g.elist[prev_e[v]]!.rev]!.cap)
        }
      }
      // for (int v = t; v != s; v = g.elist[prev_e[v]].to) {
      do {
        var v = t
        while v != s {
          defer { v = g.elist[prev_e[v]]!.to }
          // auto& e = g.elist[prev_e[v]];
          var e = g.elist[prev_e[v]]!
          defer { g.elist[prev_e[v]] = e }
          e.cap += c
          g.elist[e.rev]!.cap -= c
        }
      }
      let d = -dual_dist[s].first
      flow += c
      cost += c * d
      if prev_cost_per_flow == d {
        result.removeLast()
      }
      result.append((flow, cost))
      prev_cost_per_flow = d
    }
    return result
  }

  #if false
    // swift-collections 1.1.0以降はこちら。
    @usableFromInline
    typealias Queue = Heap<Q>
  #else
    @usableFromInline
    typealias Queue = [Q]
  #endif
}

#if false
  // swift-collections 1.1.0以降はこちら。
  extension Heap {
    @inlinable
    var startIndex: Int { 0 }
    @inlinable
    mutating func push_heap(_ start: Int, _ end: Int) { /* NOP */  }
  }
#else
  extension Array where Element: Comparable {

    @inlinable
    mutating func push_heap(_ start: Int, _ end: Int) {
      push_heap(end, <)
    }

    @inlinable
    @discardableResult
    mutating func popMin() -> Element? {
      pop_heap(<)
      return removeLast()
    }

    @inlinable
    mutating public func insert(_ newElement: Element) {
      append(newElement)
    }
  }
#endif
