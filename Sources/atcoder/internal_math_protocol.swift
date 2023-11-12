//
//  File.swift
//  
//
//  Created by narumij on 2023/11/12.
//

import Foundation

protocol barret_modulus {
    var m: CUnsignedInt { get }
    var im: CUnsignedLongLong { get }
}

protocol barret_modulus_dynamic: barret_modulus {
    var m: CUnsignedInt { get set }
    var im: CUnsignedLongLong { get set }
    mutating func set_mod(_ _m: CUnsignedInt)
}

extension barret_modulus_dynamic {
    mutating func set_mod(_ _m: CUnsignedInt) {
        m = _m; im = CUnsignedLongLong(bitPattern: -1) / CUnsignedLongLong(_m) &+ 1
    }
}

struct static_mod: barret_modulus {
    let m: CUnsignedInt
    let im: CUnsignedLongLong
    init() { self.init(-1) }
    init(_ _m: CInt) {
        m = CUnsignedInt(bitPattern: _m)
        im = CUnsignedLongLong(bitPattern: -1) / CUnsignedLongLong(_m) &+ 1
    }
}

struct dynamic_mod: barret_modulus_dynamic {
    var m: CUnsignedInt
    var im: CUnsignedLongLong
    init() { self.init(-1) }
    init(_ _m: CInt) {
        m = CUnsignedInt(bitPattern: _m)
        im = CUnsignedLongLong(bitPattern: -1) / CUnsignedLongLong( _m) &+ 1
    }
}

extension static_mod: ExpressibleByIntegerLiteral {
    init(integerLiteral value: CInt) {
        self.init(value)
    }
}

extension dynamic_mod: ExpressibleByIntegerLiteral {
    init(integerLiteral value: CInt) {
        self.init(value)
    }
}

extension static_mod {
    static let mod_998244353: static_mod = 998244353 as static_mod
    static let mod_1000000007: static_mod = 1000000007 as static_mod
    static let mod_2147483647: static_mod = 2147483647 as static_mod
    static let mod_4294967295: static_mod = -1 as static_mod
}

// MARK: -

protocol barrett {
    associatedtype mod_type: barret_modulus
    static var modulus: mod_type { get }
}

extension barrett {
    static var _m: CUnsignedInt { modulus.m }
    static var im: CUnsignedLongLong { modulus.im }
}

extension barrett {
    // @return m
    static func umod() -> CUnsignedInt { return _m; }
    // @param a `0 <= a < m`
    // @param b `0 <= b < m`
    // @return `a * b % m`
    static func mul(_ a: CUnsignedInt,_ b: CUnsignedInt) -> CUnsignedInt {
        // [1] m = 1
        // a = b = im = 0, so okay

        // [2] m >= 2
        // im = ceil(2^64 / m)
        // -> im * m = 2^64 + r (0 <= r < m)
        // let z = a*b = c*m + d (0 <= c, d < m)
        // a*b * im = (c*m + d) * im = c*(im*m) + d*im = c*2^64 + c*r + d*im
        // c*r + d*im < m * m + m * im < m * m + 2^64 + m <= 2^64 + m * (m + 1) < 2^64 * 2
        // ((ab * im) >> 64) == c or c + 1
        var z = CUnsignedLongLong(a);
        z &*= CUnsignedLongLong(b);
        let x = z.multipliedFullWidth(by: CUnsignedLongLong(im)).high
        let y = x &* CUnsignedLongLong(_m);
        return CUnsignedInt(z &- y &+ (z < y ? CUnsignedLongLong(_m) : 0));
    }
}

protocol dynamic_barret: barrett where mod_type: barret_modulus_dynamic {
    static var modulus: mod_type { get set }
    static func set_mod(_ m: CInt)
}

extension dynamic_barret {
    static func set_mod(_ m: CInt) {
        assert(1 <= m);
        modulus.set_mod(CUnsignedInt(m))
    }
}

protocol static_barrett: barrett { }

enum mod_998244353: static_barrett {
    static let modulus: static_mod = .mod_998244353
}
enum mod_1000000007: static_barrett {
    static let modulus: static_mod = static_mod.mod_1000000007
}
enum mod_2147483647: static_barrett {
    static let modulus: static_mod = static_mod.mod_2147483647
}
enum mod_4294967295: static_barrett { 
    static let modulus: static_mod = static_mod.mod_4294967295
}


// MARK: - modint

protocol modint_implementation {
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

protocol dynamic_modint_implementation: modint_implementation where bt: dynamic_barret { }

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

fileprivate func test() {
    
    enum barret1: dynamic_barret { static var modulus: dynamic_mod = -1 }
    barret1.set_mod(2)
    typealias modint1 = modint_struct<barret1>
    
    enum barret2: dynamic_barret { static var modulus: dynamic_mod = -1 }
    barret2.set_mod(5)
    typealias modint2 = modint_struct<barret2>
    
    enum barret3: dynamic_barret { static var modulus: dynamic_mod = -1 }
    barret3.set_mod(7)
    typealias modint3 = modint_struct<barret3>

    typealias modint998244353 = modint_struct<mod_998244353>
    typealias modint1000000007 = modint_struct<mod_1000000007>
    typealias modint2147483647 = modint_struct<mod_2147483647>
    typealias modint4294967295 = modint_struct<mod_4294967295>
}
