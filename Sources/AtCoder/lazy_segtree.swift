import Foundation

public struct LazySegTree<S,F> {
    @usableFromInline let _op: (S,S) -> S
    @usableFromInline let _e: S
    @usableFromInline let _mapping: (F,S) -> S
    @usableFromInline let _composition: (F,F) -> F
    @usableFromInline let _id: F

    @usableFromInline let _n, _size, _log: Int
    @usableFromInline var d: [S]
    @usableFromInline var lz: [F]
}

public extension LazySegTree {
    typealias S = S
    typealias Op = (S,S) -> S
    typealias F = F
    typealias Mapping = (F,S) -> S
    typealias Composition = (F,F) -> F
}

public extension LazySegTree {
    
    @inlinable
    init(op: @escaping (S, S) -> S,
         e: S,
         mapping: @escaping (F, S) -> S,
         composition: @escaping (F, F) -> F,
         id: F)
    {
        self.init(op: op,
                  e: e,
                  mapping: mapping,
                  composition: composition,
                  id: id,
                  count: 0)
    }
    
    @inlinable
    init(op: @escaping (S, S) -> S,
         e: S,
         mapping: @escaping (F, S) -> S,
         composition: @escaping (F, F) -> F,
         id: F,
         count n: Int)
    {
        self.init(op: op,
                  e: e,
                  mapping: mapping,
                  composition: composition,
                  id: id,
                  [S](repeating: e, count: n))
    }
    
    @inlinable
    init<V>(op: @escaping (S, S) -> S,
         e: S,
         mapping: @escaping (F, S) -> S,
         composition: @escaping (F, F) -> F,
         id: F,
         _ v: V)
    where V: Collection, V.Element == S, V.Index == Int
    {
        _op = op
        _e = e
        _mapping = mapping
        _composition = composition
        _id = id
        
        _n = v.count
        _size = _Internal.bit_ceil(UInt64(_n))
        _log = _Internal.countr_zero(UInt64(_size))
        let (__size,__n) = (_size, _n)
        d = [S](unsafeUninitializedCapacity: 2 * __size) { buffer, initializedCount in
            for i in 0 ..< (2 * __size) {
                if __size <= i, i < __size + __n {
                    // for (int i = 0; i < _n; i++) d[size + i] = v[i];
                    buffer.initializeElement(at: i, to: v[i - __size])
                } else {
                    buffer.initializeElement(at: i, to: e)
                }
            }
            initializedCount = 2 * __size
        }
        lz = [F](unsafeUninitializedCapacity: __size) { buffer, initializedCount in
            for i in 0 ..< __size {
                buffer.initializeElement(at: i, to: id)
            }
            initializedCount = __size
        }
        __update { unsafeHandle in
            // for (int i = size - 1; i >= 1; i--) {
            for i in stride(from: __size - 1, through: 1, by: -1) {
                unsafeHandle.update(i)
            }
        }
    }
}

extension LazySegTree {
    
    @usableFromInline
    struct _UnsafeHandle {
        
        @inlinable @inline(__always)
        init(
            op: @escaping (S, S) -> S,
            e: @escaping () -> S,
            mapping: @escaping (F, S) -> S,
            composition: @escaping (F, F) -> F,
            id: @escaping () -> F,
            _n: Int,
            size: Int,
            log: Int,
            d: UnsafeMutablePointer<S>,
            lz: UnsafeMutablePointer<F>
        ) {
            self.op = op
            self.e = e
            self.mapping = mapping
            self.composition = composition
            self.id = id
            
            self._n = _n
            self.size = size
            self.log = log
            self.d = d
            self.lz = lz
        }

        @usableFromInline let op: (S,S) -> S
        @usableFromInline let e: () -> S
        @usableFromInline let mapping: (F,S) -> S
        @usableFromInline let composition: (F,F) -> F
        @usableFromInline let id: () -> F

        @usableFromInline let _n, size, log: Int
        @usableFromInline let d: UnsafeMutablePointer<S>
        @usableFromInline let lz: UnsafeMutablePointer<F>
    }
}

extension LazySegTree._UnsafeHandle {
    
    @inlinable
    func set(_ p: Int,_ x: S) {
        var p = p
        assert(0 <= p && p < _n)
        p += size
        for i in stride(from: log, through: 1, by: -1) { push(p >> i) }
        d[p] = x
        for i in stride(from: 1, through: log, by: 1) { update(p >> i) }
    }
    
    @inlinable
    func get(_ p: Int) -> S {
        var p = p
        assert(0 <= p && p < _n)
        p += size
        for i in stride(from: log, through: 1, by: -1) { push(p >> i) }
        return d[p]
    }
    
