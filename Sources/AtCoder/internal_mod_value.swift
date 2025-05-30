import Foundation

// MARK: -

/*
 releaseビルドでテストが通る範囲を拡大したかったため、復帰
 */

public struct mod_value {

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
  public nonisolated(unsafe) static let mod_998_244_353: mod_value = 998_244_353
  public nonisolated(unsafe) static let mod_1_000_000_007: mod_value = 1_000_000_007
  public nonisolated(unsafe) static let mod_INT32_MAX: mod_value = 2_147_483_647
  public nonisolated(unsafe) static let mod_UINT32_MAX: mod_value = -1
}

extension mod_value: ExpressibleByIntegerLiteral {
  @inlinable @inline(__always)
  public init(integerLiteral value: CInt) {
    self.umod = CUnsignedInt(bitPattern: value)
    self.isPrime = _Internal.is_prime(value)
  }
}

public
protocol static_mod_value: static_mod {
  static var mod: mod_value { get }
}

extension static_mod_value {
  public
  static var umod: CUnsignedInt { _read { yield mod.umod } }
  public
  static var isPrime: Bool { _read { yield mod.isPrime } }
}
