import Foundation

/// Reference: https://en.wikipedia.org/wiki/Fenwick_tree
@frozen
public struct FenwickTree<T>
where T: AdditiveArithmetic & ToUnsignedType {

  @usableFromInline
  var buffer: Buffer

  @inlinable
  @inline(__always)
  public init() {
    self.init(0)
  }

  @inlinable
  @inline(__always)
  public init(_ n: Int) {
    buffer = .create(withCapacity: n)
  }
}

extension FenwickTree {

  public typealias U = T.Unsigned

  @inlinable
  @inline(never)
  public mutating func add(_ p: Int, _ x: T) {
    ensureUnique()
    buffer.add(p, x)
  }
  @inlinable
  @inline(never)
  public func sum(_ l: Int, _ r: Int) -> T {
    buffer.sum(l, r)
  }
  @inlinable
  @inline(never)
  public func sum(_ l: Int) -> U {
    buffer.sum(l)
  }
}

extension FenwickTree {

  @frozen
  @usableFromInline
  struct Header {
    @inlinable
    @inline(__always)
    internal init(capacity: Int) {
      self.capacity = capacity
    }
    @usableFromInline var capacity: Int
    #if AC_LIBRARY_INTERNAL_CHECKS
      @usableFromInline var copyCount: UInt = 0
    #endif
  }

  @usableFromInline
  final class Buffer: ManagedBuffer<Header, U> {

    public typealias U = T.Unsigned

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

extension FenwickTree.Buffer {

  @nonobjc
  @inlinable
  @inline(__always)
  internal static func create(
    withCapacity capacity: Int
  ) -> FenwickTree.Buffer {

    let storage = FenwickTree.Buffer.create(minimumCapacity: capacity) { _ in
      FenwickTree.Header(
        capacity: capacity)
    }

    storage.withUnsafeMutablePointerToElements { newElements in
      newElements.initialize(repeating: -1, count: capacity)
    }

    return unsafeDowncast(storage, to: FenwickTree.Buffer.self)
  }

  @nonobjc
  @inlinable
  @inline(__always)
  internal func copy() -> FenwickTree.Buffer {

    let capacity = self._header.pointee.capacity
    #if AC_LIBRARY_INTERNAL_CHECKS
      let copyCount = self._header.pointee.copyCount
    #endif

    let newStorage = FenwickTree.Buffer.create(withCapacity: capacity)

    newStorage._header.pointee.capacity = capacity
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

extension FenwickTree.Buffer {

  @nonobjc
  @inlinable
  @inline(__always)
  var _header: UnsafeMutablePointer<FenwickTree.Header> {
    _read { yield withUnsafeMutablePointerToHeader({ $0 }) }
  }

  @nonobjc
  @inlinable
  @inline(__always)
  var data: UnsafeMutablePointer<U> {
    _read { yield withUnsafeMutablePointerToElements({ $0 }) }
  }

  @nonobjc
  @inlinable
  @inline(__always)
  var _n: Int { _read { yield _header.pointee.capacity } }
}

extension FenwickTree.Buffer {

  @nonobjc
  @inlinable
  @inline(__always)
  func add(_ p: Int, _ x: T) {
    assert(0 <= p && p < _n)
    var p = p + 1
    while p <= _n {
      data[p - 1] &+= x.unsigned
      p += p & -p
    }
  }

  @nonobjc
  @inlinable
  @inline(__always)
  func sum(_ l: Int, _ r: Int) -> T {
    assert(0 <= l && l <= r && r <= _n)
    return T(bitPattern: sum(r) &- sum(l))
  }

  @nonobjc
  @inlinable
  @inline(__always)
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
