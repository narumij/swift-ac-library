import Foundation

public struct lazy_segtree<S,F> {
    @usableFromInline let op: (S,S) -> S
    @usableFromInline let _e: S
    @usableFromInline let mapping: (F,S) -> S
    @usableFromInline let composition: (F,F) -> F
    @usableFromInline let _id: F

    @usableFromInline let _n, size, log: Int;
    @usableFromInline var d: [S];
    @usableFromInline var lz: [F];
}

public extension lazy_segtree {
    
    init(op: @escaping (S, S) -> S, e: S, mapping: @escaping (F, S) -> S, composition: @escaping (F, F) -> F, id: F) {
        self.init(op: op, e: e, mapping: mapping, composition: composition, id: id, 0)
    }
    init(op: @escaping (S, S) -> S, e: S, mapping: @escaping (F, S) -> S, composition: @escaping (F, F) -> F, id: F,_ n: Int) {
        self.init(op: op, e: e, mapping: mapping, composition: composition, id: id, [S](repeating: e, count: n))
    }
    init(op: @escaping (S, S) -> S, e: S, mapping: @escaping (F, S) -> S, composition: @escaping (F, F) -> F, id: F,_ v: [S]) {
        self.op = op
        _e = e
        self.mapping = mapping
        self.composition = composition
        _id = id
        
        _n = v.count
        size = _Internal.bit_ceil(UInt64(_n))
        log = _Internal.countr_zero(UInt64(size))
        d = [S](repeating: e, count: 2 * size)
        lz = [F](repeating: id, count: size)
        // for (int i = 0; i < _n; i++) d[size + i] = v[i];
        __update { $0.initialize(v) }
    }
}

extension lazy_segtree._UnsafeHandle {
    func initialize(_ v: [S]) {
        for i in 0..<_n { d[size + i] = v[i] }
        for i in (size - 1)..>=1 {
            update(i)
        }
    }
}

extension lazy_segtree._UnsafeHandle {
    
    func set(_ p: Int,_ x: S) {
        var p = p
        assert(0 <= p && p < _n);
        p += size;
        // for (int i = log; i >= 1; i--) push(p >> i);
        for i in log..>=1 { push(p >> i); }
        d[p] = x;
        // for (int i = 1; i <= log; i++) update(p >> i);
        for i in 1..<=log { update(p >> i); }
    }
    
    func get(_ p: Int) -> S {
        var p = p
        assert(0 <= p && p < _n);
        p += size;
        // for (int i = log; i >= 1; i--) push(p >> i);
        for i in log..>=1 { push(p >> i); }
        return d[p];
    }
    
    func prod(_ l: Int,_ r: Int) -> S{
        var l = l
        var r = r
        assert(0 <= l && l <= r && r <= _n);
        if (l == r) { return e(); }
        
        l += size;
        r += size;
        
        //        for (int i = log; i >= 1; i--) {
        for i in log..>=1 {
            if (((l >> i) << i) != l) { push(l >> i); }
            if (((r >> i) << i) != r) { push((r - 1) >> i); }
        }
        
        var sml = e(), smr = e();
        while (l < r) {
            if (l & 1 != 0) { sml = op(sml, d[l]); l += 1 }
            if (r & 1 != 0) { r -= 1; smr = op(d[r], smr); }
            l >>= 1;
            r >>= 1;
        }
        
        return op(sml, smr);
    }
    
    func all_prod() -> S { return d[1]; }
    
    func apply(_ p: Int,_ f: F) {
        var p = p
        assert(0 <= p && p < _n);
        p += size;
        // for (int i = log; i >= 1; i--) push(p >> i);
        for i in log..>=1 { push(p >> i); }
        d[p] = mapping(f, d[p]);
        // for (int i = 1; i <= log; i++) update(p >> i);
        for i in 1..<=log { update(p >> i); }
    }
    
    func apply(_ l: Int,_ r: Int,_ f: F) {
        var l = l
        var r = r
        assert(0 <= l && l <= r && r <= _n);
        if (l == r) { return; }
        
        l += size;
        r += size;
        
        // for (int i = log; i >= 1; i--) {
        for i in log..>=1 {
            if (((l >> i) << i) != l) { push(l >> i); }
            if (((r >> i) << i) != r) { push((r - 1) >> i); }
        }
        
        do {
            let l2 = l, r2 = r;
            while (l < r) {
                if (l & 1 != 0) { all_apply(l, f); l += 1 }
                if (r & 1 != 0) { r -= 1; all_apply(r, f); }
                l >>= 1;
                r >>= 1;
            }
            l = l2;
            r = r2;
        }
        
        // for (int i = 1; i <= log; i++) {
        for i in 1..<=log {
            if (((l >> i) << i) != l) { update(l >> i); }
            if (((r >> i) << i) != r) { update((r - 1) >> i); }
        }
    }
    
