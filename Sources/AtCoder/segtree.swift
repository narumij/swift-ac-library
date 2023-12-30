import Foundation

public protocol _SegtreeProtocol {
    associatedtype S
    static var op: (S,S) -> S { get }
    static var e: S { get }
}

public protocol SegtreeProtocol: _SegtreeProtocol {
    init(storage: Storage)
    var storage: Storage { get set }
}

public extension SegtreeProtocol {
    typealias Storage = _Segtree<Self>._Storage
    init() { self.init(0) }
    init(_ n: Int) {
        self.init(storage: Storage(_n: n))
    }
    init<V: Collection>(_ v: V) where V.Element == S, V.Index == Int {
        self.init(storage: Storage(v))
    }
}

public enum _Segtree<Base: _SegtreeProtocol> {
    public typealias S = Base.S
}

extension _Segtree {
    
    @usableFromInline
    class _Buffer {
        @usableFromInline
        init(_n: Int, size: Int, log: Int, d: [Base.S]) {
            self._n = _n
            self.size = size
            self.log = log
            self.d = d
        }
        @usableFromInline let _n, size, log: Int
        @usableFromInline var d: [S]
    }
    
    public struct _Storage {
        
        @inlinable @inline(__always)
        init(_buffer: _Buffer) {
            self._buffer = _buffer
        }
        
        @inlinable @inline(__always)
        init(_n: Int) {
            self.init([S](repeating: Base.e, count: _n))
        }

        @inlinable @inline(__always)
        init<V: Collection>(_ v: V) where V.Element == S, V.Index == Int {
            let _n = v.count
            let size: Int = _internal.bit_ceil(UInt64(_n))
            let log: Int = _internal.countr_zero(UInt64(size))
            let buffer = _Buffer(
                _n: _n,
                size: size,
                log: log,
                d: [S](repeating: Base.e, count: 2 * size)
            )
            self.init(_buffer: buffer)
            __update {
                for i in 0..<_n { $0.d[size + i] = v[i] }
                for i in stride(from: $0.size - 1, through: 1, by: -1) { $0.update(i) }
            }
        }

        @usableFromInline var _buffer: _Buffer
        
        @inlinable @inline(__always)
        func __read<R>(_ body: (_UnsafeHandle) -> R) -> R {
            _buffer.d.withUnsafeMutableBufferPointer{ d in
                let handle = _UnsafeHandle(_n: _buffer._n, size: _buffer.size, log: _buffer.log, d: d.baseAddress!)
                return body(handle)
            }
        }
        
        @inlinable @inline(__always)
        mutating func __update<R>(_ body: (_UnsafeHandle) -> R) -> R {
            _buffer.d.withUnsafeMutableBufferPointer{ d in
                let handle = _UnsafeHandle(_n: _buffer._n, size: _buffer.size, log: _buffer.log, d: d.baseAddress!)
                return body(handle)
            }
        }
    }
}

extension _Segtree {
    
    @usableFromInline
    struct _UnsafeHandle {
        
        @inlinable @inline(__always)
        init(_n: Int, size: Int, log: Int, d: UnsafeMutablePointer<Base.S>) {
            self._n = _n
            self.size = size
            self.log = log
            self.d = d
        }
        
        @usableFromInline let _n, size, log: Int
        @usableFromInline let d: UnsafeMutablePointer<Base.S>
        
        typealias S = Base.S
        let op: (S,S) -> S = { Base.op }()
        func e() -> S { Base.e }
    }
}

extension _Segtree._UnsafeHandle {
    
    func set(_ p: Int,_ x: S) {
        var p = p
        assert(0 <= p && p < _n);
        p += size;
        d[p] = x;
        for i in stride(from: 1, through: log, by: 1) { update(p >> i); }
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
    
    @usableFromInline
    func update(_ k: Int) {
        d[k] = op(d[2 * k], d[2 * k + 1])
    }
}

public extension SegtreeProtocol {
    
    mutating func set(_ p: Int,_ x: S) {
        storage.__update{ $0.set(p, x) }
    }
    func get(_ p: Int) -> S {
        storage.__read { $0.get(p) }
    }
    func prod(_ l: Int,_ r: Int) -> S {
        storage.__read { $0.prod(l, r) }
    }
    func all_prod() -> S {
        storage.__read { $0.all_prod() }
    }
    func max_right(_ l: Int,_ f: (S) -> Bool) -> Int {
        storage.__read { $0.max_right(l, f) }
    }
    func min_left(_ r: Int,_ f: (S) -> Bool ) -> Int {
        storage.__read { $0.min_left(r, f) }
    }
}
