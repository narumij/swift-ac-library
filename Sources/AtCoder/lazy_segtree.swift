import Foundation

// MARK: - Lazy SegTree

public protocol LazySegtreeParameter {
  associatedtype S
  associatedtype F
  static var op: Op { get }
  static var e: E { get }
  static var mapping: Mapping { get }
  static var composition: Composition { get }
  static var id: Id { get }
}

extension LazySegtreeParameter {
  public typealias Op = (S, S) -> S
  public typealias E = S
  public typealias Mapping = (F, S) -> S
  public typealias Composition = (F, F) -> F
  public typealias Id = F
}

public struct LazySegTree<P: LazySegtreeParameter> {
  public typealias S = P.S
  public typealias F = P.F

  public init() { self.init(0) }
  public init(_ n: Int) { self.init([S](repeating: P.e, count: n)) }
  public init(_ v: [S]) {
    _n = v.count
    size = _Internal.bit_ceil(CUnsignedInt(_n))
    log = _Internal.countr_zero(CUnsignedInt(size))
    d = .init(repeating: P.e, count: 2 * size)
    lz = .init(repeating: P.id, count: size)
    // for (int i = 0; i < _n; i++) d[size + i] = v[i];
    for i in 0..<_n { d[size + i] = v[i] }
    // for (int i = size - 1; i >= 1; i--) {
    for i in stride(from: size - 1, through: 1, by: -1) {
      _update { $0.update(i) }
    }
  }

  @usableFromInline let _n, size, log: Int
  @usableFromInline var d: ContiguousArray<S>
  @usableFromInline var lz: ContiguousArray<F>
}

extension LazySegTree._UnsafeHandle {

  @inlinable @inline(__always)
  func set(_ p: Int, _ x: S) {
    var p = p
    assert(0 <= p && p < _n)
    p += size
    // for (int i = log; i >= 1; i--) push(p >> i);
    for i in stride(from: log, through: 1, by: -1) { push(p >> i) }
    d[p] = x
    // for (int i = 1; i <= log; i++) update(p >> i);
    for i in stride(from: 1, through: log, by: 1) { update(p >> i) }
  }

  @inlinable @inline(__always)
  func get(_ p: Int) -> S {
    var p = p
    assert(0 <= p && p < _n)
    p += size
    // for (int i = log; i >= 1; i--) push(p >> i);
    for i in stride(from: log, through: 1, by: -1) { push(p >> i) }
    return d[p]
  }

  @inlinable @inline(__always)
  func prod(_ l: Int, _ r: Int) -> S {
    var l = l
    var r = r
    assert(0 <= l && l <= r && r <= _n)
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
}

extension LazySegTree {
  public func all_prod() -> S { return d[1] }
}

extension LazySegTree._UnsafeHandle {

  @inlinable @inline(__always)
  func apply(_ p: Int, _ f: F) {
    var p = p
    assert(0 <= p && p < _n)
    p += size
    // for (int i = log; i >= 1; i--) push(p >> i);
    for i in stride(from: log, through: 1, by: -1) { push(p >> i) }
    d[p] = mapping(f, d[p])
    // for (int i = 1; i <= log; i++) update(p >> i);
    for i in stride(from: 1, through: log, by: 1) { update(p >> i) }
  }

  @inlinable @inline(__always)
  func apply(_ l: Int, _ r: Int, _ f: F) {
    var l = l
    var r = r
    assert(0 <= l && l <= r && r <= _n)
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

  @inlinable @inline(__always)
  func max_right(_ l: Int, _ g: (S) -> Bool) -> Int {
    var l = l
    assert(0 <= l && l <= _n)
    assert(g(e()))
    if l == _n { return _n }
    l += size
    // for (int i = log; i >= 1; i--) push(l >> i);
    for i in stride(from: log, through: 1, by: -1) { push(l >> i) }
    var sm: S = e()
    repeat {
      while l % 2 == 0 { l >>= 1 }
      if !g(op(sm, d[l])) {
        while l < size {
          push(l)
          l = (2 * l)
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

  @inlinable @inline(__always)
  func min_left(_ r: Int, _ g: (S) -> Bool) -> Int {
    var r = r
    assert(0 <= r && r <= _n)
    assert(g(e()))
    if r == 0 { return 0 }
    r += size
    // for (int i = log; i >= 1; i--) push((r - 1) >> i);
    for i in stride(from: log, through: 1, by: -1) { push((r - 1) >> i) }
    var sm: S = e()
    repeat {
      r -= 1
      while r > 1 && r % 2 != 0 { r >>= 1 }
      if !g(op(d[r], sm)) {
        while r < size {
          push(r)
          r = (2 * r + 1)
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

  @inlinable @inline(__always)
  public func update(_ k: Int) { d[k] = op(d[2 * k], d[2 * k + 1]) }

  @inlinable @inline(__always)
  func all_apply(_ k: Int, _ f: F) {
    d[k] = mapping(f, d[k])
    if k < size { lz[k] = composition(f, lz[k]) }
  }

  @inlinable @inline(__always)
  func push(_ k: Int) {
    all_apply(2 * k, lz[k])
    all_apply(2 * k + 1, lz[k])
    lz[k] = id()
  }
}

extension LazySegTree {

  @usableFromInline
  struct _UnsafeHandle {

    @inlinable @inline(__always)
    internal init(
      _n: Int,
      size: Int,
      log: Int,
      d: UnsafeMutablePointer<S>,
      lz: UnsafeMutablePointer<F>
    ) {
      self._n = _n
      self.size = size
      self.log = log
      self.d = d
      self.lz = lz
    }

    @usableFromInline let _n, size, log: Int
    @usableFromInline let d: UnsafeMutablePointer<S>
    @usableFromInline let lz: UnsafeMutablePointer<F>

    @usableFromInline typealias S = P.S
    @usableFromInline func op(_ l: S, _ r: S) -> S { P.op(l, r) }
    @usableFromInline func e() -> S { P.e }

    @usableFromInline typealias F = P.F
    @usableFromInline func mapping(_ l: F, _ r: S) -> S { P.mapping(l, r) }
    @usableFromInline func composition(_ l: F, _ r: F) -> F { P.composition(l, r) }
    @usableFromInline func id() -> F { P.id }
  }

  @inlinable @inline(__always)
  mutating func _update<R>(_ body: (_UnsafeHandle) -> R) -> R {
    d.withUnsafeMutableBufferPointer { d in
      lz.withUnsafeMutableBufferPointer { lz in
        body(
          _UnsafeHandle(
            _n: _n, size: size, log: log, d: d.baseAddress!, lz: lz.baseAddress!))
      }
    }
  }
}

extension LazySegTree {
  public mutating func set(_ p: Int, _ x: S) { _update { $0.set(p, x) } }
  public mutating func get(_ p: Int) -> S { _update { $0.get(p) } }
  public mutating func prod(_ l: Int, _ r: Int) -> S { _update { $0.prod(l, r) } }
  public mutating func apply(_ p: Int, _ f: F) { _update { $0.apply(p, f) } }
  public mutating func apply(_ l: Int, _ r: Int, _ f: F) { _update { $0.apply(l, r, f) } }
  public mutating func max_right(_ l: Int, _ g: (S) -> Bool) -> Int {
    _update { $0.max_right(l, g) }
  }
  public mutating func min_left(_ r: Int, _ g: (S) -> Bool) -> Int {
    _update { $0.min_left(r, g) }
  }
}
