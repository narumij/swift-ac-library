import Foundation

public protocol _LazySegtreeProtocol {
    associatedtype S
    static var op: (S,S) -> S { get }
    static var e: S { get }
    associatedtype F
    static var mapping: (F,S) -> S { get }
    static var composition: (F,F) -> F { get }
    static var id: F { get }
}

public protocol LazySegtreeProtocol: _LazySegtreeProtocol {
    init(storage: Storage)
    var storage: Storage { get set }
}

public extension LazySegtreeProtocol {
    typealias Storage = _LazySegtree<Self>._Storage
    init() { self.init(0) }
    init(_ n: Int) {
        self.init(storage: Storage(n: Int(n)))
    }
    init<V: Collection>(_ v: V) where V.Element == S, V.Index == Int {
        self.init(storage: Storage(v))
    }
}

public enum _LazySegtree<Base: _LazySegtreeProtocol> {
    public typealias S = Base.S
    public typealias F = Base.F
}

extension _LazySegtree {

    @usableFromInline
    class _Buffer {
        @usableFromInline
        init(_n: Int, size: Int, log: Int, d: [Base.S], lz: [Base.F]) {
            self._n = _n
            self.size = size
            self.log = log
            self.d = d
            self.lz = lz
        }
        @usableFromInline let _n, size, log: Int
        @usableFromInline var d: [Base.S]
        @usableFromInline var lz: [Base.F]
    }
    
    public struct _Storage {
        
        @inlinable @inline(__always)
        init(_buffer: _Buffer) {
            self._buffer = _buffer
        }
        
        @inlinable @inline(__always)
        init(n: Int) {
            self.init([S](repeating: Base.e, count: n))
        }

        @inlinable @inline(__always)
        init<V: Collection>(_ v: V) where V.Element == S, V.Index == Int {
            let _n = v.count
            let size: Int = _Internal.bit_ceil(UInt64(_n))
            let log: Int = _Internal.countr_zero(UInt64(size))
            let buffer = _Buffer(
                _n: _n,
                size: size,
                log: log,
                d: [S](repeating: Base.e, count: 2 * size),
                lz: [F](repeating: Base.id, count: size)
            )
            self.init(_buffer: buffer)
            __update {
                for i in 0 ..< _n { $0.d[size + i] = v[i] }
                for i in stride(from: $0.size - 1, through: 1, by: -1) { $0.update(i) }
            }
        }

        @usableFromInline var _buffer: _Buffer
        
        @inlinable @inline(__always)
        public func __read<R>(_ body: (_UnsafeHandle) -> R) -> R {
            _buffer.d.withUnsafeMutableBufferPointer { d in
                _buffer.lz.withUnsafeMutableBufferPointer { lz in
                    let handle = _UnsafeHandle(_n: _buffer._n, size: _buffer.size, log: _buffer.log, d: d.baseAddress!, lz: lz.baseAddress!)
                    return body(handle)
                }
            }
        }
        
        @inlinable @inline(__always)
        public mutating func __update<R>(_ body: (_UnsafeHandle) -> R) -> R {
            _buffer.d.withUnsafeMutableBufferPointer { d in
                _buffer.lz.withUnsafeMutableBufferPointer { lz in
                    let handle = _UnsafeHandle(_n: _buffer._n, size: _buffer.size, log: _buffer.log, d: d.baseAddress!, lz: lz.baseAddress!)
                    return body(handle)
                }
            }
        }
    }
}

extension _LazySegtree {
    
    public
    struct _UnsafeHandle {
        
        @inlinable @inline(__always)
        init(
            _n: Int,
            size: Int,
            log: Int,
            d: UnsafeMutablePointer<Base.S>,
            lz: UnsafeMutablePointer<Base.F>
        ) {
            self._n = _n
            self.size = size
            self.log = log
            self.d = d
            self.lz = lz
        }
        
        @usableFromInline let _n, size, log: Int
        @usableFromInline let d: UnsafeMutablePointer<Base.S>
        @usableFromInline let lz: UnsafeMutablePointer<Base.F>

#if true
        typealias S = Base.S
        func op(_ l: S,_ r: S) -> S { Base.op(l,r) }
        func e() -> S { Base.e }
        
        typealias F = Base.F
        func mapping(_ l: F,_ r: S) -> S { Base.mapping(l,r) }
        func composition(_ l: F,_ r: F) -> F { Base.composition(l,r) }
        func id() -> F { Base.id }
#else
        // Swift 5.9以後は以下にする。
        // protocolにまつわる分岐が減り、パフォーマンスが改善する
        typealias S = Base.S
        var op: (S,S) -> S = { Base.op }()
        func e() -> S { Base.e }
        
