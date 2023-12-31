import Foundation

extension _Internal {
    
    struct csr<E> {
        var start: [Int];
        var elist: [E?];
        init(_ n: Int,_ edges: [(first: Int, second: E)]) {
            start = [Int](repeating: 0, count: n + 1)
            elist = [E?](repeating: nil, count: edges.count)
            for e in edges {
                start[e.first + 1] += 1
            }
            for i in 1..<=n {
                start[i] += start[i - 1];
            }
            var counter = start
            for e in edges {
                elist[counter[e.first]] = e.second
                counter[e.first] += 1
            }
        }
    }
}

