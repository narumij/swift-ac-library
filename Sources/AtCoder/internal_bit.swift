import Foundation

extension _Internal {
    
    @usableFromInline
    static func bit_ceil<INT: FixedWidthInteger>(_ n: UInt32) -> INT {
        var x: CUnsignedInt = 1
        while x < n { x *= 2 }
        return INT(x)
    }
    
    @usableFromInline
    static func bit_ceil(_ n: UInt64) -> Int {
        var x = 1
        while x < n { x *= 2 }
        return x
    }

    @usableFromInline
    static func countr_zero<INT: FixedWidthInteger>(_ x: UInt32) -> INT {
        if x == 0 { return 32 }
        var n: UInt32 = 1
        var x = x
        if x & 0x0000FFFF == 0 { n = n + 16; x = x >> 16 }
        if x & 0x000000FF == 0 { n = n +  8; x = x >>  8 }
        if x & 0x0000000F == 0 { n = n +  4; x = x >>  4 }
        if x & 0x00000003 == 0 { n = n +  2; x = x >>  2 }
        return INT(n - x & 1)
    }
    
    @usableFromInline
    static func countr_zero(_ x: UInt64) -> Int {
        if x == 0 { return 64 }
        var n: UInt64 = 1
        var x = x
        if x & 0xFFFFFFFF == 0 { n = n + 32; x = x >> 32 }
        if x & 0x0000FFFF == 0 { n = n + 16; x = x >> 16 }
        if x & 0x000000FF == 0 { n = n +  8; x = x >>  8 }
        if x & 0x0000000F == 0 { n = n +  4; x = x >>  4 }
        if x & 0x00000003 == 0 { n = n +  2; x = x >>  2 }
        return Int(n - x & 1)
    }
}
