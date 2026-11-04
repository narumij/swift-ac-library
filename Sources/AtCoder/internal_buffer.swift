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
