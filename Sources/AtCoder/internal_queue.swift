extension _Internal {

  @usableFromInline
  struct simple_queue<T>: ~Copyable {
    @inlinable
    init(_ n: Int) {
      self.payload = _Internal.create_buffer(T.self, n)
    }
    @usableFromInline var payload: UnsafeMutableBufferPointer<T>
    @usableFromInline var pos = 0
    @usableFromInline var _size = 0
    @inlinable
    mutating func reserve(_ n: Int) {
      payload.deallocate()
      payload = .init(start: .allocate(capacity: n), count: n)
    }
    @inlinable
    func size() -> Int { _size - pos }
    @inlinable
    func empty() -> Bool {
      _size == pos
    }
    @inlinable
    mutating func push(_ t: T) {
      payload[_size] = t
      _size += 1
    }
    @inlinable
    func front() -> T {
      payload[pos]
    }
    @inlinable
    mutating func clear() {
      pos = 0
      _size = 0
    }
    @inlinable
    mutating func pop() {
      pos += 1
    }
    deinit {
      payload.deallocate()
    }
  }
}

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

extension _Internal {

  @inlinable
  static func create_buffer(repeating: Int = 0, _ n: Int)
    -> UnsafeMutableBufferPointer<Int>
  {
    let buffer = create_buffer(Int.self, n)
    buffer.initialize(repeating: repeating)
    return buffer
  }

  @inlinable
  static func create_buffer<T>(_ t: T.Type, _ n: Int)
    -> UnsafeMutableBufferPointer<T>
  {
    UnsafeMutableBufferPointer<T>(
      start: .allocate(capacity: n), count: n)
  }
  
  @inlinable
  static func copy_buffer<T>(_ other: UnsafeMutableBufferPointer<T>)
    -> UnsafeMutableBufferPointer<T>
  {
    let b = create_buffer(T.self, other.count)
    _ = b.initialize(from: other)
    return b
  }


  @inlinable
  static func delete_buffer<T>(_ b: UnsafeMutableBufferPointer<T>) {
    b.deinitialize()
    b.deallocate()
  }
}
