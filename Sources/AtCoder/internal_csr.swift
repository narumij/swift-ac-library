extension _Internal {

  // CSRへ渡す辺の共通型。タプルのラベル差による配列全体の動的キャストを避ける。
  @usableFromInline
  struct CSREdge<E> {
    @usableFromInline var first: Int
    @usableFromInline var second: E
    @inlinable init(_ first: Int, _ second: E) {
      self.first = first
      self.second = second
    }
  }

  @frozen
  public struct csr<E>: ~Copyable {

    @usableFromInline
    let start: UnsafeMutableBufferPointer<Int>

    @usableFromInline
    let elist: UnsafeMutableBufferPointer<E>

    @inlinable
    @inline(__always)
    init<C>(_ n: Int, _ edges: C) where C: Collection, C.Element == CSREdge<E> {

      let start = _Internal.create_buffer(n &+ 1)
      let elist = _Internal.create_buffer(E.self, edges.count)

      for e in edges {
        start[e.first &+ 1] &+= 1
      }

      do {
        var i = 1
        while i <= n {
          defer { i &+= 1 }
          start[i] &+= start[i &- 1]
        }
      }

      let counter = _Internal.copy_buffer(start)

      do {
        let counter = counter.baseAddress!
        for e in edges {
          elist.initializeElement(at: counter[e.first], to: e.second)
          counter[e.first] &+= 1
        }
      }

      _Internal.delete_buffer(counter)

      self.start = start
      self.elist = elist
    }

    deinit {
      _Internal.delete_buffer(start)
      _Internal.delete_buffer(elist)
    }
  }
}
