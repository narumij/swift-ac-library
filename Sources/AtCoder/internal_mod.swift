import Foundation

extension barrett: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: CInt) {
        self.init(value)
    }
}

public struct mod_value {
    public init<Integer: FixedWidthInteger>(_ m: Integer) {
        self.mod = CUnsignedInt(m)
        self.isPrime = _Internal.is_prime(CInt(m))
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
        self.isPrime = _Internal.is_prime(value)
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
    init<T: FixedWidthInteger>(_ v: T)
    func val() -> CUnsignedInt
    static func +(lhs: Self, rhs: Self) -> Self
    static func -(lhs: Self, rhs: Self) -> Self
    static func *(lhs: Self, rhs: Self) -> Self
    static func /(lhs: Self, rhs: Self) -> Self
    static func +=(lhs: inout Self, rhs: Self)
    static func -=(lhs: inout Self, rhs: Self)
    static func *=(lhs: inout Self, rhs: Self)
    static func /=(lhs: inout Self, rhs: Self)
    static prefix func + (_ m: Self) -> Self
    static prefix func - (_ m: Self) -> Self
    func pow<LL: SignedInteger>(_ n: LL) -> Self
    func inv() -> Self
}

public extension modint_base {
    static func + <I: FixedWidthInteger>(lhs: I, rhs: Self) -> Self { Self(lhs) + rhs }
    static func + <I: FixedWidthInteger>(lhs: Self, rhs: I) -> Self { lhs + Self(rhs) }
    static func - <I: FixedWidthInteger>(lhs: I, rhs: Self) -> Self { Self(lhs) - rhs }
    static func - <I: FixedWidthInteger>(lhs: Self, rhs: I) -> Self { lhs - Self(rhs) }
    static func * <I: FixedWidthInteger>(lhs: I, rhs: Self) -> Self { Self(lhs) * rhs }
    static func * <I: FixedWidthInteger>(lhs: Self, rhs: I) -> Self { lhs * Self(rhs) }
    static func / <I: FixedWidthInteger>(lhs: I, rhs: Self) -> Self { Self(lhs) / rhs }
    static func / <I: FixedWidthInteger>(lhs: Self, rhs: I) -> Self { lhs / Self(rhs) }
    static func += <I: FixedWidthInteger>(lhs: inout Self, rhs: I) { lhs += Self(rhs) }
    static func -= <I: FixedWidthInteger>(lhs: inout Self, rhs: I) { lhs -= Self(rhs) }
    static func *= <I: FixedWidthInteger>(lhs: inout Self, rhs: I) { lhs *= Self(rhs) }
    static func /= <I: FixedWidthInteger>(lhs: inout Self, rhs: I) { lhs /= Self(rhs) }
}

@usableFromInline func __modint_v<T: UnsignedInteger>(_ v: T, umod: T) -> CUnsignedInt {
    let x = v % umod
    return CUnsignedInt(truncatingIfNeeded: x);
}

@usableFromInline func ___modint_v<T: FixedWidthInteger>(_ v: T, mod: T) -> CUnsignedInt {
    var x = v % mod;
    if (x < 0) { x += mod }
    let x0 = CInt(truncatingIfNeeded: x)
    return CUnsignedInt(bitPattern: x0)
}

@usableFromInline func __modint_umod<T: UnsignedInteger>(_ umod: CUnsignedInt) -> T { T(umod) }
@usableFromInline func __modint_mod<T: FixedWidthInteger>(_ umod: CUnsignedInt) -> T { T(truncatingIfNeeded: umod) }
@usableFromInline func __modint_mod<T: FixedWidthInteger>(_ mod: CInt) -> T { T(truncatingIfNeeded: mod) }
