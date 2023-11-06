import Foundation
@testable import atcoder

// from https://github.com/atcoder/ac-library/blob/master/test/unittest/segtree_test.cpp
struct segtree_naive<T: SegtreeParameter> {
    typealias S = T.S
    var op: (S,S) -> S { T.op }
    var e: () -> S { T.e }
    
    var n: Int
    var d: [S]
    init() { self.init(0) }
    init(_ _n: Int) {
        n = _n
        d = [S](repeating: T.e(), count: n)
    }
    mutating func set(_ p: Int,_ x: S) { d[p] = x; }
    func get(_ p: Int) -> S { return d[p]; }
    func prod(_ l: Int,_ r: Int) -> S {
        var sum: S = e();
        // for (int i = l; i < r; i++) {
        for i in l..<r {
            sum = op(sum, d[i]);
        }
        return sum;
    }
    func all_prod() -> S { return prod(0, n); }

    func max_right(_ l: Int,_ f: (S) -> Bool) -> Int {
        var sum: S = e();
        assert(f(sum));
        // for (int i = l; i < n; i++) {
        for i in l..<n {
            sum = op(sum, d[i]);
            if (!f(sum)) { return i; }
        }
        return n;
    }

    func min_left(_ r: Int,_ f: (S) -> Bool) -> Int {
        var sum: S = e();
        assert(f(sum));
        // for (int i = r - 1; i >= 0; i--) {
        for i in (r - 1)..>=0 {
            sum = op(d[i], sum);
            if (!f(sum)) { return i + 1; }
        }
        return 0;
    }
}
