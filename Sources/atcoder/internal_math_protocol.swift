import Foundation

func imValue(_ _m: CUnsignedInt) -> CUnsignedLongLong {
    CUnsignedLongLong(bitPattern: -1) / CUnsignedLongLong(_m) &+ 1
}

func imValue(_ _m: CInt) -> CUnsignedLongLong {
    imValue(CUnsignedInt(bitPattern: _m))
}

struct barret_modulus {
    let m: CUnsignedInt
    let im: CUnsignedLongLong
    init<Unsigned: UnsignedInteger>(_ _m: Unsigned) {
        m = CUnsignedInt(_m)
        im = imValue(CUnsignedInt(_m))
    }
    init<Signed: SignedInteger>(_ _m: Signed) {
        m = CUnsignedInt(bitPattern: CInt(_m))
        im = imValue(CInt(_m))
    }
}

extension barret_modulus: ExpressibleByIntegerLiteral {
    init(integerLiteral value: CInt) {
        self.init(value)
    }
}

extension barret_modulus {
    static let mod_998_244_353:   barret_modulus =   998_244_353
    static let mod_1_000_000_007: barret_modulus = 1_000_000_007
    static let mod_INT32_MAX:     barret_modulus = 2_147_483_647
    static let mod_UINT32_MAX:    barret_modulus =            -1
}

typealias static_mod = barret_modulus

// MARK: -

// Fast modular multiplication by barrett reduction
// Reference: https://en.wikipedia.org/wiki/Barrett_reduction
// NOTE: reconsider after Ice Lake
protocol barrett {
//    associatedtype mod_type: barret_modulus
    static var modulus: barret_modulus { get }
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

protocol static_barrett: barrett { }

protocol dynamic_barrett: barrett {
    static var modulus: barret_modulus { get set }
    static func set_mod(_ m: CInt)
}

extension dynamic_barrett {
    static func set_mod(_ m: CInt) {
        assert(1 <= m);
        modulus = .init(m)
    }
}

enum mod_dynamic: dynamic_barrett { 
    static var modulus: barret_modulus = -1
}

enum mod_998244353: static_barrett {
    static let modulus: barret_modulus = .mod_998_244_353
}

enum mod_1000000007: static_barrett {
    static let modulus: barret_modulus = .mod_1_000_000_007
}
