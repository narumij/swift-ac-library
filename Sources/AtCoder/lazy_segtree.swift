import Foundation

// MARK: - Lazy SegTree

public protocol LazySegTreeProtocol {
    associatedtype S
    associatedtype F
    init(storage: Storage)
    var storage: Storage { get set }
    static var op: Op { get }
    static var e: S { get }
    static var mapping: Mapping { get }
    static var composition: Composition { get }
    static var id: Id { get }
}

public extension LazySegTreeProtocol {
    
    typealias Storage = LazySegTree<S,F>.Storage
    typealias Op = LazySegTree<S,F>.Op
    typealias E = LazySegTree<S,F>.E
    typealias Mapping = LazySegTree<S,F>.Mapping
    typealias Composition = LazySegTree<S,F>.Composition
    typealias Id = LazySegTree<S,F>.Id
    
    @inlinable @inline(__always)
    var op: Op { Self.op }
    @inlinable @inline(__always)
    var e: E { Self.e }
    @inlinable @inline(__always)
    var mapping: Mapping { Self.mapping }
    @inlinable @inline(__always)
    var composition: Composition { Self.composition }
    @inlinable @inline(__always)
    var id: Id { Self.id }

    init()
    {
        self.init(count: 0)
    }
    
    init(count n: Int)
    {
        self.init([S](repeating: Self.e, count: n) )
    }
    
    init<V>(_ v: V) where V: Collection, V.Element == S
    {
        self.init(storage: .init(op: Self.op, e: Self.e, mapping: Self.mapping, composition: Self.composition, id: Self.id, v))
    }

    mutating func set(_ p: Int,_ x: S) {
        storage.set(op, e, mapping, composition, id, p, x)
    }
    
    mutating func get(_ p: Int) -> S {
        storage.get(op, e, mapping, composition, id, p)
    }
    
    mutating func prod(_ l: Int,_ r: Int) -> S {
        storage.prod(op, e, mapping, composition, id, l, r)
    }
    
    mutating func all_prod() -> S {
        storage.all_prod()
    }
    
    mutating func apply(_ p: Int,_ f: F) {
        storage.apply(op, e, mapping, composition, id, p, f)
    }
    
    mutating func apply(_ l: Int,_ r: Int,_ f: F) {
        storage.apply(op, e, mapping, composition, id, l, r, f)
    }

    mutating func max_right(_ l: Int,_ g: (S) -> Bool) -> Int {
        storage.max_right(op, e, mapping, composition, id, l, g)
    }
    
    mutating func min_left(_ r: Int,_ g: (S) -> Bool) -> Int {
        storage.min_left(op, e, mapping, composition, id, r, g)
    }
}

public struct LazySegTree<S,F> {
    let _op: (S,S) -> S
    let _e: S
    let _mapping: (F,S) -> S
    let _composition: (F,F) -> F
    let _id: F
    
    var storage: Storage
}

public extension LazySegTree {
    
    typealias Op = (S,S) -> S
    typealias E = S
    typealias Mapping = (F,S) -> S
    typealias Composition = (F,F) -> F
    typealias Id = F
    
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
    
    init<V>(op: @escaping (S, S) -> S,
         e: S,
         mapping: @escaping (F, S) -> S,
         composition: @escaping (F, F) -> F,
         id: F,
         _ v: V)
    where V: Collection, V.Element == S
    {
        _op = op
        _e = e
        _mapping = mapping
        _composition = composition
        _id = id
        
        storage = .init(
            op: op,
            e: e,
            mapping: mapping,
            composition: composition,
            id: id,
            v)
    }
}

public extension LazySegTree {
    
    mutating func set(_ p: Int,_ x: S) {
        storage.set(_op, _e, _mapping, _composition, _id, p, x)
    }
    
    mutating func get(_ p: Int) -> S {
        storage.get(_op, _e, _mapping, _composition, _id, p)
    }
    
    mutating func prod(_ l: Int,_ r: Int) -> S {
        storage.prod(_op, _e, _mapping, _composition, _id, l, r)
    }
    
    mutating func all_prod() -> S {
        storage.all_prod()
    }
    
    mutating func apply(_ p: Int,_ f: F) {
        storage.apply(_op, _e, _mapping, _composition, _id, p, f)
    }
    
    mutating func apply(_ l: Int,_ r: Int,_ f: F) {
        storage.apply(_op, _e, _mapping, _composition, _id, l, r, f)
    }
    
    mutating func max_right(_ l: Int,_ g: (S) -> Bool) -> Int {
        storage.max_right(_op, _e, _mapping, _composition, _id, l, g)
    }
    
    mutating func min_left(_ r: Int,_ g: (S) -> Bool) -> Int {
        storage.min_left(_op, _e, _mapping, _composition, _id, r, g)
    }
}

extension LazySegTree {
    
    public
    struct Storage {

        @usableFromInline let _n, _size, _log: Int
        @usableFromInline var d: [S]
        @usableFromInline var lz: [F]
    }
}

