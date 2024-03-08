import Foundation

extension _Internal {
    
    /// @return same with std::bit::bit_ceil
    @inlinable
    static func bit_ceil<INT: FixedWidthInteger>(_ n: UInt32) -> INT {
        INT(n <= 1 ? 1 : 1 << (UInt32.bitWidth - (n - 1).leadingZeroBitCount))
    }
    
    @inlinable
    static func bit_ceil(_ n: UInt64) -> Int {
        n <= 1 ? 1 : 1 << (UInt64.bitWidth - (n - 1).leadingZeroBitCount)
    }

    /// @param n `1 <= n`
    /// @return same with std::bit::countr_zero
    @inlinable
    static func countr_zero<INT: FixedWidthInteger>(_ x: UInt32) -> INT {
        INT(x.trailingZeroBitCount)
    }
    
    /// @param n `1 <= n`
    /// @return same with std::bit::countr_zero
    @inlinable
    static func countr_zero_constexpr<INT: FixedWidthInteger>(_ x: UInt32) -> INT {
        countr_zero(x)
    }

    @inlinable
    static func countr_zero(_ x: UInt64) -> Int {
        x.trailingZeroBitCount
    }
}
