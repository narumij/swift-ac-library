import Foundation

public protocol SegtreeParameter {
    associatedtype S
    static var op: (S,S) -> S { get }
    static var e: S { get }
}

public struct segtree<Parameter: SegtreeParameter> {
    public typealias S = Parameter.S
    func op(_ l: S,_ r: S) -> S { Parameter.op(l,r) }
    func e() -> S { Parameter.e }

    public init() { self.init(0) }
    public init<Index: FixedWidthInteger>(_ n: Index) { self.init([S](repeating: Parameter.e, count: Int(n))) }
    public init(_ v: [S]) {
        _n = v.count
        size = Int(_internal.bit_ceil(CUnsignedInt(_n)))
        log = Int(_internal.countr_zero(CUnsignedInt(size)))
        d = [S](repeating: Parameter.e, count: 2 * size)
        // for (int i = 0; i < _n; i++) d[size + i] = v[i];
        for i in 0..<_n { d[size + i] = v[i] }
        // for (int i = size - 1; i >= 1; i--) {
        for i in (size - 1)..>=1 { update(i) }
    }
    
    public mutating func set<Index: FixedWidthInteger>(_ p: Index,_ x: S) {
        var p = Int(p)
        assert(0 <= p && p < _n);
        p += size;
        d[p] = x;
        // for (int i = 1; i <= log; i++) update(p >> i);
        for i in 1..<=log { update(p >> i); }
    }
    
    public func get<Index: FixedWidthInteger>(_ p: Index) -> S {
        assert(0 <= p && p < _n);
        return d[Int(p) + size];
    }
    
    public func prod<Index: FixedWidthInteger>(_ l: Index,_ r: Index) -> S {
        var l = Int(l), r = Int(r)
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
    
    public func all_prod() -> S { return d[1]; }

    public func max_right<Index: FixedWidthInteger>(_ l: Index,_ f: (S) -> Bool) -> Int {
        var l = Int(l)
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
    
    public func min_left<Index: FixedWidthInteger>(_ r: Index,_ f: (S) -> Bool ) -> Int {
        var r = Int(r)
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
    
    private let _n, size, log: Int
    private var d: [S]
    
    private mutating func update(_ k: Int) {
        d[k] = op(d[2 * k], d[2 * k + 1])
    }
}


