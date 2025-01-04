import Foundation

// MARK: -

public protocol static_mod {
  static var umod: CUnsignedInt { get }
  // 素数判定を自動では行わないため、注意が必要
  static var isPrime: Bool { get }
}

extension static_mod {
  @inlinable @inline(__always)
  public static var m: CUnsignedInt { umod }
  @inlinable @inline(__always)
  public static var isPrime: Bool {
    assert(_Internal.is_prime(CInt(umod)), "\(umod) is not prime number.")
    return true
  }
}

public enum mod_998_244_353: static_mod {
  public static let umod: CUnsignedInt = 998_244_353
}

public enum mod_1_000_000_007: static_mod {
  public static let umod: CUnsignedInt = 1_000_000_007
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
  nonisolated(unsafe)
  public static var bt: barrett = .default
}

// MARK: -

public protocol modint_base: Hashable & AdditiveArithmetic
    & ExpressibleByIntegerLiteral & CustomStringConvertible
{
  init()
  init(_ v: Bool)
  init(_ v: CInt)
  init<T: FixedWidthInteger>(_ v: T)
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

extension modint_base {
  @usableFromInline typealias ULL = CUnsignedLongLong
  @usableFromInline typealias LL = CLongLong
  @usableFromInline typealias UINT = CUnsignedInt
}

extension modint_base {
  @inlinable
  public var description: String { val.description }
}

// MARK: -

@inlinable @inline(__always)
func __modint_v(bool v: Bool, umod: CUnsignedInt) -> CUnsignedInt {
  (v ? 1 : 0) % umod
}

@inlinable @inline(__always)
func __modint_v(ull v: CUnsignedLongLong, umod: CUnsignedInt) -> CUnsignedInt {
  CUnsignedInt(v % CUnsignedLongLong(umod))
}

@inlinable @inline(__always)
func __modint_v<T: UnsignedInteger>(unsigned v: T, umod: CUnsignedInt) -> CUnsignedInt {
  CUnsignedInt(v % T(umod))
}

@inlinable @inline(__always)
func __modint_v<T: FixedWidthInteger>(_ v: T, umod: CUnsignedInt) -> CUnsignedInt {
  let umod = T(umod)
  var x = v % umod
  if x < 0 { x += umod }
  let x0 = CInt(x)
  return CUnsignedInt(bitPattern: x0)
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
  public init(_ v: Bool) {
    self.init(raw: __modint_v(bool: v, umod: Self.umod))
  }
  @inlinable @inline(__always)
  public init<T: FixedWidthInteger>(_ v: T) {
    self.init(raw: __modint_v(v, umod: Self.umod))
  }
}

extension modint_raw {
  @inlinable @inline(__always)
  public init(integerLiteral value: CInt) {
    self.init(value)
  }
}

extension modint_raw {
  @inlinable @inline(__always)
  public init(bitPattern i: CUnsignedInt) {
    self.init(raw: __modint_v(unsigned: i, umod: Self.umod))
  }
  @inlinable @inline(__always)
  public var unsigned: CUnsignedInt { .init(bitPattern: val) }
}
