import Foundation

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
    public static var m: CUnsignedInt { mod.mod }
    public static var umod: CUnsignedInt { mod.mod }
    public static var isPrime: Bool { mod.isPrime }
}

// MARK: -

extension barrett: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: CInt) {
        self.init(value)
    }
}

public protocol dynamic_mod {
    static var bt: barrett { get set }
}

extension dynamic_mod {
    @usableFromInline static var umod: CUnsignedInt { bt.umod() }
    static func mul(_ a: CUnsignedInt,_ b: CUnsignedInt) -> CUnsignedInt {
        bt.mul(a,b)
    }
    public static func set_mod(_ m: CInt) {
        assert(1 <= m)
        bt = .init(m)
    }
}

public extension barrett {
    static var `default`: Self { 998_244_353 }
}

extension barrett: Equatable {
    public static func == (lhs: barrett, rhs: barrett) -> Bool {
        (lhs.im,lhs.m) == (rhs.im, rhs.m)
    }
}

public enum mod_dynamic: dynamic_mod {
    public static var bt: barrett = .default
}

public enum mod_998_244_353: static_mod {
    public static let mod: mod_value = 998_244_353
}

public enum mod_1_000_000_007: static_mod {
    public static let mod: mod_value = 1_000_000_007
}

public typealias ModIntAdaptions = BinaryInteger & Hashable & Strideable & ExpressibleByIntegerLiteral & CustomStringConvertible

public protocol modint_base: ModIntAdaptions where Words == Array<UInt> {
    static func mod() -> CInt
    static func umod() -> CUnsignedInt
    init()
    init(_ v: Bool)
    init(_ v: CInt)
    init<T: BinaryInteger>(_ v: T)
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

extension modint_base {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.val() < rhs.val()
    }
    public func distance(to other: Self) -> CInt {
        CInt(other.val()) - CInt(self.val())
    }
    public func advanced(by n: CInt) -> Self{
        .init(CInt(self.val()) + n)
    }
}

extension modint_base {
    public init<T>(_ source: T) where T : BinaryFloatingPoint {
        self.init(CUnsignedInt(source))
    }
    public init<T>(clamping source: T) where T : BinaryInteger {
        self.init(CUnsignedInt(clamping: source))
    }
    public init<T>(truncatingIfNeeded source: T) where T : BinaryInteger {
        self.init(CUnsignedInt(truncatingIfNeeded: source))
    }
    public init?<T>(exactly source: T) where T : BinaryInteger {
        self.init(source)
    }
    public init?<T>(exactly source: T) where T : BinaryFloatingPoint {
        guard let raw = CUnsignedInt(exactly: source) else { return nil }
        self.init(raw)
    }
    public var words: Array<UInt> { [.init(val())] }
    public var magnitude: CUnsignedInt {
        val()
    }
    public static var isSigned: Bool {
        false
    }
    public var bitWidth: Int {
        val().bitWidth
    }
    public var trailingZeroBitCount: Int {
        val().trailingZeroBitCount
    }
    public static func % (lhs: Self, rhs: Self) -> Self {
        .init(lhs.val() % rhs.val())
    }
    public static func %= (lhs: inout Self, rhs: Self) {
        lhs = lhs % rhs
    }
    public static func &= (lhs: inout Self, rhs: Self) {
        lhs = .init(lhs.val() & rhs.val())
    }
    public static func |= (lhs: inout Self, rhs: Self) {
        lhs = .init(lhs.val() | rhs.val())
    }
    public static func ^= (lhs: inout Self, rhs: Self) {
        lhs = .init(lhs.val() ^ rhs.val())
    }
    public static func <<= <RHS>(lhs: inout Self, rhs: RHS) where RHS : BinaryInteger {
        lhs = .init(lhs.val() << rhs)
    }
    public static func >>= <RHS>(lhs: inout Self, rhs: RHS) where RHS : BinaryInteger {
        lhs = .init(lhs.val() >> rhs)
    }
    public static prefix func ~ (x: Self) -> Self {
        .init(~(x.val()))
    }
}

@usableFromInline func __modint_v<T: UnsignedInteger>(_ v: T, umod: T) -> CUnsignedInt {
    let x = v % umod
    return CUnsignedInt(truncatingIfNeeded: x)
}

@usableFromInline func ___modint_v<T: BinaryInteger>(_ v: T, mod: T) -> CUnsignedInt {
    var x = v % mod;
    if (x < 0) { x += mod }
    let x0 = CInt(truncatingIfNeeded: x)
    return CUnsignedInt(bitPattern: x0)
}

@usableFromInline func __modint_umod<T: UnsignedInteger>(_ umod: CUnsignedInt) -> T { T(umod) }
@usableFromInline func __modint_mod<T: BinaryInteger>(_ umod: CUnsignedInt) -> T { T(truncatingIfNeeded: umod) }
@usableFromInline func __modint_mod<T: BinaryInteger>(_ mod: CInt) -> T { T(truncatingIfNeeded: mod) }

extension modint_base {
    typealias ULL = CUnsignedLongLong
    typealias LL = CLongLong
    typealias UINT = CUnsignedInt
}

public extension modint_base {
    @inlinable @inline(__always)
    var description: String { val().description }
}

public protocol modint_raw {
    init(raw: CUnsignedInt)
    var _v: CUnsignedInt { get set }
    func val() -> CUnsignedInt
    static func mod() -> CInt
    static func umod() -> CUnsignedInt
}

extension modint_raw {
    @inlinable @inline(__always)
    public init(integerLiteral value: CInt) {
        self.init(raw: ___modint_v(value, mod: __modint_mod(Self.mod())))
    }
}

