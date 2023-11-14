import Foundation

#if true
// Reference: https://en.wikipedia.org/wiki/Fenwick_tree
public struct fenwick_tree<T: Numeric & ToUnsigned> where T: ToUnsigned {
//    using U = internal::to_unsigned_t<T>;
    typealias U = T.Unsigned

//  public:
    init() { _n = 0; data = [] }
    init<Index: FixedWidthInteger>(_ n: Index) { _n = Int(n); data = [U](repeating: 0, count: Int(n)) }

    mutating func add<I: FixedWidthInteger>(_ p: I,_ x: T) {
        var p = Int(p)
        assert(0 <= p && p < _n);
        p += 1;
        while (p <= _n) {
            data[p - 1] &+= x.unsigned;
            p += p & -p;
        }
    }

    func sum<Index: FixedWidthInteger>(_ l: Index,_ r: Index) -> T {
        assert(0 <= l && l <= r && r <= _n);
        let value: T.Unsigned = sum(r) &- sum(l)
        return T(unsigned: value);
    }

//  private:
    var _n: Int;
    var data: [U];

    func sum<Index: FixedWidthInteger>(_ r: Index) -> U {
        var r = Int(r)
        var s: U = 0;
        while (r > 0) {
            s &+= data[r - 1];
            r -= r & -r;
        }
        return s;
    }
};
#else
public struct fenwick_tree<T: Numeric & Unsigned> where T: Unsigned {
    @usableFromInline typealias U = T.Unsigned
    init() { _n = 0; data = [] }
    init<Index: FixedWidthInteger>(_ n: Index) { _n = Int(n); data = .init(repeating: 0, count: Int(n)) }

    mutating func add<I: FixedWidthInteger>(_ p: I,_ x: T) {
        _update{ $0.add(Int(p),x) }
    }

    mutating func sum<Index: FixedWidthInteger>(_ l: Index,_ r: Index) -> T {
        _update{ $0.sum(l,r) }
    }

    @usableFromInline var _n: Int
    @usableFromInline var data: ContiguousArray<U>
};

extension fenwick_tree {
    
    @usableFromInline
    struct _UnsafeHandle<U: FixedWidthInteger> where T.Unsigned == U {
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
                data[p - 1] &+= x.unsigned;
                p += p & -p;
            }
        }

        @inlinable @inline(__always)
        func sum<Index: FixedWidthInteger>(_ l: Index,_ r: Index) -> T {
            assert(0 <= l && l <= r && r <= _n);
            return T(unsigned: sum(r) &- sum(l));
        }

        @inlinable @inline(__always)
        func sum<Index: FixedWidthInteger>(_ r: Index) -> U {
            var r = Int(r)
            var s: U = 0;
            while (r > 0) {
                s &+= data[r - 1];
                r -= r & -r;
            }
            return s;
        }
    }
    
    @inlinable @inline(__always)
    mutating func _update<R>(_ body: (_UnsafeHandle<U>) -> R) -> R {
        data.withUnsafeMutableBufferPointer { data in
            body(_UnsafeHandle<U>(_n: _n, data: data))
        }
    }
}
#endif
