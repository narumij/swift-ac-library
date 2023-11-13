import Foundation

extension _internal {
    static func bit_ceil(_ n: CUnsignedInt) -> CUnsignedInt {
        var x: CUnsignedInt = 1;
        while (x < n) { x *= 2; }
        return x;
    }

    static func countr_zero(_ x: CUnsignedInt) -> CInt {
        if x == 0 { return 32 }
        var n: CUnsignedInt = 1
        var x = x
        if x & 0x0000FFFF == 0 { n = n + 16; x = x >> 16 }
        if x & 0x000000FF == 0 { n = n + 8;  x = x >> 8  }
        if x & 0x0000000F == 0 { n = n + 4;  x = x >> 4  }
        if x & 0x00000003 == 0 { n = n + 2;  x = x >> 2  }
        return CInt(n - x & 1)
    }
}

