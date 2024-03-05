import Foundation

public struct SegTree<S> {
    @usableFromInline let op: (S,S) -> S
    @usableFromInline let e: () -> S
    @usableFromInline let _n, size, log: Int
    @usableFromInline var d: [S]
    
    public typealias S = S
    public typealias Op = (S,S) -> S
    public typealias E = () -> S
}

public extension SegTree {
    
    @inlinable
    init(op: @escaping (S,S) -> S,
         e: @autoclosure @escaping () -> S)
    {
        self.init(op: op, e: e(), count: 0 )
    }
    
    @inlinable
    init(op: @escaping (S,S) -> S,
         e: @autoclosure @escaping () -> S,
         count n: Int)
    {
        self.init(op: op, e: e(), [S](repeating: e(), count: n) )
    }
    
    @inlinable
    init<V>(op: @escaping (S,S) -> S,
         e: @autoclosure @escaping () -> S,
         _ v: V)
    where V: Collection, V.Element == S, V.Index == Int
    {
        self.op = op
        self.e = e
        _n = v.count
        size = _Internal.bit_ceil(UInt64(_n))
        log = _Internal.countr_zero(UInt64(size))
        // d = [S](repeating: e(), count: 2 * size)
        // for (int i = 0; i < _n; i++) d[size + i] = v[i];
        // for i in 0..<_n { d[size + i] = v[i] }
        // for (int i = size - 1; i >= 1; i--) {
        let (__size,__n) = (size, _n)
        d = [S](unsafeUninitializedCapacity: 2 * __size) { buffer, initializedCount in
            for i in 0 ..< (2 * __size) {
                if __size <= i, i < __size + __n {
                    // for (int i = 0; i < _n; i++) d[size + i] = v[i];
                    buffer.initializeElement(at: i, to: v[i - __size])
                } else {
                    buffer.initializeElement(at: i, to: e())
                }
            }
            initializedCount = 2 * __size
        }
        __update { unsafeHandle in
            // for (int i = size - 1; i >= 1; i--) {
            for i in stride(from: __size - 1, through: 1, by: -1) {
                unsafeHandle.update(i)
            }
        }
    }
}

extension SegTree {
    
    @usableFromInline
    struct _UnsafeHandle {
        
        @inlinable @inline(__always)
        init(
            op: @escaping (S, S) -> S,
            e: @escaping () -> S,
            _n: Int,
            size: Int,
            log: Int,
            d: UnsafeMutablePointer<S>
        ) {
            self.op = op
            self.e = e
            
            self._n = _n
            self.size = size
            self.log = log
            self.d = d
        }

        @usableFromInline let op: (S,S) -> S
        @usableFromInline let e: () -> S

        @usableFromInline let _n, size, log: Int
        @usableFromInline let d: UnsafeMutablePointer<S>
    }
}

extension SegTree._UnsafeHandle {
    
    @inlinable
    func set(_ p: Int,_ x: S) {
        assert(0 <= p && p < _n)
        let p = p + size
        d[p] = x
        // for (int i = 1; i <= log; i++) update(p >> i);
        for i in stride(from: 1, through: log, by: 1) { update(p >> i) }
    }
    
    @inlinable
    func get(_ p: Int) -> S {
        assert(0 <= p && p < _n)
        return d[p + size]
    }
    
    @inlinable
    func prod(_ l: Int,_ r: Int) -> S {
        assert(0 <= l && l <= r && r <= _n)
        var sml: S = e(), smr: S = e()
        var (l,r) = (l + size, r + size)
        while l < r {
            if l & 1 != 0 { sml = op(sml, d[l]); l += 1 }
            if r & 1 != 0 { r -= 1; smr = op(d[r], smr) }
            l >>= 1
            r >>= 1
        }
        return op(sml, smr)
    }
    
    @inlinable
    func all_prod() -> S { return d[1] }
    
    @inlinable
    func max_right(_ l: Int,_ f: (S) -> Bool) -> Int {
        assert(0 <= l && l <= _n)
        assert(f(e()))
        if l == _n { return _n }
        var l = l + size
        var sm: S = e()
        repeat {
            while l % 2 == 0 { l >>= 1 }
            if !f(op(sm, d[l])) {
                while l < size {
                    l = 2 * l
                    if f(op(sm, d[l])) {
                        sm = op(sm, d[l])
                        l += 1
                    }
                }
                return l - size
            }
            sm = op(sm, d[l])
            l += 1
        } while l & -l != l
        return _n
    }
    
    @inlinable
    func min_left(_ r: Int,_ f: (S) -> Bool ) -> Int {
        assert(0 <= r && r <= _n)
        assert(f(e()))
        if r == 0 { return 0 }
        var r = r + size
        var sm: S = e()
        repeat {
            r -= 1
            while r > 1, r % 2 != 0 { r >>= 1 }
            if !f(op(d[r], sm)) {
                while r < size {
                    r = (2 * r + 1)
                    if f(op(d[r], sm)) {
                        sm = op(d[r], sm)
                        r -= 1
                    }
                }
                return r + 1 - size
            }
            sm = op(d[r], sm)
        } while r & -r != r
        return 0
    }
    
    @inlinable
    func update(_ k: Int) {
        d[k] = op(d[k << 1], d[(k << 1) + 1])
    }
}

extension SegTree {
    
    @inlinable @inline(__always)
    mutating func __update<R>(_ body: (_UnsafeHandle) -> R) -> R {
        let handle = _UnsafeHandle(op: op, e: e, _n: _n, size: size, log: log, d: &d)
        return body(handle)
    }
}

public extension SegTree {
    
    mutating func set(_ p: Int,_ x: S) {
        __update{ $0.set(p,x) }
    }
    mutating func get(_ p: Int) -> S {
        __update{ $0.get(p) }
    }
    mutating func prod(_ l: Int,_ r: Int) -> S {
        __update{ $0.prod(l, r) }
    }
    mutating func all_prod() -> S {
        __update{ $0.all_prod() }
    }
    mutating func max_right(_ l: Int,_ g: (S) -> Bool) -> Int {
        __update{ $0.max_right(l, g) }
    }
    mutating func min_left(_ r: Int,_ g: (S) -> Bool) -> Int {
        __update{ $0.min_left(r, g) }
    }
}
