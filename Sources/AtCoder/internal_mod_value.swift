import Foundation

// MARK: -

public struct mod_value {

  /// - Important: 1 ... CUnsingedInt.maxまで有効。それ以外は未定義
  @inlinable @inline(__always)
  public init(_ m: UInt) {
    self.umod = m
    self.isPrime = _Internal.is_prime(Int(m))
  }

  /// - Important: 1 ... CUnsingedInt.maxまで有効。それ以外は未定義
  @inlinable @inline(__always)
  public init(_ m: Int) {
    self.umod = UInt(bitPattern: m)
    self.isPrime = _Internal.is_prime(m)
  }

  @usableFromInline
  let umod: UInt

  @usableFromInline
  let isPrime: Bool
}

extension mod_value: Sendable { }

extension mod_value {
  public static let mod_998_244_353: mod_value = 998_244_353
  public static let mod_1_000_000_007: mod_value = 1_000_000_007
  public static let mod_INT32_MAX: mod_value = 2_147_483_647
  public static let mod_UINT32_MAX: mod_value = -1
}

extension mod_value: ExpressibleByIntegerLiteral {
  /// - Important: 1 ... CUnsingedInt.maxまで有効。それ以外は未定義
  @inlinable @inline(__always)
  public init(integerLiteral value: CInt) {
    self.init(UInt(CUnsignedInt(bitPattern: value)))
  }
}

public
  protocol static_mod_value: static_mod
{
  static var mod: mod_value { get }
}

extension static_mod_value {

  @inlinable
  public static var umod: UInt {
    @inline(__always) _read {
      yield mod.umod
    }
  }

  @inlinable
  public static var isPrime: Bool {
    @inline(__always) _read {
      yield mod.isPrime
    }
  }
}
