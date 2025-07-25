import Foundation

// MARK: -

// できるだけキャストを減らす修正の一環でCUunsignedIntではなくUIntを採用している
// 内部計算に制限があり、UIntの幅全てが使えるわけでは無いことに注意
// クラッシュは取れたが、性能は出ない模様
public protocol static_mod {
  /// - Important: 1 ... CUnsingedInt.maxまで有効。それ以外は未定義
  static var umod: UInt { get }
  // 素数判定を自動では行わないため、注意が必要
  // 素数以外を利用する場合、オーバーライドする必要がある
  static var isPrime: Bool { get }
}

extension static_mod {
  @inlinable
  public static var m: UInt {
    @inline(__always) _read {
      yield umod
    }
  }
  @inlinable @inline(__always)
  public static var isPrime: Bool {
    assert(_Internal.is_prime(Int(umod)), "\(umod) is not prime number.")
    return true
  }
}

public enum mod_998_244_353: static_mod {
  public static let umod: UInt = 998_244_353
}

public enum mod_1_000_000_007: static_mod {
  public static let umod: UInt = 1_000_000_007
}

// MARK: -

extension barrett: ExpressibleByIntegerLiteral {
  /// - Important: 1 ... CUnsingedInt.maxまで有効。それ以外は未定義
  @inlinable @inline(__always)
  public init(integerLiteral value: Int) {
    self.init(value)
  }
}

public protocol dynamic_mod {
  static var bt: barrett { get set }
}

extension dynamic_mod {
  @inlinable @inline(__always)
  public static var umod: UInt { bt.umod() }
  @inlinable @inline(__always)
  static func mul(_ a: UInt, _ b: UInt) -> UInt {
    bt.mul(a, b)
  }
  @inlinable
  public static func set_mod(_ m: Int) {
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

public protocol modint_base: Hashable & Numeric & AdditiveArithmetic
    & ExpressibleByIntegerLiteral & CustomStringConvertible
{
  init()
  init(_ v: Bool)
  init(_ v: Int)
  init<T: FixedWidthInteger>(_ v: T)
  // できるだけキャストを減らす修正の一環でCIntではなくIntを採用している
  var val: Int { get }
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
  @inlinable
  public var description: String { val.description }
}

// MARK: -

@inlinable @inline(__always)
func __modint_v(bool v: Bool, umod: UInt) -> UInt {
  (v ? 1 : 0) % umod
}

@inlinable @inline(__always)
func __modint_v(UInt v: UInt, umod: UInt) -> UInt {
  v % umod
}

@inlinable @inline(__always)
func __modint_v<T: UnsignedInteger>(unsigned v: T, umod: UInt) -> UInt {
  UInt(v) % umod
}

@inlinable @inline(__always)
func __modint_v<T: FixedWidthInteger>(_ v: T, umod: UInt) -> UInt {
  let umod = T(umod)
  var x = v % umod
  if x < 0 { x += umod }
  let x0 = Int(x)
  return UInt(bitPattern: x0)
}

@usableFromInline
protocol modint_raw {
  init(rawValue: UInt)
  var _v: UInt { get set }
  var val: Int { get }
  static var mod: Int { get }
  static var umod: UInt { get }
}

extension modint_raw {

  @inlinable @inline(__always)
  public init(_ v: Bool) {
    self.init(rawValue: __modint_v(bool: v, umod: Self.umod))
  }
  @inlinable @inline(__always)
  public init<T: FixedWidthInteger>(_ v: T) {
    self.init(rawValue: __modint_v(v, umod: Self.umod))
  }
}

extension modint_raw {
  @inlinable @inline(__always)
  public init(integerLiteral value: Int) {
    self.init(value)
  }
}

extension modint_raw {
  @inlinable @inline(__always)
  public init(bitPattern i: UInt) {
    self.init(rawValue: __modint_v(UInt: i, umod: Self.umod))
  }
  @inlinable
  public var unsigned: UInt {
    @inline(__always) _read {
      yield _v
    }
  }
}

extension modint_raw { // Numeric Comformance
  
  public init?<T>(exactly source: T) where T : BinaryInteger {
    guard
      let s = UInt(exactly: source),
      s < Self.umod
    else {
      return nil
    }
    
    self.init(rawValue: s)
  }
  
  public var magnitude: UInt.Magnitude {
    _v.magnitude
  }
  
  public typealias Magnitude = UInt.Magnitude
}
