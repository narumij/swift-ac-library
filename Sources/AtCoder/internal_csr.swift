import Foundation

extension _Internal {

  @frozen
  public struct csr<E> {

    @usableFromInline
    var start: [Int]

    @usableFromInline
    var elist: [E]

    @inlinable
    @inline(never)
    init(_ n: Int, _ edges: [(first: Int, second: E)]) {
      
      (start, elist) = edges.withUnsafeBufferPointer { edges in

        let start = [Int](unsafeUninitializedCapacity: n + 1) { start, startCount in
          start.baseAddress?.initialize(repeating: 0, count: n + 1)
          for e in edges {
            start[e.first + 1] += 1
          }
          for i in stride(from: 1, through: n, by: 1) {
            start[i] += start[i - 1]
          }
          startCount = n + 1
        }

        let elist = [E](unsafeUninitializedCapacity: edges.count) { elist, elistCount in
          withUnsafeTemporaryAllocation(of: Int.self, capacity: n + 1) { counter in
            start.withUnsafeBufferPointer { start in
              counter.baseAddress?.initialize(from: start.baseAddress!, count: n + 1)
            }
            for e in edges {
              elist[counter[e.first]] = e.second
              counter[e.first] += 1
            }
          }
          elistCount = edges.count
        }

        return (start, elist)
      }
    }
  }
}
