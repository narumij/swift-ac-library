extension _Internal {

  @usableFromInline
  struct simple_queue<T>: ~Copyable {
    @inlinable
    init(_ n: Int) {
      self._payload = _Internal.create_buffer(T.self, n)
    }
    @usableFromInline var _payload: UnsafeMutableBufferPointer<T>
    @usableFromInline var _pos = 0
    @usableFromInline var _size = 0
    @inlinable
    mutating func reserve(_ n: Int) {
      _payload.deallocate()
      _payload = _Internal.create_buffer(T.self, n)
    }
    @inlinable
    func size() -> Int { _size - _pos }
    @inlinable
    func empty() -> Bool {
      _size == _pos
    }
    @inlinable
    mutating func push(_ t: T) {
      _payload[_size] = t
      _size += 1
    }
    @inlinable
    func front() -> T {
      _payload[_pos]
    }
    @inlinable
    mutating func clear() {
      _pos = 0
      _size = 0
    }
    @inlinable
    mutating func pop() {
      _pos += 1
    }
    deinit {
      _payload.deallocate()
    }
  }
}
