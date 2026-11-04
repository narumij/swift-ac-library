extension _Internal {

  @usableFromInline
  struct _RawArray<Element>: ~Copyable {
    @usableFromInline let capacity: Int
    @usableFromInline let buffer: UnsafeMutablePointer<Element>
    @usableFromInline var size: Int
    @inlinable
    init(_ n: Int) {
      capacity = n
      buffer = .allocate(capacity: n)
      size = 0
    }
    @inlinable
    mutating func append(_ e: Element) {
      (buffer + size).pointee = e
      size += 1
    }
    @discardableResult
    @inlinable
    mutating func removeLast() -> Element {
      defer { size -= 1 }
      return (buffer + size - 1).move()
    }
    @discardableResult
    @inlinable
    mutating func popLast() -> Element? {
      if size == 0 { return nil }
      defer { size -= 1 }
      return (buffer + size - 1).pointee
    }
    @inlinable
    var last: Element? { size == 0 ? nil : buffer[size &- 1] }
    @inlinable
    var count: Int { size }
    @inlinable
    subscript(position: Int) -> Element {
      unsafeAddress { UnsafePointer(buffer + position) }
      unsafeMutableAddress { buffer + position }
    }
    deinit {
      buffer.deallocate()
    }
  }
}

// MARK: -

extension _Internal {

  @usableFromInline
  struct _Array<Element>: ~Copyable {
    @usableFromInline let capacity: Int
    @usableFromInline let buffer: UnsafeMutablePointer<Element>
    @usableFromInline var size: Int
    @inlinable
    init(_ n: Int) {
      capacity = n
      buffer = .allocate(capacity: n)
      size = 0
    }
    @inlinable
    mutating func append(_ e: Element) {
      (buffer + size).initialize(to: e)
      size += 1
    }
    @discardableResult
    @inlinable
    mutating func removeLast() -> Element {
      defer { size -= 1 }
      return (buffer + size - 1).move()
    }
    @discardableResult
    @inlinable
    mutating func popLast() -> Element? {
      if size == 0 { return nil }
      defer { size -= 1 }
      return (buffer + size - 1).move()
    }
    @inlinable
    var last: Element? { size == 0 ? nil : buffer[size &- 1] }
    @inlinable
    var count: Int { size }
    @inlinable
    subscript(position: Int) -> Element {
      unsafeAddress { UnsafePointer(buffer + position) }
      unsafeMutableAddress { buffer + position }
    }
    deinit {
      buffer.deinitialize(count: size)
      buffer.deallocate()
    }
  }
}
