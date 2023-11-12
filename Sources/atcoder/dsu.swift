import Foundation

struct dsu {
    
    init() { _n = 0; parent_or_size = [] }
    init(_ n: Int) { _n = n; parent_or_size = [Int](repeating: -1, count: n) }

    mutating func merge(_ a: Int,_ b: Int) -> Int {
        assert(0 <= a && a < _n);
        assert(0 <= b && b < _n);
        var x = leader(a), y = leader(b);
        if (x == y) { return x; }
        if (-parent_or_size[x] < -parent_or_size[y]) { swap(&x, &y); }
        parent_or_size[x] += parent_or_size[y];
        parent_or_size[y] = x;
        return x;
    }

    mutating func same(_ a: Int,_ b: Int) -> Bool {
        assert(0 <= a && a < _n);
        assert(0 <= b && b < _n);
        return leader(a) == leader(b);
    }

    mutating func leader(_ a: Int) -> Int {
        assert(0 <= a && a < _n);
        if (parent_or_size[a] < 0) { return a; }
        parent_or_size[a] = leader(parent_or_size[a]);
        return parent_or_size[a]
    }

    mutating func size(_ a: Int) -> Int {
        assert(0 <= a && a < _n);
        return -parent_or_size[leader(a)];
    }

    mutating func groups() -> [[Int]] {
        var leader_buf = [Int](repeating: -1, count:_n), group_size = [Int](repeating: -1, count:_n)
//        for (int i = 0; i < _n; i++) {
        for i in 0..<_n {
            leader_buf[i] = leader(i);
            group_size[leader_buf[i]] += 1;
        }
        var result: [[Int]] = [[Int]](repeating: [], count: _n);
//        for (int i = 0; i < _n; i++) {
        for i in 0..<_n {
//            result[i].reserve(group_size[i]);
            result[i].reserveCapacity(group_size[i])
        }
//        for (int i = 0; i < _n; i++) {
        for i in 0..<_n {
            result[leader_buf[i]].append(i);
        }
//        result.erase(
//            std::remove_if(result.begin(), result.end(),
//                           [&](const std::vector<int>& v) { return v.empty(); }),
//            result.end());
        result.removeAll { $0.isEmpty }
        return result;
    }

    private var _n: Int;
    private var parent_or_size: [Int];
};
