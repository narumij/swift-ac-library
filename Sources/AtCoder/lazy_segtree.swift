import Foundation

// MARK: - Lazy Segment Tree

public protocol LazySegTreeOperator {
  associatedtype S
  associatedtype F
  static func op(_: S, _: S) -> S
  static var e: S { get }
  static func mapping(_: F, _: S) -> S
  static func composition(_: F, _: F) -> F
  static var id: F { get }
}

extension LazySegTreeOperator {
  public typealias Op = (S, S) -> S
  public typealias Mapping = (F, S) -> S
  public typealias Composition = (F, F) -> F
}

public protocol LazySegTreeOperation: LazySegTreeOperator {
  associatedtype S
  associatedtype F
  static var op: (S, S) -> S { get }
  static var e: S { get }
  static var mapping: (F, S) -> S { get }
  static var composition: (F, F) -> F { get }
  static var id: F { get }
}

extension LazySegTreeOperation {
  @inlinable @inline(__always)
  public static func op(_ x: S, _ y: S) -> S { (self.op as Op)(x, y) }
  @inlinable @inline(__always)
  public static func mapping(_ f: F, _ x: S) -> S { (self.mapping as Mapping)(f, x) }
  @inlinable @inline(__always)
  public static func composition(_ g: F, _ f: F) -> F { (self.composition as Composition)(g, f) }
}

@frozen
public struct LazySegTree<_S_op_e_F_mapping_composition_id_>
where _S_op_e_F_mapping_composition_id_: LazySegTreeOperator {
  public typealias O = _S_op_e_F_mapping_composition_id_
  public typealias S = O.S
  public typealias F = O.F

  @inlinable
  @inline(__always)
  public init() {
    self.init(0)
  }

  @inlinable
  @inline(__always)
  public init(_ n: Int) {
    self.init([S](repeating: O.e, count: n))
  }

  @inlinable
  @inline(__always)
  public init(_ v: [S]) {
    self.buffer = .create(withCount: v.count)
    buffer.initialize(v)
  }

  @usableFromInline var buffer: Buffer
}

extension LazySegTree {
  @inlinable
  @inline(never)
  public mutating func set(_ p: Int, _ x: S) {
    ensureUnique()
    buffer.set(p, x)
  }
  @inlinable
  @inline(never)
  public mutating func get(_ p: Int) -> S {
    ensureUnique()
    return buffer.get(p)
  }
  @inlinable
  @inline(never)
  public mutating func prod(_ l: Int, _ r: Int) -> S {
    ensureUnique()
    return buffer.prod(l, r)
  }
  @inlinable
  @inline(never)
  public func all_prod() -> S {
    buffer.all_prod()
  }
  @inlinable
  @inline(never)
  public mutating func apply(_ p: Int, _ f: F) {
    ensureUnique()
    buffer.apply(p, f)
  }
  @inlinable
  @inline(never)
  public mutating func apply(_ l: Int, _ r: Int, _ f: F) {
    ensureUnique()
    buffer.apply(l, r, f)
  }
  @inlinable
  @inline(never)
  public mutating func max_right(_ l: Int, _ g: (S) -> Bool) -> Int {
    ensureUnique()
    return buffer.max_right(l, g)
  }
  @inlinable
  @inline(never)
  public mutating func min_left(_ r: Int, _ g: (S) -> Bool) -> Int {
    ensureUnique()
    return buffer.min_left(r, g)
  }
}

extension LazySegTree {

  @frozen
  @usableFromInline
  struct Header {
    @inlinable
    @inline(__always)
    internal init(capacity: Int, _n: Int, _size: Int, _log: Int, _lz: UnsafeMutablePointer<F>?) {
      self.capacity = capacity
      self._n = _n
      self._size = _size
      self._log = _log
      self._lz = _lz
    }
    @usableFromInline var capacity: Int
    @usableFromInline var _n, _size, _log: Int
    @usableFromInline var _lz: UnsafeMutablePointer<F>?
    #if AC_LIBRARY_INTERNAL_CHECKS
      @usableFromInline var copyCount: UInt = 0
    #endif
  }

  @usableFromInline
  final class Buffer: ManagedBuffer<Header, S> {
    public typealias O = _S_op_e_F_mapping_composition_id_
    public typealias S = O.S
    @inlinable @inline(__always) func op(_ l: S, _ r: S) -> S { O.op(l, r) }
    @inlinable @inline(__always) func e() -> S { O.e }
    public typealias F = O.F
    @inlinable @inline(__always) func mapping(_ l: F, _ r: S) -> S { O.mapping(l, r) }
    @inlinable @inline(__always) func composition(_ l: F, _ r: F) -> F { O.composition(l, r) }
    @inlinable @inline(__always) func id() -> F { O.id }

    @inlinable
    deinit {
      self.withUnsafeMutablePointers { header, elements in
        elements.deinitialize(count: header.pointee.capacity)
        header.pointee._lz?.deinitialize(count: header.pointee._size)
        header.pointee._lz?.deallocate()
        header.deinitialize(count: 1)
      }
    }
  }

  @inlinable
  @inline(__always)
  mutating func ensureUnique() {
    #if !DISABLE_COPY_ON_WRITE
      if !isKnownUniquelyReferenced(&buffer) {
        buffer = buffer.copy()
      }
    #endif
  }
}

