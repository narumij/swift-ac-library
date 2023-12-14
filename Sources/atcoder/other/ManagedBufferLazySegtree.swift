import Foundation

public protocol _LazySegtree {
    associatedtype S
    static var op: (S,S) -> S { get }
    static var e: S { get }
    associatedtype F
    static var mapping: (F,S) -> S { get }
    static var composition: (F,F) -> F { get }
    static var id: F { get }
}

public protocol LazySegtreeProtocol: _LazySegtree {
    init(storage: Storage)
    var storage: Storage { get set }
}

extension LazySegtreeProtocol {
    public typealias Storage = ManagedBufferLazySegtree<Self>._Storage
    init() { self.init(0) }
    init<Index: FixedWidthInteger>(_ n: Index) {
        self.init(storage: Storage(n: Int(n)))
    }
    init(_ v: [S]) {
        self.init(storage: Storage(v))
    }
}

public enum ManagedBufferLazySegtree<Base: _LazySegtree> {
    public typealias S = Base.S
}

extension ManagedBufferLazySegtree {
    
    public
    struct _DataBufferHeader {
        @inlinable @inline(__always)
        internal init(capacity: Int, count: Int, _n: Int, size: Int, log: Int) {
            self.capacity = capacity
            self.count = count
            self._n = _n
            self.size = size
            self.log = log
        }
        public let capacity: Int
        public let count: Int
        public let _n, size, log: Int
    }
    
    public
    struct _LazyBufferHeader {
        @inlinable @inline(__always)
        internal init(capacity: Int, count: Int) {
            self.capacity = capacity
            self.count = count
        }
        public let capacity: Int
        public let count: Int
    }
    
    @usableFromInline
    class _DataBuffer: ManagedBuffer<_DataBufferHeader, Base.S> {
        deinit {
            let count = header.count
            withUnsafeMutablePointers {
                (pointerToHeader, pointerToElements) -> Void in
                pointerToElements.deinitialize(count: count)
                pointerToHeader.deinitialize(count: 1)
            }
        }
    }
    
    @usableFromInline
    class _LazyBuffer: ManagedBuffer<_LazyBufferHeader, Base.F> {
        deinit {
            let count = header.count
            withUnsafeMutablePointers {
                (pointerToHeader, pointerToElements) -> Void in
                pointerToElements.deinitialize(count: count)
                pointerToHeader.deinitialize(count: 1)
            }
        }
    }
    
    public struct _Storage {
        
        @inlinable @inline(__always)
        init(_data_buffer: _DataBufferPointer, _lazy_buffer: _LazyBufferPointer) {
            self._data_buffer = _data_buffer
            self._lazy_buffer = _lazy_buffer
        }
        
        @inlinable @inline(__always)
        init(_ dataObject: _DataBuffer, _ lazyObject: _LazyBuffer) {
            self.init(
                _data_buffer: _DataBufferPointer(unsafeBufferObject: dataObject),
                _lazy_buffer: _LazyBufferPointer(unsafeBufferObject: lazyObject)
            )
        }

        @inlinable @inline(__always)
        init(n: Int) {
            let _n = n
            let size: Int = _internal.bit_ceil(CUnsignedInt(_n))
            let log: Int = _internal.countr_zero(CUnsignedInt(size))
            let count = 2 * size
            let dataObject = _DataBuffer.create(minimumCapacity: count) {
                _DataBufferHeader(capacity: $0.capacity, count: count, _n: _n, size: size, log: log) }
            let lazyObject = _LazyBuffer.create(minimumCapacity: size) {
                _LazyBufferHeader(capacity: $0.capacity, count: size) }
            self.init(_data_buffer: _DataBufferPointer(unsafeBufferObject: dataObject),
                      _lazy_buffer: _LazyBufferPointer(unsafeBufferObject: lazyObject))
            _data_buffer.withUnsafeMutablePointerToElements { elements in
                elements.initialize(repeating: Base.e, count: count)
            }
            _lazy_buffer.withUnsafeMutablePointerToElements { elements in
                elements.initialize(repeating: Base.id, count: size)
            }
        }

        @inlinable @inline(__always)
        init(_ v: [S]) {
            let _n = v.count
            let size: Int = _internal.bit_ceil(CUnsignedInt(_n))
            let log: Int = _internal.countr_zero(CUnsignedInt(size))
            let count = 2 * size
            let dataObject = _DataBuffer.create(minimumCapacity: count) {
                _DataBufferHeader(capacity: $0.capacity, count: count, _n: _n, size: size, log: log) }
            let lazyObject = _LazyBuffer.create(minimumCapacity: size) {
                _LazyBufferHeader(capacity: $0.capacity, count: size) }
            self.init(_data_buffer: _DataBufferPointer(unsafeBufferObject: dataObject),
                      _lazy_buffer: _LazyBufferPointer(unsafeBufferObject: lazyObject))
            _data_buffer.withUnsafeMutablePointerToElements { elements in
                v.withUnsafeBufferPointer { v in
                    (elements + size).initialize(from: v.baseAddress!, count: _n)
                }
                elements.initialize(repeating: Base.e, count: size)
                (elements + size + _n).initialize(repeating: Base.e, count: size - _n)
            }
            _lazy_buffer.withUnsafeMutablePointerToElements { elements in
                elements.initialize(repeating: Base.id, count: size)
            }
            __update {
                for i in stride(from: $0.size - 1, through: 1, by: -1) { $0.update(i) }
            }
        }

