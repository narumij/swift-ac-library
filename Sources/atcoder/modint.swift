import Foundation

public struct modint_base_static<bt: static_mod>: modint_implementation {
    public init() { self.init(0) }
    public init<T: FixedWidthInteger>(_ v: T) {
        _v = Self.value(v)
    }
    var _v: CUnsignedInt
}

extension modint_base_static {
    public init(unsigned: UInt32) { self.init(unsigned) }
    public var unsigned: CInt.Magnitude { val() }
}

extension modint_base_static: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: CInt) {
        self.init(value)
    }
}

public protocol modint_base_protocol: AdditiveArithmetic, Equatable, ExpressibleByIntegerLiteral, ToUnsigned {
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

extension modint_base_protocol {
    public typealias mint = Self
}

public protocol modint_dynamic_protocol: modint_base_protocol {
    static func set_mod(_ m: CInt)
}

protocol modint_implementation: modint_base_protocol, CustomStringConvertible {
    associatedtype bt: mod_type
    init()
    init<T: FixedWidthInteger>(_ v: T)
    var _v: CUnsignedInt { get set }
}

extension modint_implementation {
    
    public static func mod() -> CInt { return CInt(bitPattern: bt.umod()); }
    
    public static func raw(_ v: CInt) -> mint {
        var x = mint();
        x._v = CUnsignedInt(bitPattern: v);
        return x;
    }

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

protocol modint_dynamic_implementation: modint_implementation & modint_dynamic_protocol where bt: dynamic_mod { }

extension modint_dynamic_implementation {
    public static func set_mod(_ m: CInt) {
        bt.set_mod(m)
    }
}

extension modint_implementation {
    static func value<T: FixedWidthInteger>(_ v: T) -> CUnsignedInt {
        var x = v % T(Self.mod());
        if (x < 0) { x += T(Self.mod()); }
        return CUnsignedInt(x);
    }
}

public struct modint_base_dynamic<bt: dynamic_mod>: modint_dynamic_implementation {
    public init() { self.init(0) }
    public init<T: FixedWidthInteger>(_ v: T) {
        _v = Self.value(v)
    }
    var _v: CUnsignedInt
}

extension modint_base_dynamic {
    public init(unsigned: UInt32) { self.init(unsigned) }
    public var unsigned: CInt.Magnitude { val() }
}


extension modint_base_dynamic: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: CInt) {
        self.init(value)
    }
}

struct modint_base<bt: mod_type>: modint_implementation {
    init() { self.init(0) }
    init<T: FixedWidthInteger>(_ v: T) {
        _v = Self.value(v)
    }
    var _v: CUnsignedInt
}

extension modint_base {
    init(unsigned: UInt32) { self.init(unsigned) }
    var unsigned: CInt.Magnitude { val() }
}

extension modint_base: ExpressibleByIntegerLiteral {
    init(integerLiteral value: CInt) {
        self.init(value)
    }
}

public typealias modint998244353 = modint_base_static<mod_998244353>
public typealias modint1000000007 = modint_base_static<mod_1000000007>
public typealias static_modint = modint_base_static
public typealias dynamic_modint = modint_base_dynamic<mod_dynamic>
public typealias modint = dynamic_modint

