import Foundation

/// Implement (union by size) + (path compression)
/// Reference:
/// Zvi Galil and Giuseppe F. Italiano,
/// Data structures and algorithms for disjoint set union problems
@frozen
public struct DSU {
  @usableFromInline var buffer: Buffer
}

extension DSU {
  @inlinable
  @inline(__always)
  public init() {
    buffer = .create(withCapacity: 0)
  }
  @inlinable
  @inline(__always)
  public init(_ n: Int) {
    buffer = .create(withCapacity: n)
  }
}

extension DSU {
  @inlinable
  @inline(never)
  @discardableResult
  public mutating func merge(_ a: Int, _ b: Int) -> Int {
    ensureUnique()
    return buffer.merge(a, b)
  }
  @inlinable
  @inline(never)
  public mutating func same(_ a: Int, _ b: Int) -> Bool {
    ensureUnique()
    return buffer.same(a, b)
  }
  @inlinable
  @inline(never)
  public mutating func leader(_ a: Int) -> Int {
    ensureUnique()
    return buffer.leader(a)
  }
  @inlinable
  @inline(never)
  public mutating func size(_ a: Int) -> Int {
    buffer.size(a)
  }
  @inlinable
  @inline(never)
  public mutating func groups() -> [[Int]] {
    ensureUnique()
    return buffer.groups()
  }
}

extension DSU {

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

  /// root node: -1 * component size
  /// otherwise: parent
  @usableFromInline
  final class Buffer: ManagedBuffer<Header, Int> {

    public typealias Header = DSU.Header

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

extension DSU.Buffer {

  @nonobjc
  @inlinable
  @inline(__always)
  internal static func create(
    withCapacity capacity: Int
  ) -> DSU.Buffer {

    let storage = DSU.Buffer.create(minimumCapacity: capacity) { _ in
      DSU.Header(
        capacity: capacity)
    }

    storage.withUnsafeMutablePointerToElements { newElements in
      newElements.initialize(repeating: -1, count: capacity)
    }

    return unsafeDowncast(storage, to: DSU.Buffer.self)
  }

  @nonobjc
  @inlinable
  @inline(__always)
  internal func copy() -> DSU.Buffer {

    let capacity = self._header.pointee.capacity
    #if AC_LIBRARY_INTERNAL_CHECKS
      let copyCount = self._header.pointee.copyCount
    #endif

    let newStorage = DSU.Buffer.create(withCapacity: capacity)

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

extension DSU.Buffer {

  @nonobjc
  @inlinable
  @inline(__always)
  var _header: UnsafeMutablePointer<DSU.Header> {
    _read { yield withUnsafeMutablePointerToHeader({ $0 }) }
  }

  @nonobjc
  @inlinable
  @inline(__always)
  var parent_or_size: UnsafeMutablePointer<Int> {
    _read { yield withUnsafeMutablePointerToElements({ $0 }) }
  }

  @nonobjc
  @inlinable
  @inline(__always)
  var _n: Int { _read { yield _header.pointee.capacity } }

  @nonobjc
  @inlinable
  @inline(__always)
  func merge(_ a: Int, _ b: Int) -> Int {
    assert(0 <= a && a < _n)
    assert(0 <= b && b < _n)
    var (x, y) = (leader(a), leader(b))
    if x == y { return x }
    if -parent_or_size[x] < -parent_or_size[y] { swap(&x, &y) }
    parent_or_size[x] += parent_or_size[y]
    parent_or_size[y] = x
    return x
  }

  @nonobjc
  @inlinable
  @inline(__always)
  func same(_ a: Int, _ b: Int) -> Bool {
    assert(0 <= a && a < _n)
    assert(0 <= b && b < _n)
    return leader(a) == leader(b)
  }

  @nonobjc
  @inlinable
  @inline(__always)
  func leader(_ a: Int) -> Int {
    assert(0 <= a && a < _n)
    return _leader(a)
  }

  @nonobjc
  @inlinable
  @inline(__always)
  func size(_ a: Int) -> Int {
    assert(0 <= a && a < _n)
    return -parent_or_size[leader(a)]
  }

  @nonobjc
  @inlinable
  @inline(__always)
  func groups() -> [[Int]] {
    var leader_buf = [Int](repeating: -1, count: _n)
    var group_size = [Int](repeating: -1, count: _n)
    for i in 0..<_n {
      leader_buf[i] = leader(i)
      group_size[leader_buf[i]] += 1
    }
    var result: [[Int]] = [[Int]](repeating: [], count: _n)
    for i in 0..<_n {
      result[i].reserveCapacity(group_size[i])
    }
    for i in 0..<_n {
      result[leader_buf[i]].append(i)
    }
    result.removeAll { $0.isEmpty }
    return result
  }
  
  @nonobjc
  @inlinable
  @inline(__always)
  func _leader(_ a: Int) -> Int {
    if parent_or_size[a] < 0 { return a }
    parent_or_size[a] = _leader(parent_or_size[a])
    return parent_or_size[a]
  }
}
