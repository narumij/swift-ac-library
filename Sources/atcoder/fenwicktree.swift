import Foundation

// Reference: https://en.wikipedia.org/wiki/Fenwick_tree
struct fenwick_tree<T: FixedWidthInteger> {
    typealias U = T.Magnitude

    init() { _n = 0; data = [] }
    init(_ n: Int) { _n = n; data = .init(repeating: 0, count: n) }

    mutating func add(_ p: Int,_ x: T) {
        _update{ $0.add(p,x) }
    }

    mutating func sum(_ l: Int,_ r: Int) -> T {
        _update{ $0.sum(l,r) }
    }

    @usableFromInline var _n: Int
    @usableFromInline var data: ContiguousArray<U>
};

extension fenwick_tree {
    
    struct _UnsafeHandle {
        @usableFromInline @inline(__always)
        internal init(_n: Int, data: UnsafeMutableBufferPointer<fenwick_tree<T>.U>) {
            self._n = _n
            self.data = data
        }
        
        @usableFromInline let _n: Int
        @usableFromInline let data: UnsafeMutableBufferPointer<U>
        
        @inlinable @inline(__always)
        func add(_ p: Int,_ x: T) {
            var p = p
            assert(0 <= p && p < _n);
            p += 1;
            while (p <= _n) {
                data[p - 1] += U(x);
                p += p & -p;
            }
        }

        @inlinable @inline(__always)
        func sum(_ l: Int,_ r: Int) -> T {
            assert(0 <= l && l <= r && r <= _n);
            return T(sum(r) - sum(l));
        }

        @inlinable @inline(__always)
        func sum(_ r: Int) -> U {
            var r = r
            var s: U = 0;
            while (r > 0) {
                s += data[r - 1];
                r -= r & -r;
            }
            return s;
        }
    }
    
    @inlinable @inline(__always)
    mutating func _update<R>(_ body: (_UnsafeHandle) -> R) -> R {
        data.withUnsafeMutableBufferPointer { data in
            body(_UnsafeHandle(_n: _n, data: data))
        }
    }
}
