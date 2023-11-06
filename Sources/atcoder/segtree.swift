import Foundation

protocol SegtreeParameter {
    associatedtype S
    static var op: (S,S) -> S { get }
    static var e: () -> S { get }
}

// from https://github.com/atcoder/ac-library/blob/master/atcoder/segtree.hpp
struct segtree<Parameter: SegtreeParameter> {
    typealias S = Parameter.S
    var op: (S,S) -> S { Parameter.op }
    var e: () -> S { Parameter.e }

    init() { self.init(0) }
    init(_ n: Int) { self.init([S](repeating: Parameter.e(), count: n)) }
    init(_ v: [S]) {
        _n = v.count
        size = Int(`internal`.bit_ceil(UInt(_n)))
        log = `internal`.countr_zero(UInt(size))
        d = [S](repeating: Parameter.e(), count: 2 * size)
        // for (int i = 0; i < _n; i++) d[size + i] = v[i];
        for i in 0..<_n { d[size + i] = v[i] }
        // for (int i = size - 1; i >= 1; i--) {
        for i in (size - 1)..>=1 { update(i) }
    }
    
    mutating func set(_ p: Int,_ x: S) {
        var p = p
        assert(0 <= p && p < _n);
        p += size;
        d[p] = x;
        // for (int i = 1; i <= log; i++) update(p >> i);
        for i in 1..<=log { update(p >> i); }
    }
    
    func get(_ p: Int) -> S {
        assert(0 <= p && p < _n);
        return d[p + size];
    }
    
    func prod(_ l: Int,_ r: Int) -> S {
        var l = l, r = r
        assert(0 <= l && l <= r && r <= _n);
        var sml: S = e(), smr: S = e();
        l += size;
        r += size;

        while (l < r) {
            if (l & 1) != 0 { sml = op(sml, d[l]); l += 1 }
            if (r & 1) != 0 { r -= 1; smr = op(d[r], smr); }
            l >>= 1;
            r >>= 1;
        }
        return op(sml, smr);
    }
    
    func all_prod() -> S { return d[1]; }

    func max_right(_ l: Int,_ f: (S) -> Bool) -> Int {
        var l = l
        assert(0 <= l && l <= _n);
        assert(f(e()));
        if (l == _n) { return _n; }
        l += size;
        var sm: S = e();
        repeat {
            while (l % 2 == 0) { l >>= 1; }
            if (!f(op(sm, d[l]))) {
                while (l < size) {
                    l = (2 * l);
                    if (f(op(sm, d[l]))) {
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
    
    func min_left(_ r: Int,_ f: (S) -> Bool ) -> Int {
        var r = r
        assert(0 <= r && r <= _n);
        assert(f(e()));
        if (r == 0) { return 0; }
        r += size;
        var sm: S = e();
        repeat {
            r -= 1;
            while (r > 1 && (r % 2) != 0) { r >>= 1; }
            if (!f(op(d[r], sm))) {
                while (r < size) {
                    r = (2 * r + 1);
                    if (f(op(d[r], sm))) {
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
    
    private var _n, size, log: Int
    private var d: [S]
    
    mutating func update(_ k: Int) {
        d[k] = op(d[2 * k], d[2 * k + 1])
    }
}


