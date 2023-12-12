import Foundation

public protocol _SegtreeProtocol {
    associatedtype S
    static var op: (S,S) -> S { get }
    static var e: S { get }
}

public protocol SegtreeProtocol: _SegtreeProtocol {
    var storage: Storage { get set }
    init(storage: Storage)
}

extension SegtreeProtocol {
    public typealias Storage = ManagedBufferSegtree<Self>._Storage
    init() { self.init(0) }
    init<Index: FixedWidthInteger>(_ n: Index) {
        self.init(storage: Storage(n: Int(n)))
    }
    init(_ v: [S]) {
        self.init(storage: Storage(v))
    }
}

public enum ManagedBufferSegtree<Base: _SegtreeProtocol> { }

extension ManagedBufferSegtree {
    
    public
    struct _BufferHeader {
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
    
    @usableFromInline
    class _Buffer: ManagedBuffer<_BufferHeader, Base.S> {
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
        init(_buffer: _BufferPointer) { self._buffer = _buffer }
        
        @inlinable @inline(__always)
        init(_ object: _Buffer) {
            self.init(_buffer: _BufferPointer(unsafeBufferObject: object))
        }

        @inlinable @inline(__always)
        init(n: Int) {
            let _n = n
            let size: Int = _internal.bit_ceil(CUnsignedInt(_n))
            let log: Int = _internal.countr_zero(CUnsignedInt(size))
            let count = 2 * size
            let object = _Buffer.create(minimumCapacity: count) {
                _BufferHeader(capacity: $0.capacity, count: count, _n: _n, size: size, log: log) }
            self.init(_buffer: _BufferPointer(unsafeBufferObject: object))
            _buffer.withUnsafeMutablePointerToElements { elements in
                elements.initialize(repeating: Base.e, count: count)
            }
        }

        @inlinable @inline(__always)
        init(_ v: [S]) {
            let _n = v.count
            let size: Int = _internal.bit_ceil(CUnsignedInt(_n))
            let log: Int = _internal.countr_zero(CUnsignedInt(size))
            let count = 2 * size
            let object = _Buffer.create(minimumCapacity: count) {
                _BufferHeader(capacity: $0.capacity, count: count, _n: _n, size: size, log: log) }
            self.init(_buffer: _BufferPointer(unsafeBufferObject: object))
            _buffer.withUnsafeMutablePointerToElements { elements in
                v.withUnsafeBufferPointer { v in
                    (elements + size).initialize(from: v.baseAddress!, count: _n)
                }
                elements.initialize(repeating: Base.e, count: size)
                (elements + size + _n).initialize(repeating: Base.e, count: size - _n)
            }
            __update {
                for i in stride(from: $0.size - 1, through: 1, by: -1) { $0.update(i) }
            }
        }

        public typealias _BufferPointer = ManagedBufferPointer<_BufferHeader, Base.S>
        public var _buffer: _BufferPointer
        
        @inlinable @inline(__always)
        public var capacity: Int { _buffer.header.capacity }
        
        @inlinable @inline(__always)
        public var count: Int { _buffer.header.count }
        
        @inlinable @inline(__always)
        public func __read<R>(_ body: (_UnsafeHandle) -> R) -> R {
            _buffer.withUnsafeMutablePointers{ _header, _elements in
                let handle = _UnsafeHandle(_header: _header, _elements: _elements)
                return body(handle)
            }
        }
        
        @inlinable @inline(__always)
        public mutating func __update<R>(_ body: (_UnsafeHandle) -> R) -> R {
            _buffer.withUnsafeMutablePointers{ _header, _elements in
                let handle = _UnsafeHandle(_header: _header, _elements: _elements)
                return body(handle)
            }
        }
    }
}

extension ManagedBufferSegtree._BufferHeader { }

extension ManagedBufferSegtree {
    
    public
    struct _UnsafeHandle {
        
        public typealias S = Base.S
        
        @inlinable @inline(__always)
        public func op(_ l: S,_ r: S) -> S { Base.op(l,r) }
        
        @inlinable @inline(__always)
        public func e() -> S { Base.e }

        @inlinable @inline(__always)
        init(_header: UnsafeMutablePointer<_BufferHeader>,
             _elements: UnsafeMutablePointer<Base.S>) {
            self._header = _header
            self.d = _elements
        }

        public var _header: UnsafeMutablePointer<_BufferHeader>
        public var d: UnsafeMutablePointer<Base.S>
        public var _n: Int { _header.pointee._n }
        public var size: Int { _header.pointee.size }
        public var log: Int { _header.pointee.log }
    }
}

extension ManagedBufferSegtree {
    public typealias S = Base.S
}

extension ManagedBufferSegtree._UnsafeHandle {
    
    public func set<Index: FixedWidthInteger>(_ p: Index,_ x: S) {
        var p = Int(p)
        assert(0 <= p && p < _n);
        p += size;
        (d + p).pointee = x;
        // for (int i = 1; i <= log; i++) update(p >> i);
        for _ in 0 ..< log { p >>= 1; update(p) }
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
            if (l & 1) != 0 { sml = op(sml, (d + l).pointee); l += 1 }
            if (r & 1) != 0 { r -= 1; smr = op((d + r).pointee, smr); }
            l >>= 1;
            r >>= 1;
        }
        return op(sml, smr);
    }
    
    public func all_prod() -> S { (d + 1).pointee }
    
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
    
    @usableFromInline
    func update(_ k: Int) {
        (d + k).pointee = op( (d + k + k).pointee, (d + k + k + 1).pointee)
    }
}

extension SegtreeProtocol {
    
    public mutating func set<Index: FixedWidthInteger>(_ p: Index,_ x: S) {
        storage.__update{ $0.set(p, x) }
    }
    
    public func get<Index: FixedWidthInteger>(_ p: Index) -> S {
        storage.__read { $0.get(p) }
    }

    public func prod<Index: FixedWidthInteger>(_ l: Index,_ r: Index) -> S {
        storage.__read { $0.prod(l, r) }
    }
    
    public func all_prod() -> S {
        storage.__read { $0.all_prod() }
    }
    
    public func max_right<Index: FixedWidthInteger>(_ l: Index,_ f: (S) -> Bool) -> Int {
        storage.__read { $0.max_right(l, f) }
    }
    
    public func min_left<Index: FixedWidthInteger>(_ r: Index,_ f: (S) -> Bool ) -> Int {
        storage.__read { $0.min_left(r, f) }
    }
}

extension ManagedBufferSegtree._Storage {
    
    var array: [Base.S] {
        (0..<count).map{ self[$0] }
    }
    
    subscript(index: Int) -> Base.S {
        get { _buffer.withUnsafeMutablePointerToElements{ $0[index] } }
        nonmutating set { _buffer.withUnsafeMutablePointerToElements{ $0[index] = newValue } }
    }
}
