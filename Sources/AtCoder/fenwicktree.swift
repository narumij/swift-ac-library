#if USE_NON_COPYABLE
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
    func add(_ p: Int, _ x: T) {
      assert(0 <= p && p < _n)
      var p = p + 1
      while p <= _n {
        data[p - 1] &+= x.unsigned
        p += p & -p
      }
    }

    @inlinable
    func sum(_ l: Int, _ r: Int) -> T {
      assert(0 <= l && l <= r && r <= _n)
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
#endif

extension FenwickTree: @unchecked Sendable {}
