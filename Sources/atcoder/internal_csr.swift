import Foundation

protocol Zero {
    static var zero: Self { get }
}

extension _internal {
    
    struct csr<E: Zero> {
        var start: [Int];
        var elist: [E];
        init(_ n: Int,_ edges: [(first: Int, second: E)]) {
            start = [Int](repeating: 0, count:n + 1)
            elist = [E](repeating: .zero, count: edges.count)
            //            for (auto e : edges) {
            for e in edges {
                start[e.first + 1] += 1;
            }
            //            for (int i = 1; i <= n; i++) {
            for i in 1..<=n {
                start[i] += start[i - 1];
            }
            var counter = start;
            //            for (auto e : edges) {
            for e in edges {
                elist[counter[e.first]] = e.second;
                counter[e.first] += 1
            }
        }
    };
}

