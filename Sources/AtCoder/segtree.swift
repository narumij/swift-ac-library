import Foundation

public protocol SegtreeParameter {
  associatedtype S
  static var op: Op { get }
  static var e: S { get }
}

extension SegtreeParameter {
  public typealias Op = (S, S) -> S
}

public struct SegTree<P: SegtreeParameter> {
  public typealias S = P.S

  @inlinable public init() { self.init(0) }
  @inlinable public init(_ n: Int) { self.init([S](repeating: P.e, count: n)) }
  @inlinable public init(_ v: [S]) {
    _n = v.count
    size = _Internal.bit_ceil(CUnsignedInt(_n))
    log = _Internal.countr_zero(CUnsignedInt(size))
    let s = size
    let n = _n
    let l = log
    d = .init(unsafeUninitializedCapacity: 2 * s) { buffer, initializedCount in
      for i in 0..<s {
        buffer.initializeElement(at: i, to: P.e)
        if i < (s - n) {
          buffer.initializeElement(at: i + s + n, to: P.e)
        }
      }
      for i in s..<s + n {
        buffer.initializeElement(at: i, to: v[i - s])
      }
      let handler = _UnsafeHandle(_n: n, size: s, log: l, d: buffer.baseAddress!)
      for i in stride(from: s - 1, through: 1, by: -1) {
        handler.update(i)
      }
      initializedCount = 2 * s
    }
  }
  @usableFromInline let _n, size, log: Int
  @usableFromInline var d: [S]
}

extension SegTree._UnsafeHandle {

  @inlinable func set(_ p: Int, _ x: S) {
    var p = p
    assert(0 <= p && p < _n)
    p += size
    d[p] = x
    // for (int i = 1; i <= log; i++) update(p >> i);
    for i in stride(from: 1, through: log, by: 1) { update(p >> i) }
  }

  @inlinable func get(_ p: Int) -> S {
    assert(0 <= p && p < _n)
    return d[p + size]
  }

  @inlinable func prod(_ l: Int, _ r: Int) -> S {
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
}

extension SegTree {
  @inlinable @inline(__always)
  public func all_prod() -> S { return d[1] }
}

extension SegTree._UnsafeHandle {

  @inlinable func max_right(_ l: Int, _ f: (S) -> Bool) -> Int {
    var l = l
    assert(0 <= l && l <= _n)
    assert(f(e()))
    if l == _n { return _n }
    l += size
    var sm: S = e()
    repeat {
      while l % 2 == 0 { l >>= 1 }
      if !f(op(sm, d[l])) {
        while l < size {
          l = (2 * l)
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

  @inlinable func min_left(_ r: Int, _ f: (S) -> Bool) -> Int {
    var r = r
    assert(0 <= r && r <= _n)
    assert(f(e()))
    if r == 0 { return 0 }
    r += size
    var sm: S = e()
    repeat {
      r -= 1
      while r > 1 && r % 2 != 0 { r >>= 1 }
      if !f(op(d[r], sm)) {
        while r < size {
          r = (2 * r + 1)
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

  @inlinable public func update(_ k: Int) {
    d[k] = op(d[2 * k], d[2 * k + 1])
  }
}

extension SegTree {

  @usableFromInline
  struct _UnsafeHandle {

    @inlinable @inline(__always)
    internal init(
      _n: Int,
      size: Int,
      log: Int,
      d: UnsafeMutablePointer<S>
    ) {
      self._n = _n
      self.size = size
      self.log = log
      self.d = d
    }

    @usableFromInline let _n, size, log: Int
    @usableFromInline let d: UnsafeMutablePointer<S>

    @usableFromInline typealias S = P.S
    @inlinable @inline(__always) func op(_ l: S, _ r: S) -> S { P.op(l, r) }
    @inlinable @inline(__always) func e() -> S { P.e }
  }

  @inlinable @inline(__always)
  mutating func _update<R>(_ body: (_UnsafeHandle) -> R) -> R {
    d.withUnsafeMutableBufferPointer { d in
      body(_UnsafeHandle(_n: _n, size: size, log: log, d: d.baseAddress!))
    }
  }
}

extension SegTree {
  @inlinable
  public mutating func set(_ p: Int, _ x: S) {
    _update { $0.set(p, x) }
  }
  @inlinable
  public mutating func get(_ p: Int) -> S {
    _update { $0.get(p) }
  }
  @inlinable
  public mutating func prod(_ l: Int, _ r: Int) -> S {
    _update { $0.prod(l, r) }
  }
  @inlinable
  public mutating func max_right(_ l: Int, _ g: (S) -> Bool) -> Int {
    _update { $0.max_right(l, g) }
  }
  @inlinable
  public mutating func min_left(_ r: Int, _ g: (S) -> Bool) -> Int {
    _update { $0.min_left(r, g) }
  }
}
