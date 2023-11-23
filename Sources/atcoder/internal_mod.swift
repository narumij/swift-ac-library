import Foundation

extension barrett: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: CInt) {
        self.init(value)
    }
}

public extension barrett {
    static let mod_998_244_353:   barrett =   998_244_353
    static let mod_1_000_000_007: barrett = 1_000_000_007
    static let mod_INT32_MAX:     barrett = 2_147_483_647
    static let mod_UINT32_MAX:    barrett =            -1
}

// MARK: -

public protocol mod_type {
    static var modValue: barrett { get }
}

extension mod_type {
    static func umod() -> CUnsignedInt { modValue.umod() }
    static func mul(_ a: CUnsignedInt,_ b: CUnsignedInt) -> CUnsignedInt {
        modValue.mul(a,b)
    }
}

extension mod_type {
    public static func value<T: FixedWidthInteger>() -> T { T(umod()) }
}

public struct mod_value {
    public init<Integer: FixedWidthInteger>(_ m: Integer) {
        self.m = CUnsignedInt(m)
        self.isPrime = _internal.is_prime(CInt(m))
    }
    let m: CUnsignedInt
    let isPrime: Bool
}

extension mod_value: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: CInt) {
        self.m = CUnsignedInt(bitPattern: value)
        self.isPrime = _internal.is_prime(value)
    }
}

public extension mod_value {
    static let mod_998_244_353:   mod_value =   998_244_353
    static let mod_1_000_000_007: mod_value = 1_000_000_007
    static let mod_INT32_MAX:     mod_value = 2_147_483_647
    static let mod_UINT32_MAX:    mod_value =            -1
}

public protocol mod_type2 {
    static var m: mod_value { get }
}

extension mod_type2 {
    static var umod: CUnsignedInt { m.m }
    static var mod: CInt { CInt(m.m) }
    static var isPrime: Bool { m.isPrime }
}

extension mod_type2 {
    public static func value<T: FixedWidthInteger>() -> T { T(umod) }
}

public protocol static_mod: mod_type2 { }

public protocol dynamic_mod: mod_type {
    static var modValue: barrett { get set }
    static func set_mod(_ m: CInt)
}

extension dynamic_mod {
    public static func set_mod(_ m: CInt) {
        assert(1 <= m);
        modValue = .init(m)
    }
}

public enum mod_dynamic: dynamic_mod {
    public static var modValue: barrett = -1
}

public enum mod_998244353: static_mod {
    public static let m: mod_value = 998_244_353
}

public enum mod_1000000007: static_mod {
    public static let m: mod_value = 1_000_000_007
}
