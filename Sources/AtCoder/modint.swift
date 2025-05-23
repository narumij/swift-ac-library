import Foundation

public protocol static_modint_base: modint_base {}

public protocol dynamic_modint_base: modint_base {
  static func set_mod(_ m: CInt)
}

public struct static_modint<m: static_mod>: static_modint_base & modint_raw {
  @usableFromInline
  typealias static_mod = m

  @inlinable @inline(__always)
  public init() {
      _v = 0
  }

  @inlinable @inline(__always)
  init(raw v: CUnsignedInt) {
    _v = v
  }

  @usableFromInline
  var _v: CUnsignedInt
}

extension static_modint {

  @inlinable @inline(__always)
  public static var mod: CInt { return CInt(bitPattern: m.umod) }

  @inlinable @inline(__always)
  public var val: CInt { return .init(bitPattern: _v) }

  @inlinable
  public static func += (lhs: inout Self, rhs: Self) {
    lhs._v &+= rhs._v
    if lhs._v >= umod { lhs._v &-= umod }
  }
  @inlinable
  public static func -= (lhs: inout Self, rhs: Self) {
    lhs._v &-= rhs._v
    if lhs._v >= umod { lhs._v &+= umod }
  }
  @inlinable
  public static func *= (lhs: inout Self, rhs: Self) {
    var z: ULL = ULL(lhs._v)
    z &*= ULL(rhs._v)
    lhs._v = UINT(z % ULL(umod))
  }
  @inlinable
  public static func /= (lhs: inout Self, rhs: Self) {
    lhs = lhs * rhs.inv
  }
  @inlinable @inline(__always)
  public static prefix func + (_ m: Self) -> Self {
    return m
  }
  @inlinable @inline(__always)
  public static prefix func - (_ m: Self) -> Self {
    return .init(raw: 0) - m
  }
  @inlinable
  public static func + (lhs: Self, rhs: Self) -> Self {
    var _v = lhs._v &+ rhs._v
    if _v >= umod { _v &-= umod }
    return .init(raw: _v)
  }
  @inlinable
  public static func - (lhs: Self, rhs: Self) -> Self {
    var _v = lhs._v &- rhs._v
    if _v >= umod { _v &+= umod }
    return .init(raw: _v)
  }
  @inlinable
  public static func * (lhs: Self, rhs: Self) -> Self {
    var z: ULL = ULL(lhs._v)
    z &*= ULL(rhs._v)
    return .init(raw: UINT(z % ULL(umod)))
  }
  @inlinable
  public static func / (lhs: Self, rhs: Self) -> Self {
    lhs * rhs.inv
  }
  @inlinable
  public func pow<LL: SignedInteger>(_ n: LL) -> Self {
    pow(CLongLong(n))
  }
  @inlinable
  public func pow(_ n: CLongLong) -> Self {
    assert(0 <= n)
    var n = n
    var x = self
    var r: Self = .init(raw: 1)
    while n != 0 {
      if (n & 1) != 0 { r *= x }
      x *= x
      n >>= 1
    }
    return r
  }
  @inlinable
  public var inv: Self {
    if isPrime {
      assert(_v != 0)
      return pow(LL(Self.umod) - 2)
    } else {
      let eg = _Internal.inv_gcd(LL(_v), LL(m.m))
      assert(eg.first == 1)
      return Self.init(CInt(eg.second))
    }
  }

  @inlinable @inline(__always)
  public static var umod: CUnsignedInt { m.umod }

  @inlinable @inline(__always)
  var isPrime: Bool { m.isPrime }
}

public struct dynamic_modint<bt: dynamic_mod>: dynamic_modint_base & modint_raw {

  @inlinable @inline(__always)
  public init() {
      _v = 0
  }

  @inlinable @inline(__always)
  init(raw v: CUnsignedInt) {
    _v = v
  }

  @usableFromInline
  var _v: CUnsignedInt

  @inlinable
  public static func set_mod(_ m: CInt) {
    bt.set_mod(m)
  }
}

extension dynamic_modint {

  @inlinable @inline(__always)
  public static var mod: CInt { return CInt(bitPattern: bt.umod) }

  @inlinable
  public var val: CInt { return .init(bitPattern: _v) }

  @inlinable
  public static func += (lhs: inout Self, rhs: Self) {
    lhs._v &+= rhs._v
    if lhs._v >= umod { lhs._v &-= umod }
  }
  @inlinable
  public static func -= (lhs: inout Self, rhs: Self) {
    lhs._v &+= umod &- rhs._v
    if lhs._v >= umod { lhs._v &-= umod }
  }
  @inlinable
  public static func *= (lhs: inout Self, rhs: Self) {
    lhs._v = bt.mul(lhs._v, rhs._v)
  }
  @inlinable
  public static func /= (lhs: inout Self, rhs: Self) {
    lhs *= rhs.inv
  }
  @inlinable
  public static prefix func + (_ m: Self) -> Self {
    return m
  }
  @inlinable
  public static prefix func - (_ m: Self) -> Self {
    return .init(raw: 0) - m
  }
  @inlinable
  public static func + (lhs: Self, rhs: Self) -> Self {
    var _v = lhs._v &+ rhs._v
    if _v >= umod { _v &-= umod }
    return .init(raw: _v)
  }
  @inlinable
  public static func - (lhs: Self, rhs: Self) -> Self {
    var _v = lhs._v &+ umod &- rhs._v
    if _v >= umod { _v &-= umod }
    return .init(raw: _v)
  }
  @inlinable
  public static func * (lhs: Self, rhs: Self) -> Self {
    let _v = bt.mul(lhs._v, rhs._v)
    return .init(raw: _v)
  }
  @inlinable
  public static func / (lhs: Self, rhs: Self) -> Self {
    lhs * rhs.inv
  }

  @inlinable
  public func pow<LL: SignedInteger>(_ n: LL) -> Self {
    pow(CLongLong(n))
  }

  @inlinable
  public func pow(_ n: CLongLong) -> Self {
    assert(0 <= n)
    var n = n
    var x = self
    var r: Self = .init(raw: 1)
    while n != 0 {
      if (n & 1) != 0 { r *= x }
      x *= x
      n >>= 1
    }
    return r
  }

  @inlinable
  public var inv: Self {
    let eg = _Internal.inv_gcd(LL(_v), LL(Self.mod))
    assert(eg.first == 1)
    return .init(CInt(eg.second))
  }

  @inlinable @inline(__always)
  public static var umod: CUnsignedInt { return bt.umod }
}

public typealias modint998244353 = static_modint<mod_998_244_353>
public typealias modint1000000007 = static_modint<mod_1_000_000_007>

public typealias modint = dynamic_modint<mod_dynamic>
