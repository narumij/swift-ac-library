import Foundation

extension _Internal {
    
    /// @return same with std::bit::bit_ceil
    @usableFromInline
    static func bit_ceil<INT: FixedWidthInteger>(_ n: UInt32) -> INT {
#if false
        var x: CUnsignedInt = 1
        while x < n { x *= 2 }
        return INT(x)
#else
        INT(n <= 1 ? 1 : 1 << (UInt32.bitWidth - (n - 1).leadingZeroBitCount))
#endif
    }
    
    @usableFromInline
    static func bit_ceil(_ n: UInt64) -> Int {
#if false
        var x = 1
        while x < n { x *= 2 }
        return x
#else
        n <= 1 ? 1 : 1 << (UInt64.bitWidth - (n - 1).leadingZeroBitCount)
#endif
    }

    /// @param n `1 <= n`
    /// @return same with std::bit::countr_zero
    @usableFromInline
    static func countr_zero<INT: FixedWidthInteger>(_ x: UInt32) -> INT {
        INT(x.trailingZeroBitCount)
    }
    
    static var memoize_countr_zero: Memoized<UInt32,UInt32> = .init(source: countr_zero)
    /// @param n `1 <= n`
    /// @return same with std::bit::countr_zero
    static func countr_zero_constexpr<INT: FixedWidthInteger>(_ x: UInt32) -> INT {
        INT(memoize_countr_zero.get(x))
    }

    @usableFromInline
    static func countr_zero(_ x: UInt64) -> Int {
        x.trailingZeroBitCount
    }
}
