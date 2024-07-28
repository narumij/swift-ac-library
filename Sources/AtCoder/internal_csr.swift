import Foundation

extension MCFGraph {
  enum _Internal {}
}

extension MCFGraph._Internal {

  @usableFromInline
  struct csr<E> {
    @usableFromInline var start: [Int]
    @usableFromInline var elist: [E?]
    @inlinable
    init(_ n: Int, _ edges: [(Int, E)]) {
      start = [Int](repeating: 0, count: n + 1)
      elist = [E?](repeating: nil, count: edges.count)
      for e in edges {
        start[e.0 + 1] += 1
      }
      for i in stride(from: 1, through: n, by: 1) {
        start[i] += start[i - 1]
      }
      var counter = start
      for e in edges {
        elist[counter[e.0]] = e.1
        counter[e.0] += 1
      }
    }
  }
}

extension _Internal.scc_graph {

  @usableFromInline
  struct csr<E: BinaryInteger> {
    public var start: [Int]
    public var elist: [E]
    @inlinable @inline(__always)
    init(_ n: Int, _ edges: [(first: Int, second: E)]) {
      start = [Int](repeating: 0, count: n + 1)
      elist = [E](repeating: 0, count: edges.count)
      for e in edges {
        start[e.first + 1] += 1
      }
      for i in stride(from: 1, through: n, by: 1) {
        start[i] += start[i - 1]
      }
      var counter = start
      for e in edges {
        elist[counter[e.first]] = e.second
        counter[e.first] += 1
      }
    }
  }
}