extension LazySegTree.Buffer {
  
  @nonobjc
  @inlinable
  @inline(__always)
  internal static func create(
    withCapacity capacity: Int
  ) -> LazySegTree.Buffer {
    let storage = LazySegTree.Buffer.create(minimumCapacity: capacity) { _ in
      LazySegTree.Header(capacity: capacity, _n: 0, _size: 0, _log: 0, _lz: nil)
    }
    return unsafeDowncast(storage, to: LazySegTree.Buffer.self)
  }

  @nonobjc
  @inlinable
  @inline(__always)
  internal static func create(
    withCount count: Int
  ) -> LazySegTree.Buffer {

    let _n: Int = count
    let size: Int = _Internal.bit_ceil(_n)
    let log: Int = _Internal.countr_zero(size)
    let capacity = 2 * size

    let storage = LazySegTree.Buffer.create(minimumCapacity: capacity) { _ in
      LazySegTree.Header(
        capacity: capacity, _n: _n, _size: size, _log: log,
        _lz: UnsafeMutablePointer<F>.allocate(capacity: size))
    }

    return unsafeDowncast(storage, to: LazySegTree.Buffer.self)
  }

  @nonobjc
  @inlinable
  @inline(__always)
  internal func copy() -> LazySegTree.Buffer {

    let capacity = self._header.pointee.capacity
    let _n = self._header.pointee._n
    let _size = self._header.pointee._size
    let _log = self._header.pointee._log
    #if AC_LIBRARY_INTERNAL_CHECKS
      let copyCount = self._header.pointee.copyCount
    #endif

    let newStorage = LazySegTree.Buffer.create(withCapacity: capacity)

    newStorage._header.pointee.capacity = capacity
    newStorage._header.pointee._n = _n
    newStorage._header.pointee._size = _size
    newStorage._header.pointee._log = _log
    newStorage._header.pointee._lz = UnsafeMutablePointer<F>.allocate(capacity: _size)
    #if AC_LIBRARY_INTERNAL_CHECKS
      newStorage._header.pointee.copyCount = copyCount &+ 1
    #endif

    self.withUnsafeMutablePointerToElements { oldNodes in
      newStorage.withUnsafeMutablePointerToElements { newNodes in
        newNodes.initialize(from: oldNodes, count: capacity)
      }
    }

    self._header.pointee._lz.map { oldLz in
      newStorage._header.pointee._lz.map { newLz in
        newLz.initialize(from: oldLz, count: _size)
      }
    }

    return newStorage
  }
}

extension LazySegTree.Buffer {

  @nonobjc
  @inlinable
  @inline(__always)
  var _header: UnsafeMutablePointer<LazySegTree.Header> {
    _read { yield withUnsafeMutablePointerToHeader({ $0 }) }
  }

  @nonobjc
  @inlinable
  @inline(__always)
  var d: UnsafeMutablePointer<S> {
    _read { yield withUnsafeMutablePointerToElements({ $0 }) }
  }

  @nonobjc
  @inlinable
  @inline(__always)
  var lz: UnsafeMutablePointer<F> {
    _read { yield _header.pointee._lz! }
  }

  @nonobjc
  @inlinable
  @inline(__always)
  var _n: Int { _read { yield _header.pointee._n } }

  @nonobjc
  @inlinable
  @inline(__always)
  var size: Int { _read { yield _header.pointee._size } }

  @nonobjc
  @inlinable
  @inline(__always)
  var log: Int { _read { yield _header.pointee._log } }

  @nonobjc
  @inlinable
  @inline(__always)
  func initialize(_ v: [S]) {
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

extension LazySegTree.Buffer {

  @nonobjc
  @inlinable
  @inline(__always)
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

  @nonobjc
  @inlinable
  @inline(__always)
  func get(_ p: Int) -> S {
    var p = p
    assert(0 <= p && p < _n)
    p += size
    // for (int i = log; i >= 1; i--) push(p >> i);
    for i in stride(from: log, through: 1, by: -1) { push(p >> i) }
    return d[p]
  }

  @nonobjc
  @inlinable
  @inline(__always)
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

  @nonobjc
  @inlinable
  @inline(__always)
  public func all_prod() -> S { d[1] }

  @nonobjc
  @inlinable
  @inline(__always)
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

  @nonobjc
  @inlinable
  @inline(__always)
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

  @nonobjc
  @inlinable
  @inline(__always)
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
      while (l & 1) == 0 { l >>= 1 }
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

  @nonobjc
  @inlinable
  @inline(__always)
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
      while r > 1 && (r & 1) != 0 { r >>= 1 }
      if !g(op(d[r], sm)) {
        while r < size {
          push(r)
          r = (r << 1 + 1)
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

  @nonobjc
  @inlinable
  @inline(__always)
  public func update(_ k: Int) {
    d[k] = op(d[k << 1], d[(k << 1) + 1])
  }

  @nonobjc
  @inlinable
  @inline(__always)
  func all_apply(_ k: Int, _ f: F) {
    d[k] = mapping(f, d[k])
    if k < size { lz[k] = composition(f, lz[k]) }
  }

  @nonobjc
  @inlinable
  @inline(__always)
  func push(_ k: Int) {
    all_apply(k << 1, lz[k])
    all_apply(k << 1 + 1, lz[k])
    lz[k] = id()
  }
}
