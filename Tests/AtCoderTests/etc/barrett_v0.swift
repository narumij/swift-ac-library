import Foundation
@testable import AtCoder

extension _Internal {
    
    // Fast modular multiplication by barrett reduction
    // Reference: https://en.wikipedia.org/wiki/Barrett_reduction
    // NOTE: reconsider after Ice Lake
    struct barrett_v0 {
        let _m: CUnsignedInt;
        let im: CUnsignedLongLong;
        
        // @param m `1 <= m`
        init(_ m: CUnsignedInt) { _m = m; im = CUnsignedLongLong(bitPattern: -1) / CUnsignedLongLong(m) &+ 1 }
        //    init(_ m: UInt) { self.init(UInt32(m)) }
        
        // @return m
        func umod() -> CUnsignedInt { return _m; }
        
        // @param a `0 <= a < m`
        // @param b `0 <= b < m`
        // @return `a * b % m`
        func mul(_ a: CUnsignedInt,_ b: CUnsignedInt) -> CUnsignedInt {
            // [1] m = 1
            // a = b = im = 0, so okay
            
            // [2] m >= 2
            // im = ceil(2^64 / m)
            // -> im * m = 2^64 + r (0 <= r < m)
            // let z = a*b = c*m + d (0 <= c, d < m)
            // a*b * im = (c*m + d) * im = c*(im*m) + d*im = c*2^64 + c*r + d*im
            // c*r + d*im < m * m + m * im < m * m + 2^64 + m <= 2^64 + m * (m + 1) < 2^64 * 2
            // ((ab * im) >> 64) == c or c + 1
            var z = CUnsignedLongLong(a);
            z &*= CUnsignedLongLong(b);
            let x = z.multipliedFullWidth(by: CUnsignedLongLong(im)).high
            let y = x * CUnsignedLongLong(_m);
            return CUnsignedInt(z &- y &+ (z < y ? CUnsignedLongLong(_m) : 0));
        }
    };
}
