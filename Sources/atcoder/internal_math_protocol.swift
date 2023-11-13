import Foundation

func imValue(_ _m: CUnsignedInt) -> CUnsignedLongLong {
    CUnsignedLongLong(bitPattern: -1) / CUnsignedLongLong(_m) &+ 1
}

func imValue(_ _m: CInt) -> CUnsignedLongLong {
    imValue(CUnsignedInt(bitPattern: _m))
}

// Fast modular multiplication by barrett reduction
// Reference: https://en.wikipedia.org/wiki/Barrett_reduction
// NOTE: reconsider after Ice Lake
struct barrett {
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
    
    // @return m
    func umod() -> CUnsignedInt { return m; }
    // @param a `0 <= a < m`
    // @param b `0 <= b < m`
    // @return `a * b % m`
    func mul(_ a: CUnsignedInt,_ b: CUnsignedInt) -> CUnsignedInt {
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
        let y = x &* CUnsignedLongLong(m);
        return CUnsignedInt(z &- y &+ (z < y ? CUnsignedLongLong(m) : 0));
    }
}

extension barrett: ExpressibleByIntegerLiteral {
    init(integerLiteral value: CInt) {
        self.init(value)
    }
}

extension barrett {
    static let mod_998_244_353:   barrett =   998_244_353
    static let mod_1_000_000_007: barrett = 1_000_000_007
    static let mod_INT32_MAX:     barrett = 2_147_483_647
    static let mod_UINT32_MAX:    barrett =            -1
}

//typealias static_mod = barrett

// MARK: -

protocol barrett_wrapper {
    static var modulus: barrett { get }
}

extension barrett_wrapper {
    static var _m: CUnsignedInt { modulus.m }
    static var im: CUnsignedLongLong { modulus.im }
    static func umod() -> CUnsignedInt { modulus.umod() }
    static func mul(_ a: CUnsignedInt,_ b: CUnsignedInt) -> CUnsignedInt {
        modulus.mul(a,b)
    }
}

protocol static_barrett: barrett_wrapper { }

protocol dynamic_barrett: barrett_wrapper {
    static var modulus: barrett { get set }
    static func set_mod(_ m: CInt)
}

extension dynamic_barrett {
    static func set_mod(_ m: CInt) {
        assert(1 <= m);
        modulus = .init(m)
    }
}

enum mod_dynamic: dynamic_barrett { 
    static var modulus: barrett = -1
}

enum mod_998244353: static_barrett {
    static let modulus: barrett = .mod_998_244_353
}

enum mod_1000000007: static_barrett {
    static let modulus: barrett = .mod_1_000_000_007
}
