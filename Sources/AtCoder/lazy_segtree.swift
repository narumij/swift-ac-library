import Foundation

// MARK: - Lazy Segment Tree

#if !COMPATIBLE_ATCODER_2025
  public protocol LazySegTreeOperator {
    associatedtype S
    associatedtype F

    static func op(_: S, _: S) -> S
    static var e: S { get }
    static func mapping(_: F, _: S) -> S
    static func composition(_: F, _: F) -> F
    static var id: F { get }
  }

  public protocol LazySegTreeOperation: LazySegTreeOperator & SegTreeOperation {
    associatedtype Mapping where Mapping == @Sendable (F, S) -> S
    associatedtype Composition where Composition == @Sendable (F, F) -> F

    static var op: (S, S) -> S { get }
    static var e: S { get }
    static var mapping: (F, S) -> S { get }
    static var composition: (F, F) -> F { get }
    static var id: F { get }
  }

  extension LazySegTreeOperation {
    @inlinable @inline(__always)
    public static func mapping(_ f: F, _ x: S) -> S { (self.mapping as (F, S) -> S)(f, x) }
    @inlinable @inline(__always)
    public static func composition(_ g: F, _ f: F) -> F { (self.composition as (F, F) -> F)(g, f) }
  }

  // MARK: -

  @frozen
  public struct LazySegTree<_S_op_e_F_mapping_composition_id_>: ~Copyable
  where _S_op_e_F_mapping_composition_id_: LazySegTreeOperator {

    public typealias O = _S_op_e_F_mapping_composition_id_
    public typealias S = O.S
    public typealias F = O.F

    @inlinable @inline(__always)
    func op(_ l: S, _ r: S) -> S { O.op(l, r) }

    @inlinable @inline(__always)
    func e() -> S { O.e }

    @inlinable @inline(__always)
    func mapping(_ l: F, _ r: S) -> S { O.mapping(l, r) }

    @inlinable @inline(__always)
    func composition(_ l: F, _ r: F) -> F { O.composition(l, r) }

    @inlinable @inline(__always)
    func id() -> F { O.id }

    @usableFromInline let _d_payload: UnsafeMutablePointer<S>
    @usableFromInline let _lz_payload: UnsafeMutablePointer<F>
    @usableFromInline let _n: Int
    @usableFromInline let size: Int
    @usableFromInline let log: Int

    @usableFromInline let capacity: Int

    deinit {
      _d_payload.deinitialize(count: capacity)
      _d_payload.deallocate()
      _lz_payload.deinitialize(count: size)
      _lz_payload.deallocate()
    }
  }

  extension LazySegTree {

    @inlinable
    var d: UnsafeMutableBufferPointer<S> {
      .init(start: _d_payload, count: capacity)
    }

    @inlinable
    var lz: UnsafeMutableBufferPointer<F> {
      .init(start: _lz_payload, count: size)
    }
  }

  extension LazySegTree {

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

  extension LazySegTree {

    @inlinable
    public mutating func set(_ p: Int, _ x: S) {
      var p = p
      precondition(0 <= p && p < _n)
      p += size
      // for (int i = log; i >= 1; i--) push(p >> i);
      for i in stride(from: log, through: 1, by: -1) { push(p >> i) }
      d[p] = x
      // for (int i = 1; i <= log; i++) update(p >> i);
      for i in stride(from: 1, through: log, by: 1) { update(p >> i) }
    }

    @inlinable
    public mutating func get(_ p: Int) -> S {
      var p = p
      precondition(0 <= p && p < _n)
      p += size
      // for (int i = log; i >= 1; i--) push(p >> i);
      for i in stride(from: log, through: 1, by: -1) { push(p >> i) }
      return d[p]
    }

    @inlinable
    public mutating func prod(_ l: Int, _ r: Int) -> S {
      var l = l
      var r = r
      precondition(0 <= l && l <= r && r <= _n)
      if l == r { return e() }

      l += size
      r += size

      // for (int i = log; i >= 1; i--) {
      for i in stride(from: log, through: 1, by: -1) {
        if (l >> i) << i != l { push(l >> i) }
        if (r >> i) << i != r { push((r - 1) >> i) }
      }

      var sml = e()
      var smr = e()
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
    public func all_prod() -> S { d[1] }

    @inlinable
    public mutating func apply(_ p: Int, _ f: F) {
      var p = p
      precondition(0 <= p && p < _n)
      p += size
      // for (int i = log; i >= 1; i--) push(p >> i);
      for i in stride(from: log, through: 1, by: -1) { push(p >> i) }
      d[p] = mapping(f, d[p])
      // for (int i = 1; i <= log; i++) update(p >> i);
      for i in stride(from: 1, through: log, by: 1) { update(p >> i) }
    }

    @inlinable
    public mutating func apply(_ l: Int, _ r: Int, _ f: F) {
      var l = l
      var r = r
      precondition(0 <= l && l <= r && r <= _n)
      if l == r { return }

      l += size
      r += size

      // for (int i = log; i >= 1; i--) {
      for i in stride(from: log, through: 1, by: -1) {
        if (l >> i) << i != l { push(l >> i) }
        if (r >> i) << i != r { push((r - 1) >> i) }
      }

      do {
        let l2 = l
        let r2 = r
        while l < r {
          if l & 1 != 0 {
            all_apply(l, f)
            l += 1
          }
          if r & 1 != 0 {
            r -= 1
            all_apply(r, f)
          }
          l >>= 1
          r >>= 1
        }
        l = l2
        r = r2
      }

      // for (int i = 1; i <= log; i++) {
      for i in stride(from: 1, through: log, by: 1) {
        if (l >> i) << i != l { update(l >> i) }
        if (r >> i) << i != r { update((r - 1) >> i) }
      }
    }

    @inlinable
    public mutating func max_right(_ l: Int, _ g: (S) -> Bool) -> Int {
      var l = l
      precondition(0 <= l && l <= _n)
      precondition(g(e()))
      if l == _n { return _n }
      l += size
      // for (int i = log; i >= 1; i--) push(l >> i);
      for i in stride(from: log, through: 1, by: -1) { push(l >> i) }
      var sm: S = e()
      repeat {
        while (l & 1) == 0 { l >>= 1 }
        if !g(op(sm, d[l])) {
          while l < size {
            push(l)
            l = l << 1
            if g(op(sm, d[l])) {
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
    public mutating func min_left(_ r: Int, _ g: (S) -> Bool) -> Int {
      var r = r
      precondition(0 <= r && r <= _n)
      precondition(g(e()))
      if r == 0 { return 0 }
      r += size
      // for (int i = log; i >= 1; i--) push((r - 1) >> i);
      for i in stride(from: log, through: 1, by: -1) { push((r - 1) >> i) }
      var sm: S = e()
      repeat {
        r -= 1
        while r > 1, r & 1 != 0 { r >>= 1 }
        if !g(op(d[r], sm)) {
          while r < size {
            push(r)
            r = r << 1 + 1
            if g(op(d[r], sm)) {
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

    @inlinable
    mutating func all_apply(_ k: Int, _ f: F) {
      d[k] = mapping(f, d[k])
      if k < size { lz[k] = composition(f, lz[k]) }
    }

    @inlinable
    mutating func push(_ k: Int) {
      all_apply(k << 1, lz[k])
      all_apply(k << 1 + 1, lz[k])
      lz[k] = id()
    }
  }

  // MARK: -

  extension LazySegTree {

    @inlinable
    internal init(_count count: Int) {
      _n = count
      size = _Internal.bit_ceil(_n)
      log = size.trailingZeroBitCount
      capacity = 2 * size
      _d_payload = .allocate(capacity: capacity)
      _lz_payload = .allocate(capacity: size)
    }
  }

  extension LazySegTree {

    @inlinable
    mutating func initialize() {
      let d = _d_payload
      let lz = _lz_payload

      d.initialize(repeating: O.e, count: size)
      (d + size).initialize(repeating: O.e, count: _n)
      (d + size + _n).initialize(repeating: O.e, count: size - _n)
      lz.initialize(repeating: O.id, count: size)
      for i in stride(from: size - 1, through: 1, by: -1) {
        update(i)
      }
    }
  }

  extension LazySegTree {

    @inlinable
    mutating func initialize<C>(_ v: C) where C: Collection, C.Element == S {
      let d = _d_payload
      let lz = _lz_payload
      d.initialize(repeating: O.e, count: size)
      for (offset, i) in v.indices.enumerated() {
        (d + size + offset).initialize(to: v[i])
      }
      (d + size + _n).initialize(repeating: O.e, count: size - _n)
      lz.initialize(repeating: O.id, count: size)
      for i in stride(from: size - 1, through: 1, by: -1) {
        update(i)
      }
    }
  }

  extension LazySegTree {

    @inlinable
    mutating func initialize(_ v: [S]) {
      let d = _d_payload
      let lz = _lz_payload

      v.withUnsafeBufferPointer { v in
        d.initialize(repeating: O.e, count: size)
        (d + size).initialize(from: v.baseAddress!, count: _n)
        (d + size + _n).initialize(repeating: O.e, count: size - _n)
      }
      lz.initialize(repeating: O.id, count: size)
      for i in stride(from: size - 1, through: 1, by: -1) {
        update(i)
      }
    }
  }

  extension LazySegTree {

    @inlinable
    internal init(other: borrowing Self) {
      _d_payload = UnsafeMutablePointer<S>.allocate(capacity: other.capacity)
      _d_payload.initialize(from: other._d_payload, count: other.capacity)
      _lz_payload = UnsafeMutablePointer<F>.allocate(capacity: other.size)
      _lz_payload.initialize(from: other._lz_payload, count: other.size)
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

  extension LazySegTree {

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

  extension LazySegTree {

    /// ベンチマーク用
    @inlinable
    mutating func initialize(_ f: (Int) -> S) {
      let d = _d_payload
      let lz = _lz_payload

      d.initialize(repeating: O.e, count: size)
      for i in 0..<_n {
        (d + size + i).initialize(to: f(i))
      }
      (d + size + _n).initialize(repeating: O.e, count: size - _n)
      lz.initialize(repeating: O.id, count: size)
      for i in stride(from: size - 1, through: 1, by: -1) {
        update(i)
      }
    }
  }

  extension LazySegTree: @unchecked Sendable {}
#endif
