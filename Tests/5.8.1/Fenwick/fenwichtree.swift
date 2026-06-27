// 解放機構がない実装なため、利用者が解放管理を行う必要がある
@frozen
public struct FenwickTree<T>
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

  /// メモリ解放メソッド
  ///
  /// - Warning: 二回以上呼んではならない
  func dispose() {
    data.deinitialize(count: _n)
    data.deallocate()
  }
}
extension FenwickTree: @unchecked Sendable {}
