import Foundation

public protocol modint_base: AdditiveArithmetic, Hashable, ExpressibleByIntegerLiteral, CustomStringConvertible, ToUnsigned {
    static func mod() -> CInt
    static func raw(_ v: CInt) -> mint
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

protocol modint_internal: modint_base {
    associatedtype bt: mod_type
    var _v: CUnsignedInt { get set }
}

extension modint_internal {

    public static func mod() -> CInt { return CInt(bitPattern: bt.umod()); }
    
    public static func raw(_ v: CInt) -> mint {
        var x = mint();
        x._v = CUnsignedInt(bitPattern: v);
        return x;
    }
    
    public init() { self.init(0) }
    public init(_ v: Bool) {
        self.init(CInt(v ? 1 : 0))
    }

    public func val() -> CUnsignedInt { return _v; }
    
    public static func + (lhs: mint, rhs: mint) -> mint {
        var _v = lhs._v &+ rhs._v
        if (_v >= umod()) { _v -= umod(); }
        return Self.raw(CInt(bitPattern: _v))
    }
    public static func - (lhs: mint, rhs: mint) -> mint {
        var _v = lhs._v &+ CUnsignedInt(bitPattern: mod()) &- rhs._v
        if (_v >= umod()) { _v -= umod(); }
        return Self.raw(CInt(bitPattern: _v))
    }
    public static func * (lhs: mint, rhs: mint) -> mint {
        let _v = bt.mul(lhs._v, rhs._v);
        return Self.raw(CInt(bitPattern: _v))
    }
    public static func / (lhs: mint, rhs: mint) -> mint {
        lhs * rhs.inv()
    }
    public static func +=(lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    public static func -=(lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
   }
    public static func *=(lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    public static func /=(lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    public static prefix func + (_ m: Self) -> Self {
        return m
    }
    public static prefix func - (_ m: Self) -> Self {
        return Self() - m
    }

    public func pow(_ n: CLongLong) -> mint {
        assert(0 <= n);
        var n = n
        var x = self, r: Self = Self.init(CInt(1));
        while ((n) != 0) {
            if ((n & 1) != 0) { r *= x; }
            x *= x;
            n >>= 1;
        }
        return r;
    }
    
    public func inv() -> mint {
        let eg = _internal.inv_gcd(CLongLong(_v), CLongLong(Self.mod()));
        assert(eg.first == 1);
        return Self.init(CInt(eg.second));
    }
    
    static func umod() -> CUnsignedInt { return bt.umod(); }
    
    public var description: String { val().description }
}

extension modint_internal {
    public init(unsigned: UInt32) { self.init(unsigned) }
    public var unsigned: CInt.Magnitude { val() }
}

extension modint_internal {
    public init(integerLiteral value: CInt) {
        self.init(value)
    }
}

fileprivate extension modint_internal {
    static func _value<T: FixedWidthInteger>(_ v: T) -> CUnsignedInt {
        var x = v % T(Self.mod());
        if (x < 0) { x += T(Self.mod()); }
        return CUnsignedInt(x);
    }
}

public struct static_modint<bt: static_mod>: static_modint_base & modint_internal {
    public init<T: FixedWidthInteger>(_ v: T) {
        _v = Self._value(v)
    }
    var _v: CUnsignedInt
}

public struct dynamic_modint: dynamic_modint_base & modint_internal {
    typealias bt = mod_dynamic
    public init<T: FixedWidthInteger>(_ v: T) {
        _v = Self._value(v)
    }
    var _v: CUnsignedInt
    public static func set_mod(_ m: CInt) {
        bt.set_mod(m)
    }
}

public typealias modint998244353 = static_modint<mod_998244353>
public typealias modint1000000007 = static_modint<mod_1000000007>
public typealias modint = dynamic_modint

// MARK: -

struct internal_modint<bt: mod_type>: modint_internal {
    init<T: FixedWidthInteger>(_ v: T) {
        _v = Self._value(v)
    }
    var _v: CUnsignedInt
}
