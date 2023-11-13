import Foundation

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

// MARK: -

protocol mod_type {
    static var modValue: barrett { get }
}

extension mod_type {
    static var _m: CUnsignedInt { modValue.m }
    static var im: CUnsignedLongLong { modValue.im }
    static func umod() -> CUnsignedInt { modValue.umod() }
    static func mul(_ a: CUnsignedInt,_ b: CUnsignedInt) -> CUnsignedInt {
        modValue.mul(a,b)
    }
}

protocol static_mod: mod_type { }

protocol dynamic_mod: mod_type {
    static var modValue: barrett { get set }
    static func set_mod(_ m: CInt)
}

extension dynamic_mod {
    static func set_mod(_ m: CInt) {
        assert(1 <= m);
        modValue = .init(m)
    }
}

enum mod_dynamic: dynamic_mod { 
    static var modValue: barrett = -1
}

enum mod_998244353: static_mod {
    static let modValue: barrett = .mod_998_244_353
}

enum mod_1000000007: static_mod {
    static let modValue: barrett = .mod_1_000_000_007
}
