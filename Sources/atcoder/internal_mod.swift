import Foundation

extension barrett: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: CInt) {
        self.init(value)
    }
}

public struct mod_value {
    public init<Integer: FixedWidthInteger>(_ m: Integer) {
        self.mod = CUnsignedInt(m)
        self.isPrime = _internal.is_prime(CInt(m))
    }
    @usableFromInline let mod: CUnsignedInt
    @usableFromInline let isPrime: Bool
}

public extension mod_value {
    static let mod_998_244_353:   mod_value =   998_244_353
    static let mod_1_000_000_007: mod_value = 1_000_000_007
    static let mod_INT32_MAX:     mod_value = 2_147_483_647
    static let mod_UINT32_MAX:    mod_value =            -1
}

extension mod_value: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: CInt) {
        self.mod = CUnsignedInt(bitPattern: value)
        self.isPrime = _internal.is_prime(value)
    }
}

// MARK: -

public protocol static_mod {
    static var mod: mod_value { get }
}

extension static_mod {
    @usableFromInline static var m: CUnsignedInt { mod.mod }
    @usableFromInline static var umod: CUnsignedInt { mod.mod }
    @usableFromInline static var isPrime: Bool { mod.isPrime }
}

// MARK: -

public protocol dynamic_mod {
    static var bt: barrett { get set }
}

extension dynamic_mod {
    @usableFromInline static var umod: CUnsignedInt { bt.umod() }
    static func mul(_ a: CUnsignedInt,_ b: CUnsignedInt) -> CUnsignedInt {
        bt.mul(a,b)
    }
    public static func set_mod(_ m: CInt) {
        assert(1 <= m);
        bt = .init(m)
    }
}

public enum mod_dynamic: dynamic_mod {
    public static var bt: barrett = -1
}

public enum mod_998_244_353: static_mod {
    public static let mod: mod_value = 998_244_353
}

public enum mod_1_000_000_007: static_mod {
    public static let mod: mod_value = 1_000_000_007
}

public protocol modint_base: AdditiveArithmetic, Hashable, ExpressibleByIntegerLiteral, CustomStringConvertible {
    static func mod() -> CInt
    static func umod() -> CUnsignedInt
    init()
    init(_ v: Bool)
    init(_ v: CInt)
    init<T: UnsignedInteger>(unsigned v: T)
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
    func pow<LL: SignedInteger>(_ n: LL) -> mint
    func inv() -> mint
}

public extension modint_base {
    static func + <I: FixedWidthInteger>(lhs: I, rhs: mint) -> mint { mint(lhs) + rhs }
    static func + <I: FixedWidthInteger>(lhs: mint, rhs: I) -> mint { lhs + mint(rhs) }
    static func - <I: FixedWidthInteger>(lhs: I, rhs: mint) -> mint { mint(lhs) - rhs }
    static func - <I: FixedWidthInteger>(lhs: mint, rhs: I) -> mint { lhs - mint(rhs) }
    static func * <I: FixedWidthInteger>(lhs: I, rhs: mint) -> mint { mint(lhs) * rhs }
    static func * <I: FixedWidthInteger>(lhs: mint, rhs: I) -> mint { lhs * mint(rhs) }
    static func / <I: FixedWidthInteger>(lhs: I, rhs: mint) -> mint { mint(lhs) / rhs }
    static func / <I: FixedWidthInteger>(lhs: mint, rhs: I) -> mint { lhs / mint(rhs) }
    static func += <I: FixedWidthInteger>(lhs: inout mint, rhs: I) { lhs += mint(rhs) }
    static func -= <I: FixedWidthInteger>(lhs: inout mint, rhs: I) { lhs -= mint(rhs) }
    static func *= <I: FixedWidthInteger>(lhs: inout mint, rhs: I) { lhs *= mint(rhs) }
    static func /= <I: FixedWidthInteger>(lhs: inout mint, rhs: I) { lhs /= mint(rhs) }
}

extension modint_base {
    public typealias mint = Self
}
