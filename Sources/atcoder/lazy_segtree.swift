import Foundation

public protocol LazySegtreeParameter {
    associatedtype S
    static var op: (S,S) -> S { get }
    static var e: S { get }
    associatedtype F
    static var mapping: (F,S) -> S { get }
    static var composition: (F,F) -> F { get }
    static var id: F { get }
}

public struct lazy_segtree<Parameter: LazySegtreeParameter> {
    public typealias S = Parameter.S
    public typealias F = Parameter.F
    
    public init() { self.init(0) }
    public init<Index: FixedWidthInteger>(_ n: Index) { self.init([S](repeating: Parameter.e, count: Int(n))) }
    public init(_ v: [S]) {
        _n = v.count
        size = _internal.bit_ceil(CUnsignedInt(_n))
        log = _internal.countr_zero(CUnsignedInt(size))
        d = .init(repeating: Parameter.e, count: 2 * size)
        lz = .init(repeating: Parameter.id, count: size)
        // for (int i = 0; i < _n; i++) d[size + i] = v[i];
        for i in 0..<_n { d[size + i] = v[i]; }
        // for (int i = size - 1; i >= 1; i--) {
        for i in (size - 1)..>=1 {
            _update { $0.update(i); }
        }
    }
    
    @usableFromInline let _n, size, log: Int;
    @usableFromInline var d: [S];
    @usableFromInline var lz: [F];
}

extension lazy_segtree._UnsafeHandle {
    
    @inlinable @inline(__always)
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
    
    @inlinable @inline(__always)
    func get(_ p: Int) -> S {
        var p = p
        assert(0 <= p && p < _n);
        p += size;
        // for (int i = log; i >= 1; i--) push(p >> i);
        for i in log..>=1 { push(p >> i); }
        return d[p];
    }
    
    @inlinable @inline(__always)
    func prod(_ l: Int,_ r: Int) -> S{
        var l = l
        var r = r
        assert(0 <= l && l <= r && r <= _n);
        if (l == r) { return e(); }
        
        l += size;
        r += size;
        
        // for (int i = log; i >= 1; i--) {
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
}

public extension lazy_segtree {
    func all_prod() -> S { return d[1]; }
}

extension lazy_segtree._UnsafeHandle {

    @inlinable @inline(__always)
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

    @inlinable @inline(__always)
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
    @inlinable @inline(__always)
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
    @inlinable @inline(__always)
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
    
    @inlinable @inline(__always)
    public func update(_ k: Int) { d[k] = op(d[2 * k], d[2 * k + 1]); }
    
    @inlinable @inline(__always)
    func all_apply(_ k: Int,_ f: F) {
        d[k] = mapping(f, d[k]);
        if (k < size) { lz[k] = composition(f, lz[k]); }
    }
    
    @inlinable @inline(__always)
    func push(_ k: Int) {
        all_apply(2 * k, lz[k]);
        all_apply(2 * k + 1, lz[k]);
        lz[k] = id();
    }
}

extension lazy_segtree {
    
    @usableFromInline
    struct _UnsafeHandle {
        
        @inlinable @inline(__always)
        internal init(
            _n: Int,
            size: Int,
            log: Int,
            d: UnsafeMutableBufferPointer<S>,
            lz: UnsafeMutableBufferPointer<F>)
        {
            self._n = _n
            self.size = size
            self.log = log
            self.d = d
            self.lz = lz
        }
        
        @usableFromInline let _n, size, log: Int
        @usableFromInline let d: UnsafeMutableBufferPointer<S>
        @usableFromInline let lz: UnsafeMutableBufferPointer<F>
        
        @usableFromInline typealias S = Parameter.S
        @usableFromInline func op(_ l: S,_ r: S) -> S { Parameter.op(l,r) }
        @usableFromInline func e() -> S { Parameter.e }
        
        @usableFromInline typealias F = Parameter.F
        @usableFromInline func mapping(_ l: F,_ r: S) -> S { Parameter.mapping(l,r) }
        @usableFromInline func composition(_ l: F,_ r: F) -> F { Parameter.composition(l,r) }
        @usableFromInline func id() -> F { Parameter.id }
    }
    
    @inlinable @inline(__always)
    mutating func _update<R>(_ body: (_UnsafeHandle) -> R) -> R {
        d.withUnsafeMutableBufferPointer { d in
            lz.withUnsafeMutableBufferPointer { lz in
                body(_UnsafeHandle(_n: _n, size: size, log: log, d: d, lz: lz))
            }
        }
    }
}

public extension lazy_segtree {
    mutating func set<Index>(_ p: Index,_ x: S)
    where Index: FixedWidthInteger
    {
        _update{ $0.set(Int(p),x) }
    }
    mutating func get<Index>(_ p: Index) -> S
    where Index: FixedWidthInteger
    {
        _update{ $0.get(Int(p)) }
    }
    mutating func prod<Index>(_ l: Index,_ r: Index) -> S
    where Index: FixedWidthInteger 
    {
        _update{ $0.prod(Int(l), Int(r)) }
    }
    mutating func apply<Index>(_ p: Index,_ f: F)
    where Index: FixedWidthInteger
    {
        _update{ $0.apply(Int(p), f) }
    }
    mutating func apply<Index>(_ l: Index,_ r: Index,_ f: F)
    where Index: FixedWidthInteger
    {
        _update{ $0.apply(Int(l), Int(r), f) }
    }
    mutating func max_right<Index>(_ l: Index,_ g: (S) -> Bool) -> Int
    where Index: FixedWidthInteger
    {
        _update{ $0.max_right(Int(l), g) }
    }
    mutating func min_left<Index>(_ r: Index,_ g: (S) -> Bool) -> Int
    where Index: FixedWidthInteger
    {
        _update{ $0.min_left(Int(r), g) }
    }
}
