import Foundation

public protocol modint_base: AdditiveArithmetic, Hashable, ExpressibleByIntegerLiteral, CustomStringConvertible, ToUnsigned {
    static func mod() -> CInt
    init()
    init(_ v: Bool)
    init<T: FixedWidthInteger>(_ v: T)
    func val() -> CUnsignedInt
    static func +(lhs: mint, rhs: mint) -> mint
    static func -(lhs: mint, rhs: mint) -> mint
    static func *(lhs: mint, rhs: mint) -> mint
    static func /(lhs: mint, rhs: mint) -> mint
    static func +=(lhs: inout mint, rhs: mint)
    static func -=(lhs: inout mint, rhs: mint)
    static func *=(lhs: inout mint, rhs: mint)
    static func /=(lhs: inout mint, rhs: mint)
    static prefix func + (_ m: Self) -> Self
    static prefix func - (_ m: Self) -> Self
    func pow(_ n: CLongLong) -> mint
    func inv() -> mint
}

extension modint_base {
    public typealias mint = Self
}

public protocol static_modint_base: modint_base { }

public protocol dynamic_modint_base: modint_base {
    static func set_mod(_ m: CInt)
}

public protocol internal_modint: modint_base {
    init(raw: CUnsignedInt)
    var _v: CUnsignedInt { get set }
}

public struct static_modint<m: static_mod>: static_modint_base, internal_modint {
    public init(raw v: CUnsignedInt) {
        _v = v;
    }
    public var _v: CUnsignedInt
}

public extension static_modint {
    var isPrime: Bool { m.isPrime }

    static func mod() -> CInt { return CInt(bitPattern: m.umod); }
    
    init() { self.init(raw: 0) }
    init(_ v: Bool) { self.init(v ? 1 : 0) }
    init<T: FixedWidthInteger>(_ v: T) { self.init(raw: Self._value(v)) }

    func val() -> CUnsignedInt { return _v; }
    
    typealias ULL = CUnsignedLongLong
    typealias UINT = CUnsignedInt

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
        z *= ULL(rhs._v);
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
        z *= ULL(rhs._v);
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
            return pow(CLongLong(Self.umod()) - 2);
        } else {
            let eg = _internal.inv_gcd(CLongLong(_v), CLongLong(m.m));
            assert(eg.first == 1);
            return Self.init(CInt(eg.second));
        }
    }
    
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

    public static func mod() -> CInt { return CInt(bitPattern: bt.umod); }
    public func mod() -> CInt { return Self.mod(); }

    public init() { self.init(raw: 0) }
    public init(_ v: Bool) { self.init(v ? 1 : 0) }
    public init<T: FixedWidthInteger>(_ v: T) { self.init(raw: Self._value(v)) }

    public func val() -> CUnsignedInt { return _v; }
    
    public static func +=(lhs: inout Self, rhs: Self) {
        lhs._v &+= rhs._v
        if (lhs._v >= umod()) { lhs._v -= umod(); }
    }
    public static func -=(lhs: inout Self, rhs: Self) {
        lhs._v &+= umod() &- rhs._v
        if (lhs._v >= umod()) { lhs._v -= umod(); }
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
        if (_v >= umod()) { _v -= umod(); }
        return .init(raw:_v)
    }
    public static func - (lhs: mint, rhs: mint) -> mint {
        var _v = lhs._v &+ umod() &- rhs._v
        if (_v >= umod()) { _v -= umod(); }
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
        let eg = _internal.inv_gcd(CLongLong(_v), CLongLong(mod()));
        assert(eg.first == 1);
        return .init(CInt(eg.second));
    }
    
    static func umod() -> CUnsignedInt { return bt.umod; }
}

public typealias modint998244353 = static_modint<mod_998_244_353>
public typealias modint1000000007 = static_modint<mod_1_000_000_007>
public typealias modint = dynamic_modint

// MARK: -

extension internal_modint {
    public init(integerLiteral value: CInt) {
        self.init(raw: Self._value(value))
    }
    public init(unsigned: UInt32) { self.init(unsigned) }
    public var unsigned: CInt.Magnitude { val() }
    public var description: String { val().description }
}

fileprivate extension internal_modint {
    static func _value<T: FixedWidthInteger>(_ v: T) -> CUnsignedInt {
        if 0 < Self.mod(), (0 ..< T(Self.mod())).contains(v) {
            return CUnsignedInt(v)
        }
        var x = v % T(mod());
        if (x < 0) { x += T(mod()); }
        return CUnsignedInt(x);
    }
}

