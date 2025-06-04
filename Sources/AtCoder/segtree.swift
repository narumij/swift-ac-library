import Foundation

// MARK: - Segment Tree

public protocol SegTreeOperator {
  associatedtype S
  static func op(_ x: S, _ y: S) -> S
  static var e: S { get }
}

extension SegTreeOperator {
  public typealias Op = (S, S) -> S
}

public protocol SegTreeOperation: SegTreeOperator {
  associatedtype S
  static var op: (S, S) -> S { get }
  static var e: S { get }
}

extension SegTreeOperation {
  @inlinable @inline(__always)
  public static func op(_ x: S, _ y: S) -> S { (self.op as Op)(x, y) }
}

@frozen
public struct SegTree<_S_op_e_>
where _S_op_e_: SegTreeOperator {
  public typealias O = _S_op_e_
  public typealias S = O.S

  @inlinable
  @inline(__always)
  public init() { self.init(0) }

  @inlinable
  @inline(__always)
  public init(_ n: Int) { self.init([S](repeating: O.e, count: n)) }

  @inlinable
  @inline(__always)
  public init(_ v: [S]) {
    self.buffer = .create(withCount: v.count)
    buffer.initialize(v)
  }

  @usableFromInline
  var buffer: Buffer
}

extension SegTree {
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

extension SegTree {

  @usableFromInline
  struct Header {
    @inlinable
    @inline(__always)
    internal init(capacity: Int, _n: Int, _size: Int, _log: Int) {
      self.capacity = capacity
      self._n = _n
      self._size = _size
      self._log = _log
    }
    @usableFromInline var capacity: Int
    @usableFromInline var _n, _size, _log: Int
    #if AC_LIBRARY_INTERNAL_CHECKS
      @usableFromInline var copyCount: UInt = 0
    #endif
  }

  @usableFromInline
  class Buffer: ManagedBuffer<Header, S> {
    public typealias O = _S_op_e_
    public typealias S = O.S
    @inlinable @inline(__always) func op(_ l: S, _ r: S) -> S { O.op(l, r) }
    @inlinable @inline(__always) func e() -> S { O.e }

    @inlinable
    deinit {
      self.withUnsafeMutablePointers { header, elements in
        elements.deinitialize(count: header.pointee.capacity)
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

extension SegTree.Buffer {

  @inlinable
  @inline(__always)
  internal static func create(
    withCapacity capacity: Int
  ) -> SegTree.Buffer {
    let storage = SegTree.Buffer.create(minimumCapacity: capacity) { _ in
      SegTree.Header(capacity: capacity, _n: 0, _size: 0, _log: 0)
    }
    return unsafeDowncast(storage, to: SegTree.Buffer.self)
  }

  @inlinable
  @inline(__always)
  internal static func create(
    withCount count: Int
  ) -> SegTree.Buffer {

    let _n: Int = count
    let size: Int = _Internal.bit_ceil(_n)
    let log: Int = _Internal.countr_zero(size)
    let capacity = 2 * size

    let storage = SegTree.Buffer.create(minimumCapacity: capacity) { _ in
      SegTree.Header(capacity: capacity, _n: _n, _size: size, _log: log)
    }

    return unsafeDowncast(storage, to: SegTree.Buffer.self)
  }

  @usableFromInline
  @inline(__always)
  internal func copy() -> SegTree.Buffer {

    let capacity = self._header.pointee.capacity
    let _n = self._header.pointee._n
    let _size = self._header.pointee._size
    let _log = self._header.pointee._log
    #if AC_LIBRARY_INTERNAL_CHECKS
      let copyCount = self._header.pointee.copyCount
    #endif

    let newStorage = SegTree.Buffer.create(withCapacity: capacity)

    newStorage._header.pointee.capacity = capacity
    newStorage._header.pointee._n = _n
    newStorage._header.pointee._size = _size
    newStorage._header.pointee._log = _log
    #if AC_LIBRARY_INTERNAL_CHECKS
      newStorage._header.pointee.copyCount = copyCount &+ 1
    #endif

    self.withUnsafeMutablePointerToElements { oldNodes in
      newStorage.withUnsafeMutablePointerToElements { newNodes in
        newNodes.initialize(from: oldNodes, count: capacity)
      }
    }

    return newStorage
  }
}

extension SegTree.Buffer {

  @inlinable
  @inline(__always)
  var _header: UnsafeMutablePointer<SegTree.Header> {
    _read { yield withUnsafeMutablePointerToHeader({ $0 }) }
  }

  @inlinable
  @inline(__always)
  var d: UnsafeMutablePointer<S> {
    _read { yield withUnsafeMutablePointerToElements({ $0 }) }
  }

  @inlinable
  @inline(__always)
  var _n: Int { _read { yield _header.pointee._n } }

  @inlinable
  @inline(__always)
  var size: Int { _read { yield _header.pointee._size } }

  @inlinable
  @inline(__always)
  var log: Int { _read { yield _header.pointee._log } }

  @inlinable
  @inline(__always)
  func initialize(_ v: [S]) {
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

extension SegTree.Buffer {

  @inlinable
  @inline(__always)
  func set(_ p: Int, _ x: S) {
    var p = p
    assert(0 <= p && p < _n)
    p += size
    d[p] = x
    // for (int i = 1; i <= log; i++) update(p >> i);
    for i in stride(from: 1, through: log, by: 1) { update(p >> i) }
  }

  @inlinable
  @inline(__always)
  func get(_ p: Int) -> S {
    assert(0 <= p && p < _n)
    return d[p + size]
  }

  @inlinable
  @inline(__always)
  func prod(_ l: Int, _ r: Int) -> S {
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
  @inline(__always)
  func all_prod() -> S { return d[1] }

  @inlinable
  @inline(__always)
  func max_right(_ l: Int, _ f: (S) -> Bool) -> Int {
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
          l = (l << 1)
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
  @inline(__always)
  func min_left(_ r: Int, _ f: (S) -> Bool) -> Int {
    var r = r
    assert(0 <= r && r <= _n)
    assert(f(e()))
    if r == 0 { return 0 }
    r += size
    var sm: S = e()
    repeat {
      r -= 1
      while r > 1 && (r & 1) != 0 { r >>= 1 }
      if !f(op(d[r], sm)) {
        while r < size {
          r = (r << 1) + 1
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
  @inline(__always)
  func update(_ k: Int) {
    d[k] = op(d[k << 1], d[(k << 1) + 1])
  }
}
