import Foundation

@usableFromInline struct mod_value {

  @inlinable
  public init<Integer: BinaryInteger>(_ m: Integer) {
    self.umod = CUnsignedInt(m)
    self.isPrime = _Internal.is_prime(CInt(m))
  }

  @usableFromInline
  let umod: CUnsignedInt

  @usableFromInline
  let isPrime: Bool
}

extension mod_value {
  @usableFromInline static let mod_998_244_353: mod_value = 998_244_353
  @usableFromInline static let mod_1_000_000_007: mod_value = 1_000_000_007
  @usableFromInline static let mod_INT32_MAX: mod_value = 2_147_483_647
  @usableFromInline static let mod_UINT32_MAX: mod_value = -1
}

extension mod_value: ExpressibleByIntegerLiteral {
  @inlinable @inline(__always)
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
  @inlinable @inline(__always)
  public static var m: CUnsignedInt { umod }
}

@usableFromInline
protocol static_mod_value: static_mod {
  static var mod: mod_value { get }
}

extension static_mod_value {
  @inlinable
  static var umod: CUnsignedInt { mod.umod }
  @inlinable
  static var isPrime: Bool { mod.isPrime }
}

// MARK: -

extension barrett: ExpressibleByIntegerLiteral {
  @inlinable @inline(__always)
  public init(integerLiteral value: CInt) {
    self.init(value)
  }
}

public protocol dynamic_mod {
  static var bt: barrett { get set }
}

extension dynamic_mod {
  @inlinable @inline(__always)
  public static var umod: CUnsignedInt { bt.umod() }
  @inlinable @inline(__always)
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
  @inlinable @inline(__always)
  public static var `default`: Self { 998_244_353 }
}

extension barrett: Equatable {
  @inlinable @inline(__always)
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

public typealias ModIntAdaptions = Hashable & AdditiveArithmetic
  & ExpressibleByIntegerLiteral & CustomStringConvertible

public protocol modint_base: ModIntAdaptions {
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
  @inlinable @inline(__always)
  public static func + <I: FixedWidthInteger>(lhs: I, rhs: Self) -> Self { Self(lhs) + rhs }
  @inlinable @inline(__always)
  public static func + <I: FixedWidthInteger>(lhs: Self, rhs: I) -> Self { lhs + Self(rhs) }
  @inlinable @inline(__always)
  public static func - <I: FixedWidthInteger>(lhs: I, rhs: Self) -> Self { Self(lhs) - rhs }
  @inlinable @inline(__always)
  public static func - <I: FixedWidthInteger>(lhs: Self, rhs: I) -> Self { lhs - Self(rhs) }
  @inlinable @inline(__always)
  public static func * <I: FixedWidthInteger>(lhs: I, rhs: Self) -> Self { Self(lhs) * rhs }
  @inlinable @inline(__always)
  public static func * <I: FixedWidthInteger>(lhs: Self, rhs: I) -> Self { lhs * Self(rhs) }
  @inlinable @inline(__always)
  public static func / <I: FixedWidthInteger>(lhs: I, rhs: Self) -> Self { Self(lhs) / rhs }
  @inlinable @inline(__always)
  public static func / <I: FixedWidthInteger>(lhs: Self, rhs: I) -> Self { lhs / Self(rhs) }
  @inlinable @inline(__always)
  public static func += <I: FixedWidthInteger>(lhs: inout Self, rhs: I) { lhs += Self(rhs) }
  @inlinable @inline(__always)
  public static func -= <I: FixedWidthInteger>(lhs: inout Self, rhs: I) { lhs -= Self(rhs) }
  @inlinable @inline(__always)
  public static func *= <I: FixedWidthInteger>(lhs: inout Self, rhs: I) { lhs *= Self(rhs) }
  @inlinable @inline(__always)
  public static func /= <I: FixedWidthInteger>(lhs: inout Self, rhs: I) { lhs /= Self(rhs) }
}

@inlinable @inline(__always)
func __modint_v<T: UnsignedInteger>(unsigned v: T, umod: CUnsignedInt) -> CUnsignedInt {
  CUnsignedInt(truncatingIfNeeded: v % T(umod))
}

@inlinable @inline(__always)
func ___modint_v<T: BinaryInteger>(_ v: T, umod: CUnsignedInt) -> CUnsignedInt {
  let umod = T(truncatingIfNeeded: umod)
  var x = v % umod
  if x < 0 { x += umod }
  let x0 = CInt(truncatingIfNeeded: x)
  return CUnsignedInt(bitPattern: x0)
}

extension modint_base {
  @usableFromInline typealias ULL = CUnsignedLongLong
  @usableFromInline typealias LL = CLongLong
  @usableFromInline typealias UINT = CUnsignedInt
}

extension modint_base {
  @inlinable
  public var description: String { val.description }
}

@usableFromInline
protocol modint_raw {
  init(raw: CUnsignedInt)
  var _v: CUnsignedInt { get set }
  var val: CInt { get }
  static var mod: CInt { get }
  static var umod: CUnsignedInt { get }
}

extension modint_raw {
  @inlinable @inline(__always)
  public init(integerLiteral value: CInt) {
    self.init(raw: value == 0 ? 0 : ___modint_v(value, umod: Self.umod))
  }
  @inlinable
  public init(bitPattern i: CUnsignedInt) {
    self.init(raw: __modint_v(unsigned: i, umod: Self.umod))
  }
  @inlinable
  public var unsigned: CUnsignedInt { .init(bitPattern: val) }
}
