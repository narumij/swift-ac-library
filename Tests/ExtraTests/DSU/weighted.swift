// 重み付き
// https://atcoder.jp/contests/abc328/submissions/76866930

@frozen
public struct DSU: ~Copyable {

  @usableFromInline let parent_or_size_payload: UnsafeMutablePointer<Int>
  @usableFromInline let v_payload: UnsafeMutablePointer<Int>
  @usableFromInline let _n: Int

  deinit {
    parent_or_size_payload.deinitialize(count: _n)
    parent_or_size_payload.deallocate()
    v_payload.deinitialize(count: _n)
    v_payload.deallocate()
  }
}

extension DSU {
  
  @inlinable
  var parent_or_size: UnsafeMutableBufferPointer<Int> {
    .init(start: parent_or_size_payload, count: _n)
  }
  
  @inlinable
  var v: UnsafeMutableBufferPointer<Int> {
    .init(start: v_payload, count: _n)
  }
}

extension DSU {

  public init() {
    self.init(0)
  }

  public init(_ n: Int) {
    _n = n
    parent_or_size_payload = .allocate(capacity: n)
    parent_or_size_payload.initialize(repeating: -1, count: n)
    v_payload = .allocate(capacity: n)
    v_payload.initialize(repeating: 0, count: n)
  }
}

extension DSU {

  @inlinable
  mutating func merge(_ a: Int,_ b: Int,_ d: Int) -> Int {
      assert(0 <= a && a < _n)
      assert(0 <= b && b < _n)
      var ((x,da),(y,db)) = (leader(a), leader(b))
      var d = d + (da - db)
      if x == y { return x }
      if -parent_or_size[x] < -parent_or_size[y] { swap(&x, &y); d *= -1 }
      parent_or_size[x] += parent_or_size[y]
      parent_or_size[y] = x
      v[y] = d
      return x
  }
  
  @inlinable
  mutating func same(_ a: Int,_ b: Int) -> (Bool,Int) {
      assert(0 <= a && a < _n)
      assert(0 <= b && b < _n)
      let ((x,da),(y,db)) = (leader(a), leader(b))
      return (x == y, db - da)
  }
  
  @inlinable
  mutating func leader(_ a: Int) -> (Int,Int) {
      assert(0 <= a && a < _n)
    return _leader(a)
  }
  
  @inlinable
  public mutating func size(_ a: Int) -> Int {
    assert(0 <= a && a < _n)
    return -parent_or_size[leader(a).0]
  }
  
  @inlinable
  public mutating func groups() -> [[Int]] {
    var leader_buf = [Int](repeating: -1, count: _n)
    var group_size = [Int](repeating: -1, count: _n)
    for i in 0..<_n {
      leader_buf[i] = leader(i).0
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
  mutating func _leader(_ a: Int) -> (Int,Int) {
      assert(0 <= a && a < _n)
      if parent_or_size[a] < 0 { return (a,0) }
      let (x,d) = leader(parent_or_size[a])
      parent_or_size[a] = x
      v[a] += d
      return (parent_or_size[a], v[a])
  }
}

extension DSU {

  @inlinable
  internal init(other: borrowing Self) {
    parent_or_size_payload = UnsafeMutablePointer<Int>.allocate(capacity: other._n)
    parent_or_size_payload.initialize(from: other.parent_or_size_payload, count: other._n)
    v_payload = UnsafeMutablePointer<Int>.allocate(capacity: other._n)
    v_payload.initialize(from: other.v_payload, count: other._n)
    _n = other._n
  }

  @inlinable
  public func clone() -> Self {
    return .init(other: self)
  }
}

extension DSU: @unchecked Sendable {}
