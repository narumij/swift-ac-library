extension _Internal {

  // std::vector相当。先頭・使用範囲の終端・確保範囲の終端の3つのポインタだけを持つ。
  // 参照カウントもCOWもなく、push_backは空きがあれば書き込んでポインタを進めるだけ。
  // 伸長はlibc++の__recommendと同じくmax(2 * capacity, new_size)で確保し直して要素を移す。
  // Elementは~Copyableも許すので、_Vector<_Vector<T>>のように入れ子にできる。
  @usableFromInline
  struct _Vector<Element: ~Copyable>: ~Copyable {
    @usableFromInline var _begin: UnsafeMutablePointer<Element>?
    @usableFromInline var _end: UnsafeMutablePointer<Element>?
    @usableFromInline var _cap: UnsafeMutablePointer<Element>?

    @inlinable
    init() {
      _begin = nil
      _end = nil
      _cap = nil
    }

    @inlinable
    init(capacity n: Int) {
      self.init()
      reserve(n)
    }

    @inlinable
    func size() -> Int {
      guard let b = _begin else { return 0 }
      return _end.unsafelyUnwrapped - b
    }

    @inlinable
    func capacity() -> Int {
      guard let b = _begin else { return 0 }
      return _cap.unsafelyUnwrapped - b
    }

    @inlinable
    func empty() -> Bool { _begin == _end }

    @inlinable
    @inline(__always)
    mutating func push_back(_ e: consuming Element) {
      if _end == _cap { _grow(size() &+ 1) }
      let end = _end.unsafelyUnwrapped
      end.initialize(to: e)
      _end = end + 1
    }

    @inlinable
    mutating func pop_back() {
      let end = _end.unsafelyUnwrapped - 1
      end.deinitialize(count: 1)
      _end = end
    }

    @inlinable
    mutating func reserve(_ n: Int) {
      if n > capacity() { _reallocate(n) }
    }

    @inlinable
    mutating func clear() {
      guard let b = _begin else { return }
      b.deinitialize(count: size())
      _end = b
    }

    @inlinable
    subscript(i: Int) -> Element {
      unsafeAddress { UnsafePointer(_begin.unsafelyUnwrapped + i) }
      unsafeMutableAddress { _begin.unsafelyUnwrapped + i }
    }

    // 伸長は稀なので呼出し側へ展開しない。
    @inlinable
    @inline(never)
    mutating func _grow(_ new_size: Int) {
      _reallocate(Swift.max(2 &* capacity(), new_size))
    }

    @inlinable
    mutating func _reallocate(_ n: Int) {
      let count = size()
      let new_begin = UnsafeMutablePointer<Element>.allocate(capacity: n)
      if let b = _begin {
        new_begin.moveInitialize(from: b, count: count)
        b.deallocate()
      }
      _begin = new_begin
      _end = new_begin + count
      _cap = new_begin + n
    }

    deinit {
      if let b = _begin {
        b.deinitialize(count: _end.unsafelyUnwrapped - b)
        b.deallocate()
      }
    }
  }
}

extension _Internal._Vector where Element: Copyable {

  // std::vectorのコピーコンストラクタ相当。要素ごと新しい領域へ複製する。
  @inlinable
  init(copying other: borrowing Self) {
    self.init()
    let n = other.size()
    guard n > 0 else { return }
    _reallocate(n)
    _begin.unsafelyUnwrapped.initialize(from: other._begin.unsafelyUnwrapped, count: n)
    _end = _begin.unsafelyUnwrapped + n
  }

  @inlinable
  func clone() -> Self {
    return .init(copying: self)
  }
}

extension _Internal._Vector {

  @inlinable
  func unsafeMutableBufferPointer() -> UnsafeMutableBufferPointer<Element> {
    guard let _begin, let _end else {
      return .init(start: nil, count: 0)
    }
    return .init(start: _begin, count: _end - _begin)
  }

  @inlinable
  func unsafeBufferPointer() -> UnsafeBufferPointer<Element> {
    guard let _begin, let _end else {
      return .init(start: nil, count: 0)
    }
    return .init(start: _begin, count: _end - _begin)
  }
}

#if compiler(>=6.4)
  @available(anyAppleOS 27.0, *)
  extension _Internal._Vector where Element: ~Copyable {

    @inlinable
    var span: Span<Element> {
      @_lifetime(borrow self)
      borrowing get {
        let span = Span(_unsafeElements: UnsafeBufferPointer(start: _begin, count: size()))
        return _overrideLifetime(span, borrowing: self)
      }
    }
  }

  // Swift 6.4以降は借用イテレーションでfor-inに対応する。要素が~Copyableでも使える。
  @available(anyAppleOS 27.0, *)
  extension _Internal._Vector: Iterable where Element: ~Copyable {

    @usableFromInline
    typealias BorrowingIterator = Span<Element>.BorrowingIterator

    @inlinable
    var underestimatedCount: Int { size() }

    @inlinable
    @_lifetime(borrow self)
    func makeBorrowingIterator() -> BorrowingIterator {
      Span.BorrowingIterator(span)
    }
  }
#endif
