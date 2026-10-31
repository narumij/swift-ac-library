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
    init(_ n: Int, _ edges: [CSREdge<E>]) {

      let start = UnsafeMutablePointer<Int>.allocate(capacity: n + 1)
      let elist = UnsafeMutablePointer<E>.allocate(capacity: edges.count)
      start.initialize(repeating: 0, count: n + 1)

      withUnsafeTemporaryAllocation(of: Int.self, capacity: n + 1) { counter in
        let counter = counter.baseAddress!

        for e in edges {
          start[e.first + 1] += 1
        }
        for i in stride(from: 1, through: n, by: 1) {
          start[i] += start[i - 1]
        }
        counter.initialize(from: start, count: n + 1)
        for e in edges {
          (elist + counter[e.first]).initialize(to: e.second)
          counter[e.first] += 1
        }
        counter.deinitialize(count: n + 1)
      }

      self.start = .init(start: start, count: n + 1)
      self.elist = .init(start: elist, count: edges.count)
    }

    deinit {
      start.deinitialize()
      start.deallocate()
      elist.deinitialize()
      elist.deallocate()
    }
  }
}
