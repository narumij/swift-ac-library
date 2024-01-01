import Foundation

extension _Internal {
    
    struct csr<E> {
        var start: [Int]
        var elist: [E?]
        init(_ n: Int,_ edges: [(Int, E)]) {
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
