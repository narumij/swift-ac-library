import Foundation

// MARK: -

public struct mod_value {

  @inlinable @inline(__always)
  public init<Integer: BinaryInteger>(_ m: Integer) {
    self.umod = UInt(m)
    self.isPrime = _Internal.is_prime(CInt(m))
  }

  @usableFromInline
  let umod: UInt

  @usableFromInline
  let isPrime: Bool
}

extension mod_value {
  public nonisolated(unsafe) static let mod_998_244_353: mod_value = 998_244_353
  public nonisolated(unsafe) static let mod_1_000_000_007: mod_value = 1_000_000_007
  public nonisolated(unsafe) static let mod_INT32_MAX: mod_value = 2_147_483_647
  public nonisolated(unsafe) static let mod_UINT32_MAX: mod_value = -1
}

extension mod_value: ExpressibleByIntegerLiteral {
  @inlinable @inline(__always)
  public init(integerLiteral value: Int) {
    self.umod = UInt(bitPattern: value)
    self.isPrime = _Internal.is_prime(CInt(value))
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
