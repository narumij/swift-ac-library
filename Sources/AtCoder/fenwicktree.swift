import Foundation

public struct fenwick_tree<T: AdditiveArithmetic & ToUnsigned> where T: ToUnsigned {
    @usableFromInline var _n: Int
    @usableFromInline var data: [U]
}

public extension fenwick_tree {

    typealias U = T.Unsigned
    init() { _n = 0; data = [] }
    init<Index: FixedWidthInteger>(_ n: Index) { _n = Int(n); data = .init(repeating: 0, count: Int(n)) }

    mutating func add<Index: FixedWidthInteger>(_ p: Index,_ x: T) {
        _update{ $0.add(Int(p),x) }
    }

    mutating func sum<Index: FixedWidthInteger>(_ l: Index,_ r: Index) -> T {
        _update{ $0.sum(Int(l),Int(r)) }
    }
}

extension fenwick_tree {
    
    @usableFromInline
    struct _UnsafeHandle<U: FixedWidthInteger & UnsignedInteger> where T.Unsigned == U {
        @usableFromInline @inline(__always)
        internal init(_n: Int, data: UnsafeMutablePointer<fenwick_tree<T>.U>) {
            self._n = _n
            self.data = data
        }
        
        @usableFromInline let _n: Int
        @usableFromInline let data: UnsafeMutablePointer<U>
        
        @inlinable @inline(__always)
        func add(_ p: Int,_ x: T) {
            var p = p
            assert(0 <= p && p < _n)
            p += 1
            while (p <= _n) {
                data[p - 1] &+= x.unsigned
                p += p & -p
            }
        }

        @inlinable @inline(__always)
        func sum(_ l: Int,_ r: Int) -> T {
            assert(0 <= l && l <= r && r <= _n)
            return T(unsigned: sum(r) &- sum(l))
        }

        @inlinable @inline(__always)
        func sum(_ r: Int) -> U {
            var r = r
            var s: U = 0
            while (r > 0) {
                s &+= data[r - 1]
                r -= r & -r
            }
            return s
        }
    }
    
    @inlinable @inline(__always)
    mutating func _update<R>(_ body: (_UnsafeHandle<U>) -> R) -> R {
        data.withUnsafeMutableBufferPointer { data in
            body(_UnsafeHandle<U>(_n: _n, data: data.baseAddress!))
        }
    }
}