    @inlinable
    func prod(_ l: Int,_ r: Int) -> S{
        assert(0 <= l && l <= r && r <= _n)
        if l == r { return e() }
        var (l, r) = (l + size, r + size)
        
        for i in stride(from: log, through: 1, by: -1) {
            if (l >> i) << i != l { push(l >> i) }
            if (r >> i) << i != r { push((r - 1) >> i) }
        }
        
        var sml = e(), smr = e()
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
    func apply(_ p: Int,_ f: F) {
        var p = p
        assert(0 <= p && p < _n)
        p += size
        for i in stride(from: log, through: 1, by: -1) { push(p >> i) }
        d[p] = mapping(f, d[p])
        for i in stride(from: 1, through: log, by: 1) { update(p >> i) }
    }

    @inlinable
    func apply(_ l: Int,_ r: Int,_ f: F) {
        var l = l
        var r = r
        assert(0 <= l && l <= r && r <= _n)
        if l == r { return }

        l += size
        r += size

        for i in stride(from: log, through: 1, by: -1) {
            if (l >> i) << i != l { push(l >> i) }
            if (r >> i) << i != r { push((r - 1) >> i) }
        }

        do {
            let l2 = l, r2 = r
            while l < r {
                if l & 1 != 0 { all_apply(l, f); l += 1 }
                if r & 1 != 0 { r -= 1; all_apply(r, f) }
                l >>= 1
                r >>= 1
            }
            l = l2
            r = r2
        }

        for i in stride(from: 1, through: log, by: 1) {
            if (l >> i) << i != l { update(l >> i) }
            if (r >> i) << i != r { update((r - 1) >> i) }
        }
    }

    @inlinable
    func max_right(_ l: Int,_ g: (S) -> Bool) -> Int {
        var l = l
        assert(0 <= l && l <= _n)
        assert(g(e()))
        if l == _n { return _n }
        l += size
        for i in stride(from: log, through: 1, by: -1) { push(l >> i) }
        var sm = e()
        repeat {
            while l % 2 == 0 { l >>= 1 }
            if !g(op(sm, d[l])) {
                while l < size {
                    push(l)
                    l = (2 * l)
                    if g(op(sm, d[l])) {
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
    func min_left(_ r: Int,_ g: (S) -> Bool) -> Int {
        var r = r
        assert(0 <= r && r <= _n)
        assert(g(e()))
        if r == 0 { return 0 }
        r += size
        for i in stride(from: log, through: 1, by: -1) { push((r - 1) >> i) }
        var sm = e()
        repeat {
            r -= 1
            while r > 1, r % 2 != 0 { r >>= 1 }
            if !g(op(d[r], sm)) {
                while r < size {
                    push(r)
                    r = (2 * r + 1)
                    if g(op(d[r], sm)) {
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
    
    @inlinable @inline(__always)
    func update(_ k: Int) { d[k] = op(d[2 * k], d[2 * k + 1]) }
    
    @inlinable
    func all_apply(_ k: Int,_ f: F) {
        d[k] = mapping(f, d[k])
        if k < size { lz[k] = composition(f, lz[k]) }
    }
    
    @inlinable
    func push(_ k: Int) {
        all_apply(2 * k, lz[k])
        all_apply(2 * k + 1, lz[k])
        lz[k] = id()
    }
}

extension LazySegTree {
    @inlinable @inline(__always)
    mutating func __update<R>(_ body: (_UnsafeHandle) -> R) -> R {
        withoutActuallyEscaping({ _e }) { _e in
            withoutActuallyEscaping({ _id }) { _id in
                let handle = _UnsafeHandle(
                    op: _op, e: _e,
                    mapping: _mapping, composition: _composition, id: _id,
                    _n: _n, size: _size, log: _log, d: &d, lz: &lz)
                return body(handle)

            }
        }
    }
}

public extension LazySegTree {
    @inlinable
    mutating func set(_ p: Int,_ x: S) {
        __update{ $0.set(p,x) }
    }
    @inlinable
    mutating func get(_ p: Int) -> S {
        __update{ $0.get(p) }
    }
    @inlinable
    mutating func prod(_ l: Int,_ r: Int) -> S {
        __update{ $0.prod(l, r) }
    }
    @inlinable
    mutating func all_prod() -> S {
        __update{ $0.all_prod() }
    }
    @inlinable
    mutating func apply(_ p: Int,_ f: F) {
        __update{ $0.apply(p, f) }
    }
    @inlinable
    mutating func apply(_ l: Int,_ r: Int,_ f: F) {
        __update{ $0.apply(l, r, f) }
    }
    @inlinable
    mutating func max_right(_ l: Int,_ g: (S) -> Bool) -> Int {
        __update{ $0.max_right(l, g) }
    }
    @inlinable
    mutating func min_left(_ r: Int,_ g: (S) -> Bool) -> Int {
        __update{ $0.min_left(r, g) }
    }
}