    //    template <bool (*g)(S)> int max_right(int l) {
    //        return max_right(l, [](S x) { return g(x); });
    //    }
    func max_right(_ l: Int,_ g: (S) -> Bool) -> Int {
        var l = l
        assert(0 <= l && l <= _n);
        assert(g(e()));
        if (l == _n) { return _n; }
        l += size;
        // for (int i = log; i >= 1; i--) push(l >> i);
        for i in log..>=1 { push(l >> i); }
        var sm: S = e();
        repeat {
            while (l % 2 == 0) { l >>= 1; }
            if (!g(op(sm, d[l]))) {
                while (l < size) {
                    push(l);
                    l = (2 * l);
                    if (g(op(sm, d[l]))) {
                        sm = op(sm, d[l]);
                        l += 1;
                    }
                }
                return l - size;
            }
            sm = op(sm, d[l]);
            l += 1;
        } while ((l & -l) != l);
        return _n;
    }
    
    //    template <bool (*g)(S)> int min_left(int r) {
    //        return min_left(r, [](S x) { return g(x); });
    //    }
    func min_left(_ r: Int,_ g: (S) -> Bool) -> Int {
        var r = r
        assert(0 <= r && r <= _n);
        assert(g(e()));
        if (r == 0) { return 0; }
        r += size;
        // for (int i = log; i >= 1; i--) push((r - 1) >> i);
        for i in log..>=1 { push((r - 1) >> i); }
        var sm: S = e();
        repeat {
            r -= 1;
            while (r > 1 && (r % 2) != 0) { r >>= 1; }
            if (!g(op(d[r], sm))) {
                while (r < size) {
                    push(r);
                    r = (2 * r + 1);
                    if (g(op(d[r], sm))) {
                        sm = op(d[r], sm);
                        r -= 1;
                    }
                }
                return r + 1 - size;
            }
            sm = op(d[r], sm);
        } while ((r & -r) != r);
        return 0;
    }
}

extension lazy_segtree._UnsafeHandle {
    
    func update(_ k: Int) { d[k] = op(d[2 * k], d[2 * k + 1]); }
    
    func all_apply(_ k: Int,_ f: F) {
        d[k] = mapping(f, d[k]);
        if (k < size) { lz[k] = composition(f, lz[k]); }
    }
    
    func push(_ k: Int) {
        all_apply(2 * k, lz[k]);
        all_apply(2 * k + 1, lz[k]);
        lz[k] = id();
    }
    
    @inlinable @inline(__always) func e() -> S { _e }
    @inlinable @inline(__always) func id() -> F { _id }
}

extension lazy_segtree {
    
    @usableFromInline
    struct _UnsafeHandle {
        
        @inlinable @inline(__always)
        init(
            op: @escaping (S, S) -> S,
            e: S,
            mapping: @escaping (F, S) -> S,
            composition: @escaping (F, F) -> F,
            id: F,
            _n: Int,
            size: Int,
            log: Int,
            d: UnsafeMutablePointer<S>,
            lz: UnsafeMutablePointer<F>
        ) {
            self.op = op
            self._e = e
            self.mapping = mapping
            self.composition = composition
            self._id = id
            
            self._n = _n
            self.size = size
            self.log = log
            self.d = d
            self.lz = lz
        }

        public let op: (S,S) -> S
        public let _e: S
        public let mapping: (F,S) -> S
        public let composition: (F,F) -> F
        public let _id: F

        public let _n, size, log: Int
        public let d: UnsafeMutablePointer<S>
        public let lz: UnsafeMutablePointer<F>
    }
}

extension lazy_segtree {
    
    @inlinable @inline(__always)
    mutating func __update<R>(_ body: (_UnsafeHandle) -> R) -> R {
        let handle = _UnsafeHandle(op: op, e: _e, mapping: mapping, composition: composition, id: _id, _n: _n, size: size, log: log, d: &d, lz: &lz)
        return body(handle)
    }
}

public extension lazy_segtree {
    
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
    mutating func apply(_ p: Int,_ f: F) {
        __update{ $0.apply(p, f) }
    }
    mutating func apply(_ l: Int,_ r: Int,_ f: F) {
        __update{ $0.apply(l, r, f) }
    }
    mutating func max_right(_ l: Int,_ g: (S) -> Bool) -> Int {
        __update{ $0.max_right(l, g) }
    }
    mutating func min_left(_ r: Int,_ g: (S) -> Bool) -> Int {
        __update{ $0.min_left(r, g) }
    }
}
