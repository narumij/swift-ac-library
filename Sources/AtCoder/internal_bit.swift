import Foundation

extension _Internal {

  /// @param n `1 <= n`
  /// @return same with std::bit::countr_zero
  @inlinable
  @inline(__always)
  static func bit_ceil<I: FixedWidthInteger>(_ n: I) -> Int {
    return n <= 1 ? 1 : 1 << (I.bitWidth - (n - 1).leadingZeroBitCount)
  }

  /// @param n `1 <= n`
  /// @return same with std::bit::countr_zero
  @inlinable
  static func countr_zero_constexpr<I: FixedWidthInteger>(_ n: I) -> Int {
    assert(1 <= n)
    return n.trailingZeroBitCount
  }

  /// @param n `1 <= n`
  /// @return same with std::bit::countr_zero
  @inlinable
  @inline(__always)
  static func countr_zero<I: FixedWidthInteger>(_ n: I) -> Int {
    assert(1 <= n)
    return n.trailingZeroBitCount
  }
}
