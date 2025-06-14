import Foundation

extension _Internal {

  /// @return same with std::bit::bit_ceil
  @inlinable
  @inline(__always)
  static func bit_ceil(_ n: Int) -> Int {
    return n <= 1 ? 1 : 1 << (Int.bitWidth - (n - 1).leadingZeroBitCount)
  }

  /// @param n `1 <= n`
  /// @return same with std::bit::countr_zero
  @available(*, deprecated, renamed: "trailingZeroBitCount")
  @inlinable
  static func countr_zero_constexpr<I: FixedWidthInteger>(_ n: I) -> Int {
    assert(1 <= n)
    return n.trailingZeroBitCount
  }

  /// @param n `1 <= n`
  /// @return same with std::bit::countr_zero
  @available(*, deprecated, renamed: "trailingZeroBitCount")
  @inlinable
  @inline(__always)
  static func countr_zero<I: FixedWidthInteger>(_ n: I) -> Int {
    assert(1 <= n)
    return n.trailingZeroBitCount
  }
}
