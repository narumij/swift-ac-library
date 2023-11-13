import Foundation

// AC - https://atcoder.jp/contests/practice2/submissions/47530743

struct modint_base_static<bt: static_barrett>: modint_implementation {
    init() {
        self.init(0)
    }
    init<T: FixedWidthInteger>(_ v: T) {
        _v = Self.value(v)
    }
    var _v: CUnsignedInt
}

extension modint_base_static: ExpressibleByIntegerLiteral {
    init(integerLiteral value: CInt) {
        self.init(value)
    }
}

protocol modint_base_protocol: AdditiveArithmetic, Equatable, ExpressibleByIntegerLiteral {
    static func mod() -> CInt
    static func raw(_ v: CInt) -> mint
    init()
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
    func pow(_ n: CLongLong) -> mint
    func inv() -> mint
}

extension modint_base_protocol {
    typealias mint = Self
}

protocol modint_implementation: modint_base_protocol, CustomStringConvertible {
    associatedtype bt: barrett
    init()
    init<T: FixedWidthInteger>(_ v: T)
    var _v: CUnsignedInt { get set }
}

extension modint_implementation {
    
    typealias mint = Self

    static func mod() -> CInt { return CInt(bitPattern: bt.umod()); }
    
    static func raw(_ v: CInt) -> mint {
        var x = mint();
        x._v = CUnsignedInt(bitPattern: v);
        return x;
    }

    init(_ v: Bool) {
        self.init(CInt(v ? 1 : 0))
    }

    func val() -> CUnsignedInt { return _v; }
    
    static func + (lhs: mint, rhs: mint) -> mint {
        var _v = lhs._v &+ rhs._v
        if (_v >= umod()) { _v -= umod(); }
        return Self.raw(CInt(bitPattern: _v))
    }
    static func - (lhs: mint, rhs: mint) -> mint {
        var _v = lhs._v &+ CUnsignedInt(bitPattern: mod()) &- rhs._v
        if (_v >= umod()) { _v -= umod(); }
        return Self.raw(CInt(bitPattern: _v))
    }
    static func * (lhs: mint, rhs: mint) -> mint {
        let _v = bt.mul(lhs._v, rhs._v);
        return Self.raw(CInt(bitPattern: _v))
    }
    static func / (lhs: mint, rhs: mint) -> mint {
        lhs * rhs.inv()
    }
    static func +=(lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    static func -=(lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
   }
    static func *=(lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    static func /=(lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    static prefix func + (_ m: Self) -> Self {
        return m
    }
    static prefix func - (_ m: Self) -> Self {
        return Self() - m
    }

    func pow(_ n: CLongLong) -> mint {
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
    
    func inv() -> mint {
        let eg = `internal`.inv_gcd(CLongLong(_v), CLongLong(Self.mod()));
        assert(eg.first == 1);
        return Self.init(CInt(eg.second));
    }
    
    static func umod() -> CUnsignedInt { return bt.umod(); }
    
    var description: String { val().description }
}

protocol modint_dynamic_implementation: modint_implementation where bt: dynamic_barrett { }

extension modint_dynamic_implementation {
    static func set_mod(_ m: CInt) {
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

struct modint_base_dynamic<bt: dynamic_barrett>: modint_dynamic_implementation {
    init() {
        self.init(0)
    }
    init<T: FixedWidthInteger>(_ v: T) {
        _v = Self.value(v)
    }
    var _v: CUnsignedInt
}

extension modint_base_dynamic: ExpressibleByIntegerLiteral {
    init(integerLiteral value: CInt) {
        self.init(value)
    }
}

struct modint_base<bt: barrett>: modint_implementation {
    init() {
        self.init(0)
    }
    init<T: FixedWidthInteger>(_ v: T) {
        _v = Self.value(v)
    }
    var _v: CUnsignedInt
}

extension modint_base: ExpressibleByIntegerLiteral {
    init(integerLiteral value: CInt) {
        self.init(value)
    }
}

typealias modint998244353 = modint_base_static<mod_998244353>
typealias modint1000000007 = modint_base_static<mod_1000000007>

typealias static_modint = modint_base_static
typealias dynamic_modint = modint_base_dynamic<mod_dynamic>

typealias modint = dynamic_modint

