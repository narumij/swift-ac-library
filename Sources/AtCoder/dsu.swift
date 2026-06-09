#if USE_NON_COPYABLE
  /// Implement (union by size) + (path compression)
  /// Reference:
  /// Zvi Galil and Giuseppe F. Italiano,
  /// Data structures and algorithms for disjoint set union problems
  @frozen
  public struct DSU: ~Copyable {

    // CoW廃止でシンプルになった
    // シンプルさで生じた本来の価値を損なわないように配慮する方針

    @usableFromInline let payload: UnsafeMutablePointer<Int>
    @usableFromInline let _n: Int

    @inlinable
    var parent_or_size: UnsafeMutableBufferPointer<Int> {
      .init(start: payload, count: _n)
    }

    deinit {
      payload.deinitialize(count: _n)
      payload.deallocate()
    }
  }

  extension DSU {

    init() {
      self.init(0)
    }

    init(_ n: Int) {
      _n = n
      payload = .allocate(capacity: n)
      payload.initialize(repeating: -1, count: n)
    }
  }

  extension DSU {

    @inlinable
    func merge(_ a: Int, _ b: Int) -> Int {
      assert(0 <= a && a < _n)
      assert(0 <= b && b < _n)
      var (x, y) = (leader(a), leader(b))
      if x == y { return x }
      if -parent_or_size[x] < -parent_or_size[y] { swap(&x, &y) }
      parent_or_size[x] += parent_or_size[y]
      parent_or_size[y] = x
      return x
    }

    @inlinable
    func same(_ a: Int, _ b: Int) -> Bool {
      assert(0 <= a && a < _n)
      assert(0 <= b && b < _n)
      return leader(a) == leader(b)
    }

    @inlinable
    func leader(_ a: Int) -> Int {
      assert(0 <= a && a < _n)
      return _leader(a)
    }

    @inlinable
    func size(_ a: Int) -> Int {
      assert(0 <= a && a < _n)
      return -parent_or_size[leader(a)]
    }

    @inlinable
    func groups() -> [[Int]] {
      var leader_buf = [Int](repeating: -1, count: _n)
      var group_size = [Int](repeating: -1, count: _n)
      for i in 0..<_n {
        leader_buf[i] = leader(i)
        group_size[leader_buf[i]] += 1
      }
      var result: [[Int]] = [[Int]](repeating: [], count: _n)
      for i in 0..<_n {
        result[i].reserveCapacity(group_size[i])
      }
      for i in 0..<_n {
        result[leader_buf[i]].append(i)
      }
      result.removeAll { $0.isEmpty }
      return result
    }

    @inlinable
    func _leader(_ a: Int) -> Int {
      if parent_or_size[a] < 0 { return a }
      parent_or_size[a] = _leader(parent_or_size[a])
      return parent_or_size[a]
    }
  }

  extension DSU {

    @inlinable
    internal init(other: borrowing Self) {
      payload = UnsafeMutablePointer<Int>.allocate(capacity: other._n)
      payload.initialize(from: other.payload, count: other._n)
      _n = other._n
    }
  }

  extension DSU {

    @inlinable
    func clone() -> Self {
      return .init(other: self)
    }
  }

  extension DSU: @unchecked Sendable {}
#endif