public extension LazySegTree.Storage {
    
    typealias Op = LazySegTree.Op
    typealias E = LazySegTree.E
    typealias Mapping = LazySegTree.Mapping
    typealias Composition = LazySegTree.Composition
    typealias Id = LazySegTree.Id

    @inlinable @inline(__always)
    init(op: Op,
         e: E,
         mapping: Mapping,
         composition: Composition,
         id: Id)
    {
        self.init(op: op,
                  e: e,
                  mapping: mapping,
                  composition: composition,
                  id: id,
                  count: 0)
    }
    
    @inlinable @inline(__always)
    init(op: Op,
         e: E,
         mapping: Mapping,
         composition: Composition,
         id: Id,
         count n: Int)
    {
        self.init(op: op,
                  e: e,
                  mapping: mapping,
                  composition: composition,
                  id: id,
                  [S](repeating: e, count: n))
    }
    
    @inlinable @inline(__always)
    init<V>(op: Op,
            e: E,
            mapping: Mapping,
            composition: Composition,
            id: Id,
            _ v: V)
    where V: Collection, V.Element == S
    {
        _n = v.count
        _size = _Internal.bit_ceil(UInt64(_n))
        _log = _Internal.countr_zero(UInt64(_size))
        let (__size,__n) = (_size, _n)
        d = [S](unsafeUninitializedCapacity: 2 * __size) { buffer, initializedCount in
            for i in 0 ..< (2 * __size) {
                if __size <= i, i < __size + __n {
                    // for (int i = 0; i < _n; i++) d[size + i] = v[i];
                    buffer.initializeElement(at: i, to: v[v.index(v.startIndex, offsetBy: i - __size)])
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
                unsafeHandle.update(op, i)
            }
        }
    }
}

extension LazySegTree.Storage {
    
    @usableFromInline
    struct _UnsafeHandle {
        
        @inlinable @inline(__always)
        init(
            _n: Int,
            size: Int,
            log: Int,
            d: UnsafeMutablePointer<S>,
            lz: UnsafeMutablePointer<F>
        ) {
            self._n = _n
            self.size = size
            self.log = log
            self.d = d
            self.lz = lz
        }
        
        public let _n, size, log: Int
        public let d: UnsafeMutablePointer<S>
        public let lz: UnsafeMutablePointer<F>
    }
}

extension LazySegTree.Storage {
    @inlinable @inline(__always)
    mutating func __update<R>(_ body: (_UnsafeHandle) -> R) -> R {
        let handle = _UnsafeHandle(_n: _n, size: _size, log: _log, d: &d, lz: &lz)
        return body(handle)
    }
}

extension LazySegTree.Storage._UnsafeHandle {
    
    public typealias Op = LazySegTree.Storage.Op
    public typealias E = LazySegTree.Storage.E
    public typealias Mapping = LazySegTree.Storage.Mapping
    public typealias Composition = LazySegTree.Storage.Composition
    public typealias Id = LazySegTree.Storage.Id
    
    @inlinable
    func set(_ op: Op,_ mapping: Mapping,_ composition: Composition,_ id: Id,_ p: Int,_ x: S) {
        var p = p
        assert(0 <= p && p < _n)
        p += size
        for i in stride(from: log, through: 1, by: -1) { push(mapping, composition, id, p >> i) }
        d[p] = x
        for i in stride(from: 1, through: log, by: 1) { update(op, p >> i) }
    }
    
    @inlinable
    func get(_ mapping: Mapping,_ composition: Composition,_ id: Id,_ p: Int) -> S {
        var p = p
        assert(0 <= p && p < _n)
        p += size
        for i in stride(from: log, through: 1, by: -1) { push(mapping, composition, id, p >> i) }
        return d[p]
    }
    
