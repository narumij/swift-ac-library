import Foundation

typealias modint = dynamic_modint_struct<mod_dynamic>

// MARK: - modint

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

protocol modint_implementation: modint_base_protocol {
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
}

protocol dynamic_modint_implementation: modint_implementation where bt: new_barrett { }

extension dynamic_modint_implementation {
    static func set_mod(_ m: CInt) {
        bt.set_mod(m)
    }
}

extension modint_implementation {
    static func value<T: FixedWidthInteger>(_ v: T) -> CUnsignedInt where T.Magnitude == T {
        CUnsignedInt(v % T(Self.mod()));
    }
    static func value<T: FixedWidthInteger>(_ v: T) -> CUnsignedInt {
        var x = v % T(Self.mod());
        if (x < 0) { x += T(Self.mod()); }
        return CUnsignedInt(x);
    }
}

struct modint_struct<bt: barrett>: modint_implementation {
    init() {
        self.init(0)
    }
    init<T: FixedWidthInteger>(_ v: T) {
        _v = Self.value(v)
    }
    var _v: CUnsignedInt
}

extension modint_struct: ExpressibleByIntegerLiteral {
    init(integerLiteral value: CInt) {
        self.init(value)
    }
}

struct dynamic_modint_struct<bt: new_barrett>: dynamic_modint_implementation {
    init() {
        self.init(0)
    }
    init<T: FixedWidthInteger>(_ v: T) {
        _v = Self.value(v)
    }
    var _v: CUnsignedInt
}

extension dynamic_modint_struct: ExpressibleByIntegerLiteral {
    init(integerLiteral value: CInt) {
        self.init(value)
    }
}

fileprivate func test() {
    
    enum barret1: new_barrett { static var modulus: dynamic_mod = -1 }
    barret1.set_mod(2)
    typealias modint1 = modint_struct<barret1>
    
    enum barret2: new_barrett { static var modulus: dynamic_mod = -1 }
    barret2.set_mod(5)
    typealias modint2 = modint_struct<barret2>
    
    enum barret3: new_barrett { static var modulus: dynamic_mod = -1 }
    barret3.set_mod(7)
    typealias modint3 = modint_struct<barret3>

    typealias modint998244353 = modint_struct<mod_998244353>
    typealias modint1000000007 = modint_struct<mod_1000000007>
    typealias modint2147483647 = modint_struct<mod_2147483647>
    typealias modint4294967295 = modint_struct<mod_4294967295>
    
}

typealias dynamic_modint = dynamic_modint_struct<mod_dynamic>