        public typealias _DataBufferPointer = ManagedBufferPointer<_DataBufferHeader, Base.S>
        public var _data_buffer: _DataBufferPointer
        
        public typealias _LazyBufferPointer = ManagedBufferPointer<_LazyBufferHeader, Base.F>
        public var _lazy_buffer: _LazyBufferPointer
        
        @inlinable @inline(__always)
        public var capacity: Int { _data_buffer.header.capacity }
        
        @inlinable @inline(__always)
        public var count: Int { _data_buffer.header.count }
        
        @inlinable @inline(__always)
        public func __read<R>(_ body: (_UnsafeHandle) -> R) -> R {
            _data_buffer.withUnsafeMutablePointers{ _header, _elements in
                _lazy_buffer.withUnsafeMutablePointerToElements { _lazy in
                    let handle = _UnsafeHandle(_header: _header, _elements: _elements, _lazy: _lazy)
                    return body(handle)
                }
            }
        }
        
        @inlinable @inline(__always)
        public mutating func __update<R>(_ body: (_UnsafeHandle) -> R) -> R {
            _data_buffer.withUnsafeMutablePointers{ _header, _elements in
                _lazy_buffer.withUnsafeMutablePointerToElements { _lazy in
                    let handle = _UnsafeHandle(_header: _header, _elements: _elements, _lazy: _lazy)
                    return body(handle)
                }
            }
        }
    }
}

extension ManagedBufferLazySegtree {
    
    public
    struct _UnsafeHandle {
        
        @inlinable @inline(__always)
        init(_header: UnsafeMutablePointer<_DataBufferHeader>,
             _elements: UnsafeMutablePointer<Base.S>,
             _lazy: UnsafeMutablePointer<Base.F>) {
            self._header = _header
            self.d = _elements
            self.lz = _lazy
        }
        
        @usableFromInline var _header: UnsafeMutablePointer<_DataBufferHeader>
        @usableFromInline let d: UnsafeMutablePointer<Base.S>
        @usableFromInline let lz: UnsafeMutablePointer<Base.F>
        
        public var _n: Int { _header.pointee._n }
        public var size: Int { _header.pointee.size }
        public var log: Int { _header.pointee.log }

        public typealias S = Base.S
        func op(_ l: S,_ r: S) -> S { Base.op(l,r) }
        func e() -> S { Base.e }
        
        public typealias F = Base.F
        func mapping(_ l: F,_ r: S) -> S { Base.mapping(l,r) }
        func composition(_ l: F,_ r: F) -> F { Base.composition(l,r) }
        func id() -> F { Base.id }
    }
}

extension ManagedBufferLazySegtree._UnsafeHandle {
    
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
    
    public func update(_ k: Int) { d[k] = op(d[2 * k], d[2 * k + 1]); }
    
    func all_apply(_ k: Int,_ f: F) {
        d[k] = mapping(f, d[k]);
        if (k < size) { lz[k] = composition(f, lz[k]); }
    }
    
    func push(_ k: Int) {
        all_apply(2 * k, lz[k]);
        all_apply(2 * k + 1, lz[k]);
        lz[k] = id();
    }
}

public extension LazySegtreeProtocol {
    mutating func set<Index>(_ p: Index,_ x: S)
    where Index: FixedWidthInteger
    {
        storage.__update{ $0.set(Int(p),x) }
    }
    mutating func get<Index>(_ p: Index) -> S
    where Index: FixedWidthInteger
    {
        storage.__update{ $0.get(Int(p)) }
    }
    mutating func prod<Index>(_ l: Index,_ r: Index) -> S
    where Index: FixedWidthInteger
    {
        storage.__update{ $0.prod(Int(l), Int(r)) }
    }
    func all_prod() -> S
    {
        storage.__read{ $0.all_prod() }
    }
    mutating func apply<Index>(_ p: Index,_ f: F)
    where Index: FixedWidthInteger
    {
        storage.__update{ $0.apply(Int(p), f) }
    }
    mutating func apply<Index>(_ l: Index,_ r: Index,_ f: F)
    where Index: FixedWidthInteger
    {
        storage.__update{ $0.apply(Int(l), Int(r), f) }
    }
    mutating func max_right<Index>(_ l: Index,_ g: (S) -> Bool) -> Int
    where Index: FixedWidthInteger
    {
        storage.__update{ $0.max_right(Int(l), g) }
    }
    mutating func min_left<Index>(_ r: Index,_ g: (S) -> Bool) -> Int
    where Index: FixedWidthInteger
    {
        storage.__update{ $0.min_left(Int(r), g) }
    }
}
