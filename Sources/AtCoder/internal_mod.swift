import Foundation

public struct mod_value {
  @inlinable
  public init<Integer: BinaryInteger>(_ m: Integer) {
    self.umod = CUnsignedInt(m)
    self.isPrime = _Internal.is_prime(CInt(m))
  }
  public let umod: CUnsignedInt
  public let isPrime: Bool
}

extension mod_value {
  public static let mod_998_244_353: mod_value = 998_244_353
  public static let mod_1_000_000_007: mod_value = 1_000_000_007
  public static let mod_INT32_MAX: mod_value = 2_147_483_647
  public static let mod_UINT32_MAX: mod_value = -1
}

extension mod_value: ExpressibleByIntegerLiteral {
  @inlinable
  public init(integerLiteral value: CInt) {
    self.umod = CUnsignedInt(bitPattern: value)
    self.isPrime = _Internal.is_prime(value)
  }
}

// MARK: -

public protocol static_mod {
  static var umod: CUnsignedInt { get }
  static var isPrime: Bool { get }
}

extension static_mod {
  public static var m: CUnsignedInt { umod }
}

public protocol static_mod_value: static_mod {
  static var mod: mod_value { get }
}

extension static_mod_value {
  public static var umod: CUnsignedInt { mod.umod }
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
  @inlinable
  public static var umod: CUnsignedInt { bt.umod() }
  static func mul(_ a: CUnsignedInt, _ b: CUnsignedInt) -> CUnsignedInt {
    bt.mul(a, b)
  }
  @inlinable
  public static func set_mod(_ m: CInt) {
    assert(1 <= m)
    bt = .init(m)
  }
}

extension barrett {
  @inlinable
  public static var `default`: Self { 998_244_353 }
}

extension barrett: Equatable {
  public static func == (lhs: barrett, rhs: barrett) -> Bool {
    (lhs.im, lhs.m) == (rhs.im, rhs.m)
  }
}

public enum mod_dynamic: dynamic_mod {
  public static var bt: barrett = .default
}

public enum mod_998_244_353: static_mod {
  public static let umod: CUnsignedInt = 998_244_353
  public static let isPrime: Bool = true
}

public enum mod_1_000_000_007: static_mod {
  public static let umod: CUnsignedInt = 1_000_000_007
  public static let isPrime: Bool = true
}

public typealias ModIntAdaptions = BinaryInteger & Hashable & Strideable
  & ExpressibleByIntegerLiteral & CustomStringConvertible

public protocol modint_base: ModIntAdaptions where Words == [UInt] {
  init()
  init(_ v: Bool)
  init(_ v: CInt)
  init<T: BinaryInteger>(_ v: T)
  var val: CInt { get }
  static func + (lhs: Self, rhs: Self) -> Self
  static func - (lhs: Self, rhs: Self) -> Self
  static func * (lhs: Self, rhs: Self) -> Self
  static func / (lhs: Self, rhs: Self) -> Self
  static func += (lhs: inout Self, rhs: Self)
  static func -= (lhs: inout Self, rhs: Self)
  static func *= (lhs: inout Self, rhs: Self)
  static func /= (lhs: inout Self, rhs: Self)
  static prefix func + (_ m: Self) -> Self
  static prefix func - (_ m: Self) -> Self
  func pow<LL: SignedInteger>(_ n: LL) -> Self
  var inv: Self { get }
}

extension modint_base {
  @inlinable
  public static func + <I: FixedWidthInteger>(lhs: I, rhs: Self) -> Self { Self(lhs) + rhs }
  @inlinable
  public static func + <I: FixedWidthInteger>(lhs: Self, rhs: I) -> Self { lhs + Self(rhs) }
  @inlinable
  public static func - <I: FixedWidthInteger>(lhs: I, rhs: Self) -> Self { Self(lhs) - rhs }
  @inlinable
  public static func - <I: FixedWidthInteger>(lhs: Self, rhs: I) -> Self { lhs - Self(rhs) }
  @inlinable
  public static func * <I: FixedWidthInteger>(lhs: I, rhs: Self) -> Self { Self(lhs) * rhs }
  @inlinable
  public static func * <I: FixedWidthInteger>(lhs: Self, rhs: I) -> Self { lhs * Self(rhs) }
  @inlinable
  public static func / <I: FixedWidthInteger>(lhs: I, rhs: Self) -> Self { Self(lhs) / rhs }
  @inlinable
  public static func / <I: FixedWidthInteger>(lhs: Self, rhs: I) -> Self { lhs / Self(rhs) }
  @inlinable
  public static func += <I: FixedWidthInteger>(lhs: inout Self, rhs: I) { lhs += Self(rhs) }
  @inlinable
  public static func -= <I: FixedWidthInteger>(lhs: inout Self, rhs: I) { lhs -= Self(rhs) }
  @inlinable
  public static func *= <I: FixedWidthInteger>(lhs: inout Self, rhs: I) { lhs *= Self(rhs) }
  @inlinable
  public static func /= <I: FixedWidthInteger>(lhs: inout Self, rhs: I) { lhs /= Self(rhs) }
}

