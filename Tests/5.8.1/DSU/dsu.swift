// 解放機構がない実装なため、利用者が解放管理を行う必要がある
@frozen
public struct DSU {

  @usableFromInline let payload: UnsafeMutablePointer<Int>
  @usableFromInline let _n: Int
}

extension DSU {

  @inlinable
  var parent_or_size: UnsafeMutableBufferPointer<Int> {
    .init(start: payload, count: _n)
  }
}

extension DSU {

  public init() {
    self.init(0)
  }

  public init(_ n: Int) {
    _n = n
    payload = .allocate(capacity: n)
    payload.initialize(repeating: -1, count: n)
  }
}

extension DSU {

  @inlinable
  public mutating func merge(_ a: Int, _ b: Int) -> Int {
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
  public mutating func same(_ a: Int, _ b: Int) -> Bool {
    assert(0 <= a && a < _n)
    assert(0 <= b && b < _n)
    return leader(a) == leader(b)
  }

  @inlinable
  public mutating func leader(_ a: Int) -> Int {
    assert(0 <= a && a < _n)
    return _leader(a)
  }

  @inlinable
  public mutating func size(_ a: Int) -> Int {
    assert(0 <= a && a < _n)
    return -parent_or_size[leader(a)]
  }

  @inlinable
  public mutating func groups() -> [[Int]] {
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
}

extension DSU {

  @inlinable
  mutating func _leader(_ a: Int) -> Int {
    if parent_or_size[a] < 0 { return a }
    parent_or_size[a] = _leader(parent_or_size[a])
    return parent_or_size[a]
  }
}

extension DSU {

  /// メモリ解放メソッド
  ///
  /// - Warning: 二回以上呼んではならない
  func dispose() {
    payload.deinitialize(count: _n)
    payload.deallocate()
  }
}

extension DSU: @unchecked Sendable {}
