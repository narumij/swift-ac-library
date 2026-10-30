// 差し替え検討バージョン
// modint対応をどうするかが課題

/// Reference: https://en.wikipedia.org/wiki/Fenwick_tree
@frozen
public struct FenwickTree<T>: ~Copyable
where T: FixedWidthInteger {

  @usableFromInline
  var _n: Int

  @usableFromInline
  var data: UnsafeMutablePointer<T>

  @inlinable
  @inline(__always)
  public init() {
    self.init(0)
  }

  @inlinable
  @inline(__always)
  public init(_ n: Int) {
    assert(n >= 0)

    _n = n

    data = .allocate(capacity: n)
    data.initialize(repeating: .zero, count: n)
  }

  deinit {
    data.deinitialize(count: _n)
    data.deallocate()
  }
}

extension FenwickTree {

  @inlinable
  public mutating func add(_ p: Int, _ x: T) {
    assert(0 <= p && p < _n)

    var p = p &+ 1

    while p <= _n {
      data[p &- 1] &+= x
      p &+= p & -p
    }
  }

  @inlinable
  public func sum(_ l: Int, _ r: Int) -> T {
    assert(0 <= l && l <= r && r <= _n)

    return sum(r) &- sum(l)
  }

  @inlinable
  internal func sum(_ r: Int) -> T {
    var r = r
    var s: T = .zero

    while r > 0 {
      s &+= data[r &- 1]
      r &-= r & -r
    }

    return s
  }
}

extension FenwickTree {

  @inlinable
  internal init(other: borrowing Self) {
    data = .allocate(capacity: other._n)
    data.initialize(from: other.data, count: other._n)
    _n = other._n
  }

  @inlinable
  public func clone() -> Self {
    .init(other: self)
  }
}

extension FenwickTree: @unchecked Sendable {}
