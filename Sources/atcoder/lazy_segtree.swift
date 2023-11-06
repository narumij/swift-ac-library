import Foundation

protocol LazySegtreeProperty: SegtreeProperty {
    associatedtype F
    static var mapping: (F,S) -> S { get }
    static var composition: (F,F) -> F { get }
    static var `id`: () -> F { get }
}

// from https://github.com/atcoder/ac-library/blob/master/atcoder/lazysegtree.hpp
struct lazy_segtree<Property: LazySegtreeProperty> {
    typealias S = Property.S
    var op: (S,S) -> S { Property.op }
    var e: () -> S { Property.e }
    typealias F = Property.F
    var mapping: (F,S) -> S { Property.mapping }
    var composition: (F,F) -> F { Property.composition }
    var `id`: () -> F { Property.id }

    init() { self.init(0) }
    init(_ n: Int) { self.init([S](repeating: Property.e(), count: n)) }
    init(_ v: [S]) {
        _n = v.count
        size = Int(`internal`.bit_ceil(UInt(_n)))
        log = `internal`.countr_zero(UInt(size))
        d = [S](repeating: Property.e(), count: 2 * size)
        lz = [F](repeating: Property.id(), count: size)
        for i in 0..<_n { d[size + i] = v[i]; }
        for i in 1 <= size ? (1..<size).reversed() : [] {
            update(i);
        }
    }

    mutating func set(_ p: Int,_ x: S) {
        var p = p
        assert(0 <= p && p < _n);
        p += size;
        // for (int i = log; i >= 1; i--) push(p >> i);
        for i in (1...log).reversed() { push(p >> i); }
        d[p] = x;
        // for (int i = 1; i <= log; i++) update(p >> i);
        for i in (1...log) { update(p >> i); }
    }

    mutating func get(_ p: Int) -> S {
        var p = p
        assert(0 <= p && p < _n);
        p += size;
        // for (int i = log; i >= 1; i--) push(p >> i);
        for i in (1...log).reversed() { push(p >> i); }
        return d[p];
    }

    mutating func prod(_ l: Int,_ r: Int) -> S{
        var l = l
        var r = r
        assert(0 <= l && l <= r && r <= _n);
        if (l == r) { return e(); }

        l += size;
        r += size;

//        for (int i = log; i >= 1; i--) {
        for i in (1...log).reversed() {
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

    mutating func apply(_ p: Int,_ f: F) {
        var p = p
        assert(0 <= p && p < _n);
        p += size;
        // for (int i = log; i >= 1; i--) push(p >> i);
        for i in (1...log).reversed() { push(p >> i); }
        d[p] = mapping(f, d[p]);
        // for (int i = 1; i <= log; i++) update(p >> i);
        for i in 1...log { update(p >> i); }
    }

    mutating func apply(_ l: Int,_ r: Int,_ f: F) {
        var l = l
        var r = r
        assert(0 <= l && l <= r && r <= _n);
        if (l == r) { return; }

        l += size;
        r += size;

//        for (int i = log; i >= 1; i--) {
        for i in (1...log).reversed() {
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

//        for (int i = 1; i <= log; i++) {
        for i in (1...log) {
            if (((l >> i) << i) != l) { update(l >> i); }
            if (((r >> i) << i) != r) { update((r - 1) >> i); }
        }
    }

//    template <bool (*g)(S)> int max_right(int l) {
//        return max_right(l, [](S x) { return g(x); });
//    }
    mutating func max_right(_ l: Int,_ g: (S) -> Bool) -> Int {
        var l = l
        assert(0 <= l && l <= _n);
        assert(g(e()));
        if (l == _n) { return _n; }
        l += size;
        for i in (1...log).reversed() { push(l >> i); }
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
    mutating func min_left(_ r: Int,_ g: (S) -> Bool) -> Int {
        var r = r
        assert(0 <= r && r <= _n);
        assert(g(e()));
        if (r == 0) { return 0; }
        r += size;
        // for (int i = log; i >= 1; i--) push((r - 1) >> i);
        for i in (1...log).reversed() { push((r - 1) >> i); }
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
    
    
    var _n, size, log: Int;
    var d: [S]
    var lz: [F];

    mutating func update(_ k: Int) { d[k] = op(d[2 * k], d[2 * k + 1]); }
    mutating func all_apply(_ k: Int,_ f: F) {
        d[k] = mapping(f, d[k]);
        if (k < size) { lz[k] = composition(f, lz[k]); }
    }
    mutating func push(_ k: Int) {
        all_apply(2 * k, lz[k]);
        all_apply(2 * k + 1, lz[k]);
        lz[k] = id();
    }
}

