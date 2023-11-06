import Foundation

enum `internal` {

    static func bit_ceil(_ n: UInt) -> UInt {
        var x: UInt = 1;
        while (x < UInt(n)) { x *= 2; }
        return x;
    }

    static func countr_zero(_ x: UInt) -> Int {
        if x == 0 { return 64 }
        var n: UInt = 1
        var x = x
        if x & 0xFFFFFFFF == 0 { n = n + 32; x = x >> 32 }
        if x & 0x0000FFFF == 0 { n = n + 16; x = x >> 16 }
        if x & 0x000000FF == 0 { n = n + 8; x = x >> 8 }
        if x & 0x0000000F == 0 { n = n + 4; x = x >> 4 }
        if x & 0x00000003 == 0 { n = n + 2; x = x >> 2 }
        return Int(n - x & 1)
    }
}
