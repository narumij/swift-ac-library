import Foundation

public protocol SegtreeParameter {
    associatedtype S
    static var op: Op { get }
    static var e: E { get }
}

public extension SegtreeParameter {
    typealias Op = (S,S) -> S
    typealias E = S
}

public struct SegTree<P: SegtreeParameter> {
    public typealias S = P.S
    
    public init() { self.init(0) }
    public init(_ n: Int) { self.init([S](repeating: P.e, count: n)) }
    public init(_ v: [S]) {
        _n = v.count
        size = _Internal.bit_ceil(CUnsignedInt(_n))
        log = _Internal.countr_zero(CUnsignedInt(size))
        d = .init(repeating: P.e, count: 2 * size)
        d.withUnsafeMutableBufferPointer { d in
        // for (int i = 0; i < _n; i++) d[size + i] = v[i];
            for i in 0..<_n { d.baseAddress?[size + i] = v[i] }
        }
        // for (int i = size - 1; i >= 1; i--) {
        for i in stride(from: size - 1, through: 1, by: -1) { _update{ $0.update(i) } }
    }
    
    @usableFromInline let _n, size, log: Int
    @usableFromInline var d: ContiguousArray<S>
}

extension SegTree._UnsafeHandle {
    
    @inlinable @inline(__always)
    func set(_ p: Int,_ x: S) {
        var p = p
        assert(0 <= p && p < _n)
        p += size
        d[p] = x
        // for (int i = 1; i <= log; i++) update(p >> i);
        for i in stride(from: 1, through: log, by: 1) { update(p >> i) }
    }
    
    @inlinable @inline(__always)
    func get(_ p: Int) -> S {
        assert(0 <= p && p < _n)
        return d[p + size]
    }
    
    @inlinable @inline(__always)
    func prod(_ l: Int,_ r: Int) -> S {
        var l = l, r = r
        assert(0 <= l && l <= r && r <= _n)
        var sml: S = e(), smr: S = e()
        l += size
        r += size

        while l < r {
            if l & 1 != 0 { sml = op(sml, d[l]); l += 1 }
            if r & 1 != 0 { r -= 1; smr = op(d[r], smr) }
            l >>= 1
            r >>= 1
        }
        
        return op(sml, smr)
    }

}

extension SegTree {
    func all_prod() -> S { return d[1] }
}

extension SegTree._UnsafeHandle {

    @inlinable @inline(__always)
    func max_right(_ l: Int,_ f: (S) -> Bool) -> Int {
        var l = l
        assert(0 <= l && l <= _n)
        assert(f(e()))
        if l == _n { return _n }
        l += size
        var sm: S = e()
        repeat {
            while l % 2 == 0 { l >>= 1 }
            if !f(op(sm, d[l])) {
                while l < size {
                    l = (2 * l)
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
    
    @inlinable @inline(__always)
    func min_left(_ r: Int,_ f: (S) -> Bool ) -> Int {
        var r = r
        assert(0 <= r && r <= _n)
        assert(f(e()))
        if r == 0 { return 0 }
        r += size
        var sm: S = e()
        repeat {
            r -= 1
            while r > 1 && r % 2 != 0 { r >>= 1 }
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
    
    @inlinable @inline(__always)
    public func update(_ k: Int) { d[k] = op(d[2 * k], d[2 * k + 1]) }
}

extension SegTree {
    
    @usableFromInline
    struct _UnsafeHandle {
        
        @inlinable @inline(__always)
        internal init(
            _n: Int,
            size: Int,
            log: Int,
            d: UnsafeMutablePointer<S>)
        {
            self._n = _n
            self.size = size
            self.log = log
            self.d = d
        }
        
        @usableFromInline let _n, size, log: Int
        @usableFromInline let d: UnsafeMutablePointer<S>
        
        @usableFromInline typealias S = P.S
        @usableFromInline func op(_ l: S,_ r: S) -> S { P.op(l,r) }
        @usableFromInline func e() -> S { P.e }
    }
    
    @inlinable @inline(__always)
    mutating func _update<R>(_ body: (_UnsafeHandle) -> R) -> R {
        d.withUnsafeMutableBufferPointer { d in
            body(_UnsafeHandle(_n: _n, size: size, log: log, d: d.baseAddress!))
        }
    }
}

public extension SegTree {
    mutating func set(_ p: Int,_ x: S)                        { _update{ $0.set(p,x) } }
    mutating func get(_ p: Int) -> S                          { _update{ $0.get(p) } }
    mutating func prod(_ l: Int,_ r: Int) -> S                { _update{ $0.prod(l, r) } }
    mutating func max_right(_ l: Int,_ g: (S) -> Bool) -> Int { _update{ $0.max_right(l, g) } }
    mutating func min_left(_ r: Int,_ g: (S) -> Bool) -> Int  { _update{ $0.min_left(r, g) } }
}
