import Foundation

public struct dsu {
    init() { _n = 0; parent_or_size = [] }
    init(_ n: Int) { _n = n; parent_or_size = .init(repeating: -1, count: n) }
    @usableFromInline var _n: Int;
    @usableFromInline var parent_or_size: ContiguousArray<Int>;
};

extension dsu {
    
    @usableFromInline
    struct _UnsafeHandle {
        @inlinable @inline(__always)
        internal init(_n: Int, parent_or_size: UnsafeMutableBufferPointer<Int>) {
            self._n = _n
            self.parent_or_size = parent_or_size
        }
        @usableFromInline let _n: Int;
        @usableFromInline let parent_or_size: UnsafeMutableBufferPointer<Int>
    }
    
    @inlinable @inline(__always)
    mutating func _update<R>(_ body: (_UnsafeHandle) -> R) -> R {
        parent_or_size.withUnsafeMutableBufferPointer { parent_or_size in
            body(_UnsafeHandle(_n: _n, parent_or_size: parent_or_size))
        }
    }
}

extension dsu._UnsafeHandle {
    
    @inlinable @inline(__always)
    func merge(_ a: Int,_ b: Int) -> Int {
        assert(0 <= a && a < _n);
        assert(0 <= b && b < _n);
        var x = leader(a), y = leader(b);
        if (x == y) { return x; }
        if (-parent_or_size[x] < -parent_or_size[y]) { swap(&x, &y); }
        parent_or_size[x] += parent_or_size[y];
        parent_or_size[y] = x;
        return x;
    }

    @inlinable @inline(__always)
    func same(_ a: Int,_ b: Int) -> Bool {
        assert(0 <= a && a < _n);
        assert(0 <= b && b < _n);
        return leader(a) == leader(b);
    }

    @inlinable @inline(__always)
    func leader(_ a: Int) -> Int {
        assert(0 <= a && a < _n);
        if (parent_or_size[a] < 0) { return a; }
        parent_or_size[a] = leader(parent_or_size[a]);
        return parent_or_size[a]
    }

    @inlinable @inline(__always)
    func size(_ a: Int) -> Int {
        assert(0 <= a && a < _n);
        return -parent_or_size[leader(a)];
    }

    @inlinable @inline(__always)
    func groups() -> [[Int]] {
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
}

extension dsu {
    
    mutating func merge(_ a: Int,_ b: Int) -> Int {
        _update { $0.merge(a, b) }
    }

    mutating func same(_ a: Int,_ b: Int) -> Bool {
        _update { $0.same(a, b) }
    }

    mutating func leader(_ a: Int) -> Int {
        _update { $0.leader(a) }
    }

    mutating func size(_ a: Int) -> Int {
        _update { $0.size(a) }
    }

    mutating func groups() -> [[Int]] {
        _update { $0.groups() }
    }
}