extension modint_base {
  @inlinable
  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.val < rhs.val
  }
  @inlinable
  public func distance(to other: Self) -> CInt {
    CInt(other.val) - CInt(self.val)
  }
  @inlinable
  public func advanced(by n: CInt) -> Self {
    .init(CInt(self.val) + n)
  }
}

extension modint_base {
  @inlinable
  public init<T>(_ source: T) where T: BinaryFloatingPoint {
    self.init(CUnsignedInt(source))
  }
  @inlinable
  public init<T>(clamping source: T) where T: BinaryInteger {
    self.init(CUnsignedInt(clamping: source))
  }
  @inlinable
  public init<T>(truncatingIfNeeded source: T) where T: BinaryInteger {
    self.init(CUnsignedInt(truncatingIfNeeded: source))
  }
  @inlinable
  public init?<T>(exactly source: T) where T: BinaryInteger {
    self.init(source)
  }
  @inlinable
  public init?<T>(exactly source: T) where T: BinaryFloatingPoint {
    guard let raw = CUnsignedInt(exactly: source) else { return nil }
    self.init(raw)
  }
  @inlinable
  public var words: [UInt] { [.init(val)] }
  @inlinable
  public var magnitude: CUnsignedInt {
    .init(bitPattern: val)
  }
  @inlinable
  public static var isSigned: Bool {
    false
  }
  @inlinable
  public var bitWidth: Int {
    val.bitWidth
  }
  @inlinable
  public var trailingZeroBitCount: Int {
    val.trailingZeroBitCount
  }
  @inlinable
  public static func % (lhs: Self, rhs: Self) -> Self {
    .init(lhs.val % rhs.val)
  }
  @inlinable
  public static func %= (lhs: inout Self, rhs: Self) {
    lhs = lhs % rhs
  }
  @inlinable
  public static func &= (lhs: inout Self, rhs: Self) {
    lhs = .init(lhs.val & rhs.val)
  }
  @inlinable
  public static func |= (lhs: inout Self, rhs: Self) {
    lhs = .init(lhs.val | rhs.val)
  }
  @inlinable
  public static func ^= (lhs: inout Self, rhs: Self) {
    lhs = .init(lhs.val ^ rhs.val)
  }
  @inlinable
  public static func <<= <RHS>(lhs: inout Self, rhs: RHS) where RHS: BinaryInteger {
    lhs = .init(lhs.val << rhs)
  }
  @inlinable
  public static func >>= <RHS>(lhs: inout Self, rhs: RHS) where RHS: BinaryInteger {
    lhs = .init(lhs.val >> rhs)
  }
  @inlinable
  public static prefix func ~ (x: Self) -> Self {
    .init(~(x.val))
  }
}

@inlinable func __modint_v(_ v: CUnsignedLongLong, umod: CUnsignedLongLong) -> CUnsignedInt {
  let x = v % umod
  return CUnsignedInt(truncatingIfNeeded: x)
}

@inlinable func __modint_v<T: UnsignedInteger>(_ v: T, umod: T) -> CUnsignedInt {
  let x = v % umod
  return CUnsignedInt(truncatingIfNeeded: x)
}

@inlinable func ___modint_v<T: BinaryInteger>(_ v: T, mod: T) -> CUnsignedInt {
  var x = v % mod
  if x < 0 { x += mod }
  let x0 = CInt(truncatingIfNeeded: x)
  return CUnsignedInt(bitPattern: x0)
}

@inlinable @inline(__always)
func __modint_umod<T: UnsignedInteger>(_ umod: CUnsignedInt) -> T { T(umod) }
@inlinable @inline(__always)
func __modint_mod<T: BinaryInteger>(_ umod: CUnsignedInt) -> T { T(truncatingIfNeeded: umod) }
@inlinable @inline(__always)
func __modint_mod<T: BinaryInteger>(_ mod: CInt) -> T { T(truncatingIfNeeded: mod) }

extension modint_base {
  @usableFromInline typealias ULL = CUnsignedLongLong
  @usableFromInline typealias LL = CLongLong
  @usableFromInline typealias UINT = CUnsignedInt
}

extension modint_base {
  @inlinable @inline(__always)
  public var description: String { val.description }
}

public protocol modint_raw {
  init(raw: CUnsignedInt)
  var _v: CUnsignedInt { get set }
  var val: CInt { get }
  static var mod: CInt { get }
  static var umod: CUnsignedInt { get }
}

extension modint_raw {
  @inlinable @inline(__always)
  public init(integerLiteral value: CInt) {
    self.init(raw: value == 0 ? 0 : ___modint_v(value, mod: __modint_mod(Self.umod)))
  }
}
