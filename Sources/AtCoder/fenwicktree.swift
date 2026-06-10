#if !COMPATIBLE_ATCODER_2025
  /// Reference: https://en.wikipedia.org/wiki/Fenwick_tree
  @frozen
  public struct FenwickTree<T>: ~Copyable
  where T: AdditiveArithmetic & ToUnsignedType {

    public typealias U = T.Unsigned

    @usableFromInline
    var _n: Int

    @usableFromInline
    var data: UnsafeMutablePointer<U>

    @inlinable
    @inline(__always)
    public init() {
      self.init(0)
    }

    @inlinable
    @inline(__always)
    public init(_ n: Int) {
      precondition(n >= 0)
      _n = n
      data = .allocate(capacity: n)
      data.initialize(repeating: -1, count: n)
    }

    deinit {
      data.deinitialize(count: _n)
      data.deallocate()
    }
  }

  extension FenwickTree {

    @inlinable
    public mutating func add(_ p: Int, _ x: T) {
      precondition(0 <= p && p < _n)
      var p = p + 1
      while p <= _n {
        data[p - 1] &+= x.unsigned
        p += p & -p
      }
    }

    @inlinable
    public func sum(_ l: Int, _ r: Int) -> T {
      precondition(0 <= l && l <= r && r <= _n)
      return T(bitPattern: sum(r) &- sum(l))
    }

    @inlinable
    func sum(_ r: Int) -> U {
      var r = r
      var s: U = 0
      while r > 0 {
        s &+= data[r - 1]
        r -= r & -r
      }
      return s
    }
  }

  extension FenwickTree {

    @inlinable
    internal init(other: borrowing Self) {
      data = UnsafeMutablePointer<U>.allocate(capacity: other._n)
      data.initialize(from: other.data, count: other._n)
      _n = other._n
    }

    @inlinable
    public func clone() -> Self {
      return .init(other: self)
    }
  }
#endif

extension FenwickTree: @unchecked Sendable {}
