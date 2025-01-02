import Foundation

extension _Internal {

  public struct csr<E> {

    @usableFromInline
    var start: [Int]

    @usableFromInline
    var elist: [E]

    @inlinable
    @inline(__always)
    init(_ n: Int, _ edges: [(first: Int, second: E)]) {
      var start = [Int](repeating: 0, count: n + 1)
      let elist = [E](unsafeUninitializedCapacity: edges.count) { elist, elistCount in
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
        elistCount = edges.count
      }
      self.start = start
      self.elist = elist
    }
  }
}