    @inlinable
    func prod(_ op: Op,_ e: E,_ mapping: Mapping,_ composition: Composition,_ id: Id,_ l: Int,_ r: Int) -> S{
        assert(0 <= l && l <= r && r <= _n)
        if l == r { return e }
        var (l, r) = (l + size, r + size)
        
        for i in stride(from: log, through: 1, by: -1) {
            if (l >> i) << i != l { push(mapping, composition, id, l >> i) }
            if (r >> i) << i != r { push(mapping, composition, id, (r - 1) >> i) }
        }
        
        var sml = e, smr = e
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
    func apply(_ op: Op,_ e: E,_ mapping: Mapping,_ composition: Composition,_ id: Id,_ p: Int,_ f: F) {
        var p = p
        assert(0 <= p && p < _n)
        p += size
        for i in stride(from: log, through: 1, by: -1) { push(mapping, composition, id, p >> i) }
        d[p] = mapping(f, d[p])
        for i in stride(from: 1, through: log, by: 1) { update(op, p >> i) }
    }

    @inlinable
    func apply(_ op: Op,_ e: E,_ mapping: Mapping,_ composition: Composition,_ id: Id,_ l: Int,_ r: Int,_ f: F) {
        var l = l
        var r = r
        assert(0 <= l && l <= r && r <= _n)
        if l == r { return }

        l += size
        r += size

        for i in stride(from: log, through: 1, by: -1) {
            if (l >> i) << i != l { push(mapping, composition, id, l >> i) }
            if (r >> i) << i != r { push(mapping, composition, id, (r - 1) >> i) }
        }

        do {
            let l2 = l, r2 = r
            while l < r {
                if l & 1 != 0 { all_apply(mapping, composition, l, f); l += 1 }
                if r & 1 != 0 { r -= 1; all_apply(mapping, composition, r, f) }
                l >>= 1
                r >>= 1
            }
            l = l2
            r = r2
        }

        for i in stride(from: 1, through: log, by: 1) {
            if (l >> i) << i != l { update(op, l >> i) }
            if (r >> i) << i != r { update(op, (r - 1) >> i) }
        }
    }

    @inlinable
    func max_right(_ op: Op,_ e: E,_ mapping: Mapping,_ composition: Composition,_ id: Id,_ l: Int,_ g: (S) -> Bool) -> Int {
        var l = l
        assert(0 <= l && l <= _n)
        assert(g(e))
        if l == _n { return _n }
        l += size
        for i in stride(from: log, through: 1, by: -1) { push(mapping, composition, id, l >> i) }
        var sm = e
        repeat {
            while l % 2 == 0 { l >>= 1 }
            if !g(op(sm, d[l])) {
                while l < size {
                    push(mapping, composition, id, l)
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
    func min_left(_ op: Op,_ e: E,_ mapping: Mapping,_ composition: Composition,_ id: Id,_ r: Int,_ g: (S) -> Bool) -> Int {
        var r = r
        assert(0 <= r && r <= _n)
        assert(g(e))
        if r == 0 { return 0 }
        r += size
        for i in stride(from: log, through: 1, by: -1) { push(mapping, composition, id, (r - 1) >> i) }
        var sm = e
        repeat {
            r -= 1
            while r > 1, r % 2 != 0 { r >>= 1 }
            if !g(op(d[r], sm)) {
                while r < size {
                    push(mapping, composition, id, r)
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
    func update(_ op: Op,_ k: Int) {
        
        d[k] = op(d[2 * k], d[2 * k + 1])
    }
    
    @inlinable @inline(__always)
    func all_apply(_ mapping: Mapping,_ composition: Composition,_ k: Int,_ f: F) {
        d[k] = mapping(f, d[k])
        if k < size { lz[k] = composition(f, lz[k]) }
    }
    
    @inlinable @inline(__always)
    func push(_ mapping: Mapping,_ composition: Composition,_ id: Id,_ k: Int) {
        all_apply(mapping, composition, 2 * k, lz[k])
        all_apply(mapping, composition, 2 * k + 1, lz[k])
        lz[k] = id
    }
}

public extension LazySegTree.Storage {
    
    @inlinable @inline(__always)
    mutating func set(_ op: Op,_ e: E,_ mapping: Mapping,_ composition: Composition,_ id: Id,_ p: Int,_ x: S) {
        __update{ $0.set(op, mapping, composition, id, p,x) }
    }
    
    @inlinable @inline(__always)
    mutating func get(_ op: Op,_ e: E,_ mapping: Mapping,_ composition: Composition,_ id: Id,_ p: Int) -> S {
        __update{ $0.get(mapping, composition, id, p) }
    }
    
    @inlinable @inline(__always)
    mutating func prod(_ op: Op,_ e: E,_ mapping: Mapping,_ composition: Composition,_ id: Id,_ l: Int,_ r: Int) -> S {
        __update{ $0.prod(op, e, mapping, composition, id, l, r) }
    }
    
    @inlinable @inline(__always)
    mutating func all_prod() -> S {
        __update{ $0.all_prod() }
    }
    
    @inlinable @inline(__always)
    mutating func apply(_ op: Op,_ e: E,_ mapping: Mapping,_ composition: Composition,_ id: Id,_ p: Int,_ f: F) {
        __update{ $0.apply(op, e, mapping, composition, id, p, f) }
    }
    
    @inlinable @inline(__always)
    mutating func apply(_ op: Op,_ e: E,_ mapping: Mapping,_ composition: Composition,_ id: Id,_ l: Int,_ r: Int,_ f: F) {
        __update{ $0.apply(op, e, mapping, composition, id, l, r, f) }
    }
    
    @inlinable @inline(__always)
    mutating func max_right(_ op: Op,_ e: E,_ mapping: Mapping,_ composition: Composition,_ id: Id,_ l: Int,_ g: (S) -> Bool) -> Int {
        __update{ $0.max_right(op, e, mapping, composition, id, l, g) }
    }
    
    @inlinable @inline(__always)
    mutating func min_left(_ op: Op,_ e: E,_ mapping: Mapping,_ composition: Composition,_ id: Id,_ r: Int,_ g: (S) -> Bool) -> Int {
        __update{ $0.min_left(op, e, mapping, composition, id, r, g) }
    }
}

