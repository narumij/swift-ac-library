import Foundation

public struct FenwickTree<T: AdditiveArithmetic & HandleUnsigned> where T: HandleUnsigned {
    @usableFromInline var _n: Int
    @usableFromInline var data: [U]
}

public extension FenwickTree {

    typealias U = T.Unsigned
    init() { _n = 0; data = [] }
    init(_ n: Int) { _n = n; data = [U](repeating: 0, count: n) }
}

extension FenwickTree {
    
    @usableFromInline
    struct _UnsafeHandle {
        @inlinable @inline(__always)
        init(_n: Int, data: UnsafeMutablePointer<U>) {
            self._n = _n
            self.data = data
        }
        public let _n: Int
        public let data: UnsafeMutablePointer<U>
        public typealias U = T.Unsigned
    }
}

extension FenwickTree._UnsafeHandle {
    
    func add(_ p: Int,_ x: T) {
        var p = p
        assert(0 <= p && p < _n)
        p += 1
        while p <= _n {
            data[p - 1] &+= x.unsigned
            p += p & -p
        }
    }

    func sum(_ l: Int,_ r: Int) -> T {
        assert(0 <= l && l <= r && r <= _n)
        return T(unsigned: sum(r) &- sum(l))
    }

    func sum(_ r: Int) -> U {
        var r = r
        var s: U = 0
        while r > 0 {
            s &+= data[r - 1]
            r -= r & -r
        }
        return s
    }
}

extension FenwickTree {
    
    @inlinable @inline(__always)
    mutating func _update<R>(_ body: (_UnsafeHandle) -> R) -> R {
        body(_UnsafeHandle(_n: _n, data: &data))
    }
}

public extension FenwickTree {

    mutating func add(_ p: Int,_ x: T) {
        _update{ $0.add(p,x) }
    }
    mutating func sum(_ l: Int,_ r: Int) -> T {
        _update{ $0.sum(l,r) }
    }
}

extension FenwickTree {
    mutating func sum(_ l: Int) -> U {
        _update{ $0.sum(l) }
    }
}