        typealias F = Base.F
        var mapping: (F,S) -> S = { Base.mapping }()
        var composition: (F,F) -> F = { Base.composition }()
        func id() -> F { Base.id }
#endif
    }
}

extension _LazySegtree._UnsafeHandle {
    
    func set(_ p: Int,_ x: S) {
        var p = p
        assert(0 <= p && p < _n)
        p += size
        for i in log ..>= 1 { push(p >> i) }
        d[p] = x
        for i in 1 ..<= log { update(p >> i) }
    }
    
    func get(_ p: Int) -> S {
        var p = p
        assert(0 <= p && p < _n)
        p += size
        for i in log ..>= 1 { push(p >> i) }
        return d[p]
    }
    
    func prod(_ l: Int,_ r: Int) -> S{
        var l = l
        var r = r
        assert(0 <= l && l <= r && r <= _n)
        if l == r { return e() }
        
        l += size
        r += size
        
        for i in log ..>= 1 {
            if ((l >> i) << i) != l { push(l >> i) }
            if ((r >> i) << i) != r { push((r - 1) >> i) }
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
    
    func all_prod() -> S { return d[1] }

    func apply(_ p: Int,_ f: F) {
        var p = p
        assert(0 <= p && p < _n)
        p += size
        for i in log ..>= 1 { push(p >> i) }
        d[p] = mapping(f, d[p])
        for i in 1 ..<= log { update(p >> i) }
    }

    func apply(_ l: Int,_ r: Int,_ f: F) {
        var l = l
        var r = r
        assert(0 <= l && l <= r && r <= _n)
        if l == r { return }

        l += size
        r += size

        for i in log ..>= 1 {
            if ((l >> i) << i) != l { push(l >> i) }
            if ((r >> i) << i) != r { push((r - 1) >> i) }
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

        for i in 1 ..<= log {
            if ((l >> i) << i) != l { update(l >> i) }
            if ((r >> i) << i) != r { update((r - 1) >> i) }
        }
    }

    func max_right(_ l: Int,_ g: (S) -> Bool) -> Int {
        var l = l
        assert(0 <= l && l <= _n)
        assert(g(e()))
        if l == _n { return _n }
        l += size
        for i in log ..>= 1 { push(l >> i) }
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
        } while (l & -l) != l
        return _n
    }
    
    func min_left(_ r: Int,_ g: (S) -> Bool) -> Int {
        var r = r
        assert(0 <= r && r <= _n)
        assert(g(e()))
        if r == 0 { return 0 }
        r += size
        for i in log ..>= 1 { push((r - 1) >> i) }
        var sm = e()
        repeat {
            r -= 1
            while r > 1 && (r % 2) != 0 { r >>= 1 }
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
        } while (r & -r) != r
        return 0
    }
    
    @usableFromInline
    func update(_ k: Int) { d[k] = op(d[2 * k], d[2 * k + 1]) }
    
    func all_apply(_ k: Int,_ f: F) {
        d[k] = mapping(f, d[k])
        if k < size { lz[k] = composition(f, lz[k]) }
    }
    
    func push(_ k: Int) {
        all_apply(2 * k, lz[k])
        all_apply(2 * k + 1, lz[k])
        lz[k] = id()
    }
}

public extension LazySegtreeProtocol {
    
    mutating func set(_ p: Int,_ x: S) {
        storage.__update{ $0.set(p,x) }
    }
    mutating func get(_ p: Int) -> S {
        storage.__update{ $0.get(p) }
    }
    mutating func prod(_ l: Int,_ r: Int) -> S {
        storage.__update{ $0.prod(l, r) }
    }
    func allProd() -> S {
        storage.__read{ $0.all_prod() }
    }
    mutating func apply(_ p: Int,_ f: F) {
        storage.__update{ $0.apply(p, f) }
    }
    mutating func apply(_ l: Int,_ r: Int,_ f: F) {
        storage.__update{ $0.apply(l, r, f) }
    }
    mutating func maxRight(_ l: Int,_ g: (S) -> Bool) -> Int {
        storage.__update{ $0.max_right(l, g) }
    }
    mutating func minLeft(_ r: Int,_ g: (S) -> Bool) -> Int {
        storage.__update{ $0.min_left(r, g) }
    }
}
