import Foundation

public protocol static_modint_base: modint_base { }

public protocol dynamic_modint_base: modint_base {
    static func set_mod(_ m: CInt)
}

public protocol internal_modint: modint_base {
    init(raw: CUnsignedInt)
    var _v: CUnsignedInt { get set }
    static func umod() -> CUnsignedInt
}

extension internal_modint {
    typealias ULL = CUnsignedLongLong
    typealias LL = CLongLong
    typealias UINT = CUnsignedInt
}

public struct static_modint<m: static_mod>: static_modint_base, internal_modint {
    public init(raw v: CUnsignedInt) {
        _v = v;
    }
    public var _v: CUnsignedInt
}

public extension static_modint {
    var isPrime: Bool { m.isPrime }

    @inlinable @inline(__always)
    static func mod() -> CInt { return CInt(bitPattern: m.umod); }
    
    init() { self.init(raw: 0) }
    init(_ v: Bool) { self.init(raw: Self._v(uint: v ? 1 : 0)) }
    init(_ v: CInt) { self.init(raw: Self._v(int: v)) }
    init<T: FixedWidthInteger>(_ v: T) { self.init(raw: Self._v(v)) }

    func val() -> CUnsignedInt { return _v; }
    
    static func +=(lhs: inout Self, rhs: Self) {
        lhs._v &+= rhs._v
        if (lhs._v >= umod()) { lhs._v &-= umod(); }
    }
    static func -=(lhs: inout Self, rhs: Self) {
        lhs._v &-= rhs._v
        if (lhs._v >= umod()) { lhs._v &+= umod(); }
   }
    static func *=(lhs: inout Self, rhs: Self) {
        var z: ULL = ULL(lhs._v);
        z &*= ULL(rhs._v);
        lhs._v = UINT(z % ULL(umod()));
    }
    static func /=(lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs.inv()
    }
    static prefix func + (_ m: Self) -> Self {
        return m
    }
    static prefix func - (_ m: Self) -> Self {
        return .init(raw: 0) - m
    }
    static func + (lhs: mint, rhs: mint) -> mint {
        var _v = lhs._v &+ rhs._v
        if (_v >= umod()) { _v &-= umod(); }
        return .init(raw:_v)
    }
    static func - (lhs: mint, rhs: mint) -> mint {
        var _v = lhs._v &- rhs._v
        if (_v >= umod()) { _v &+= umod(); }
        return .init(raw:_v)
    }
    static func * (lhs: mint, rhs: mint) -> mint {
        var z: ULL = ULL(lhs._v);
        z &*= ULL(rhs._v);
        return .init(raw: UINT(z % ULL(umod())));
    }
    static func / (lhs: mint, rhs: mint) -> mint {
        lhs * rhs.inv()
    }
    
    func pow(_ n: CLongLong) -> mint {
        assert(0 <= n);
        var n = n
        var x = self, r: Self = .init(raw: 1);
        while ((n) != 0) {
            if ((n & 1) != 0) { r *= x; }
            x *= x;
            n >>= 1;
        }
        return r;
    }
    
    func inv() -> mint {
        if isPrime {
            assert(_v != 0);
            return pow(LL(Self.umod()) - 2);
        } else {
            let eg = _internal.inv_gcd(LL(_v), LL(m.m));
            assert(eg.first == 1);
            return Self.init(CInt(eg.second));
        }
    }
    
    @inlinable @inline(__always)
    static func umod() -> CUnsignedInt { m.umod }
}

public struct dynamic_modint: dynamic_modint_base & internal_modint {
    public typealias bt = mod_dynamic
    public init(raw v: CUnsignedInt) {
        _v = v;
    }
    public var _v: CUnsignedInt
    public static func set_mod(_ m: CInt) {
        bt.set_mod(m)
    }
}

extension dynamic_modint {

    @inlinable @inline(__always)
    public static func mod() -> CInt { return CInt(bitPattern: bt.umod); }
    
    public init() { self.init(raw: 0) }
    public init(_ v: Bool) { self.init(raw: Self._v(uint: v ? 1 : 0)) }
    public init(_ v: CInt) { self.init(raw: Self._v(int: v)) }
    public init<T: FixedWidthInteger>(_ v: T) { self.init(raw: Self._v(v)) }

    public func val() -> CUnsignedInt { return _v; }
    
    public static func +=(lhs: inout Self, rhs: Self) {
        lhs._v &+= rhs._v
        if (lhs._v >= umod()) { lhs._v &-= umod(); }
    }
    public static func -=(lhs: inout Self, rhs: Self) {
        lhs._v &+= umod() &- rhs._v
        if (lhs._v >= umod()) { lhs._v &-= umod(); }
   }
    public static func *=(lhs: inout Self, rhs: Self) {
        lhs._v = bt.mul(lhs._v, rhs._v);
    }
    public static func /=(lhs: inout Self, rhs: Self) {
        lhs *= rhs.inv()
    }
    public static prefix func + (_ m: Self) -> Self {
        return m
    }
    public static prefix func - (_ m: Self) -> Self {
        return .init(raw: 0) - m
    }
    public static func + (lhs: mint, rhs: mint) -> mint {
        var _v = lhs._v &+ rhs._v
        if (_v >= umod()) { _v &-= umod(); }
        return .init(raw:_v)
    }
    public static func - (lhs: mint, rhs: mint) -> mint {
        var _v = lhs._v &+ umod() &- rhs._v
        if (_v >= umod()) { _v &-= umod(); }
        return .init(raw:_v)
    }
    public static func * (lhs: mint, rhs: mint) -> mint {
        let _v = bt.mul(lhs._v, rhs._v);
        return .init(raw:_v)
    }
    public static func / (lhs: mint, rhs: mint) -> mint {
        lhs * rhs.inv()
    }

    public func pow(_ n: CLongLong) -> mint {
        assert(0 <= n);
        var n = n
        var x = self, r: Self = .init(raw: 1);
        while ((n) != 0) {
            if ((n & 1) != 0) { r *= x; }
            x *= x;
            n >>= 1;
        }
        return r;
    }
    
    public func inv() -> mint {
        let eg = _internal.inv_gcd(LL(_v), LL(Self.mod()));
        assert(eg.first == 1);
        return .init(CInt(eg.second));
    }
    
    @inlinable @inline(__always)
    public static func umod() -> CUnsignedInt { return bt.umod; }
}

public typealias modint998244353 = static_modint<mod_998_244_353>
public typealias modint1000000007 = static_modint<mod_1_000_000_007>
public typealias modint = dynamic_modint

// MARK: -

extension internal_modint {
    @inlinable @inline(__always)
    public init(integerLiteral value: CInt) {
        self.init(raw: Self._v(int: value))
    }
}

extension internal_modint {
    @usableFromInline static func _v<T: FixedWidthInteger>(_ v: T) -> CUnsignedInt {
        // 整数のキャストが意外と重たいため、分けている
        var x = v % T(mod());
        if (x < 0) { x += T(mod()); }
        return UINT(bitPattern: CInt(x));
    }
    @usableFromInline static func _v(uint v: CUnsignedInt) -> CUnsignedInt {
        return v % umod();
    }
    @usableFromInline static func _v(int v: CInt) -> CUnsignedInt {
        var x = v % mod();
        if (x < 0) { x += mod(); }
        return UINT(bitPattern: x);
    }
}

