import Foundation

protocol barret_modulus {
    var m: CUnsignedInt { get }
    var im: CUnsignedLongLong { get }
}

func imValue(_ _m: CUnsignedInt) -> CUnsignedLongLong {
    CUnsignedLongLong(bitPattern: -1) / CUnsignedLongLong( _m) &+ 1
}

func imValue(_ _m: CInt) -> CUnsignedLongLong {
    imValue(CUnsignedInt(bitPattern: _m))
}

protocol barret_modulus_dynamic: barret_modulus {
    var m: CUnsignedInt { get set }
    var im: CUnsignedLongLong { get set }
    mutating func set_mod(_ _m: CUnsignedInt)
}

extension barret_modulus_dynamic {
    mutating func set_mod(_ _m: CUnsignedInt) {
        m = _m
        im = imValue(_m)
    }
}

struct static_mod: barret_modulus {
    let m: CUnsignedInt
    let im: CUnsignedLongLong
    init() { self.init(-1) }
    init(_ _m: CInt) {
        m = CUnsignedInt(bitPattern: _m)
        im = imValue(_m)
    }
}

struct dynamic_mod: barret_modulus_dynamic {
    var m: CUnsignedInt
    var im: CUnsignedLongLong
    init() { self.init(-1) }
    init(_ _m: CInt) {
        m = CUnsignedInt(bitPattern: _m)
        im = imValue(_m)
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
    static let mod_998244353: static_mod = 998244353
    static let mod_1000000007: static_mod = 1000000007
    static let mod_2147483647: static_mod = 2147483647
    static let mod_4294967295: static_mod = -1
}

// MARK: -

// Fast modular multiplication by barrett reduction
// Reference: https://en.wikipedia.org/wiki/Barrett_reduction
// NOTE: reconsider after Ice Lake
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

protocol new_barrett: barrett where mod_type: barret_modulus_dynamic {
    static var modulus: mod_type { get set }
    static func set_mod(_ m: CInt)
}

extension new_barrett {
    static func set_mod(_ m: CInt) {
        assert(1 <= m);
        modulus.set_mod(CUnsignedInt(m))
    }
}

enum mod_dynamic: new_barrett { 
    static var modulus: dynamic_mod = -1
}

protocol static_barrett: barrett { }

enum mod_998244353: static_barrett {
    static let modulus: static_mod = .mod_998244353
}

enum mod_1000000007: static_barrett {
    static let modulus: static_mod = static_mod.mod_1000000007
}
