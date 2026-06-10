// MARK: - Segment Tree

#if !COMPATIBLE_ATCODER_2025
  public protocol SegTreeOperator {
    associatedtype S
    static func op(_ x: S, _ y: S) -> S
    static var e: S { get }
  }

  public protocol SegTreeOperation: SegTreeOperator {
    associatedtype S
    associatedtype Op where Op == @Sendable (S, S) -> S
    static var op: Op { get }
    static var e: S { get }
  }

  extension SegTreeOperation {
    @inlinable @inline(__always)
    public static func op(_ x: S, _ y: S) -> S { (self.op as (S, S) -> S)(x, y) }
  }

  // MARK: -

  @frozen
  public struct SegTree<_S_op_e_>: ~Copyable
  where _S_op_e_: SegTreeOperator {

    public typealias O = _S_op_e_
    public typealias S = O.S

    @usableFromInline let _d_payload: UnsafeMutablePointer<S>
    @usableFromInline var capacity: Int
    @usableFromInline var _n, size, log: Int

    @inlinable
    var d: UnsafeMutableBufferPointer<S> {
      .init(start: _d_payload, count: capacity)
    }

    deinit {
      _d_payload.deinitialize(count: capacity)
      _d_payload.deallocate()
    }
  }

  extension SegTree {

    @inlinable @inline(__always)
    func op(_ l: S, _ r: S) -> S { O.op(l, r) }

    @inlinable @inline(__always)
    func e() -> S { O.e }
  }

  extension SegTree {

    @inlinable
    public init() {
      self.init(0)
    }

    @inlinable
    public init(_ n: Int) {
      self.init(_count: n)
      initialize()
    }

    @inlinable
    public init(_ v: [S]) {
      self.init(_count: v.count)
      initialize(v)
    }
    
    @inlinable
    public init<C>(_ v: C) where C: Collection, C.Element == S {
      self.init(_count: v.count)
      initialize(v)
    }

    @inlinable
    public init<R>(_ range: __owned R)
    where R: RangeExpression, R: Collection, R.Element == S, S: Comparable {
      precondition(range is Range<S> || range is ClosedRange<S>)
      self.init(_count: range.count)
      initialize(range)
    }
  }

  extension SegTree {

    @inlinable
    public mutating func set(_ p: Int, _ x: S) {
      var p = p
      assert(0 <= p && p < _n)
      p += size
      d[p] = x
      // for (int i = 1; i <= log; i++) update(p >> i);
      for i in stride(from: 1, through: log, by: 1) { update(p >> i) }
    }

    @inlinable
    public func get(_ p: Int) -> S {
      assert(0 <= p && p < _n)
      return d[p + size]
    }

    @inlinable
    public func prod(_ l: Int, _ r: Int) -> S {
      var l = l
      var r = r
      assert(0 <= l && l <= r && r <= _n)
      var sml: S = e()
      var smr: S = e()
      l += size
      r += size

      while l < r {
        if l & 1 != 0 {
          sml = op(sml, d[l])
          l += 1
        }
        if r & 1 != 0 {
          r -= 1
          smr = op(d[r], smr)
        }
        l >>= 1
        r >>= 1
      }

      return op(sml, smr)
    }

    @inlinable
    public func all_prod() -> S { return d[1] }

    @inlinable
    public func max_right(_ l: Int, _ f: (S) -> Bool) -> Int {
      var l = l
      assert(0 <= l && l <= _n)
      assert(f(e()))
      if l == _n { return _n }
      l += size
      var sm: S = e()
      repeat {
        while l & 1 == 0 { l >>= 1 }
        if !f(op(sm, d[l])) {
          while l < size {
            l = l << 1
            if f(op(sm, d[l])) {
              sm = op(sm, d[l])
              l += 1
            }
          }
          return l - size
        }
        sm = op(sm, d[l])
        l += 1
      } while l & -l != l
      return _n
    }

    @inlinable
    public func min_left(_ r: Int, _ f: (S) -> Bool) -> Int {
      var r = r
      assert(0 <= r && r <= _n)
      assert(f(e()))
      if r == 0 { return 0 }
      r += size
      var sm: S = e()
      repeat {
        r -= 1
        while r > 1, r & 1 != 0 { r >>= 1 }
        if !f(op(d[r], sm)) {
          while r < size {
            r = r << 1 + 1
            if f(op(d[r], sm)) {
              sm = op(d[r], sm)
              r -= 1
            }
          }
          return r + 1 - size
        }
        sm = op(d[r], sm)
      } while r & -r != r
      return 0
    }

    @inlinable
    mutating func update(_ k: Int) {
      d[k] = op(d[k << 1], d[k << 1 + 1])
    }
  }

  // MARK: -

  extension SegTree {

    @inlinable
    mutating func initialize() {
      let d = _d_payload
      d.initialize(repeating: O.e, count: size)
      (d + size).initialize(repeating: O.e, count: _n)
      (d + size + _n).initialize(repeating: O.e, count: size - _n)
      for i in stride(from: size - 1, through: 1, by: -1) {
        update(i)
      }
    }
  }

  extension SegTree {

    @inlinable
    mutating func initialize<C>(_ v: C) where C: Collection, C.Element == S {
      let d = _d_payload
      d.initialize(repeating: O.e, count: size)
      for (offset, i) in v.indices.enumerated() {
        (d + size + offset).initialize(to: v[i])
      }
      (d + size + _n).initialize(repeating: O.e, count: size - _n)
      for i in stride(from: size - 1, through: 1, by: -1) {
        update(i)
      }
    }
  }

  extension SegTree {

    @inlinable
    mutating func initialize(_ v: [S]) {
      let d = _d_payload
      v.withUnsafeBufferPointer { v in
        d.initialize(repeating: O.e, count: size)
        (d + size).initialize(from: v.baseAddress!, count: _n)
        (d + size + _n).initialize(repeating: O.e, count: size - _n)
      }
      for i in stride(from: size - 1, through: 1, by: -1) {
        update(i)
      }
    }
  }

  extension SegTree {

    @inlinable
    internal init(_count count: Int) {
      _n = count
      size = _Internal.bit_ceil(_n)
      log = size.trailingZeroBitCount
      capacity = 2 * size
      _d_payload = .allocate(capacity: capacity)
    }
  }

  extension SegTree {

    @inlinable
    internal init(other: borrowing Self) {
      _d_payload = UnsafeMutablePointer<S>.allocate(capacity: other.capacity)
      _d_payload.initialize(from: other._d_payload, count: other.capacity)
      capacity = other.capacity
      _n = other._n
      size = other.size
      log = other.log
    }

    @inlinable
    public func clone() -> Self {
      return .init(other: self)
    }
  }

  // MARK: -

  extension SegTree {

    /// ベンチマーク用
    @inlinable
    public init(_ N: Int, _ f: () -> S) {
      self.init(_count: N)
      initialize({ _ in f() })
    }

    /// ベンチマーク用
    @inlinable
    public init(_ N: Int, _ f: (Int) -> S) {
      self.init(_count: N)
      initialize(f)
    }
  }

  extension SegTree {

    /// ベンチマーク用
    @inlinable
    mutating func initialize(_ f: (Int) -> S) {
      let d = _d_payload
      d.initialize(repeating: O.e, count: size)
      for i in 0..<_n {
        (d + size + i).initialize(to: f(i))
      }
      (d + size + _n).initialize(repeating: O.e, count: size - _n)
      for i in stride(from: size - 1, through: 1, by: -1) {
        update(i)
      }
    }
  }
#endif

extension SegTree: @unchecked Sendable {}
