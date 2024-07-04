import Foundation

extension Array {
    
    mutating func resize(_ n: Int, element: Element) {
        
        if count > n {
            removeLast(count - n)
            return
        }

        let c = count
        
        self = .init(unsafeUninitializedCapacity: n, initializingWith: { buffer, initializedCount in
            self.withUnsafeBufferPointer { o in
                let old = o.baseAddress!
                for i in 0 ..< n {
#if true
                    if i < c {
                        buffer[i] = i < c ? old[i] : element
                    } else {
                        buffer[i] = element
                    }
#else
                    if i < c {
                        buffer.initializeElement(at: i, to: old[i])
                    } else {
                        buffer.initializeElement(at: i, to: element)
                    }
#endif
                }
            }
            initializedCount = n
        })
    }
}

public extension Array where Element: AdditiveArithmetic {
    mutating func resize(_ n: Int) {
        resize(n, element: .zero)
    }
}

fileprivate extension static_modint {
    init(unsigned v: CUnsignedLongLong, umod: CUnsignedLongLong) { _v = __modint_v(v, umod: umod) }
}

extension _Internal {
    
    public struct fft_info<mod: static_mod> {
        public typealias mint = static_modint<mod>
        
        public var root: [mint]
        public var iroot: [mint]
        
        public var rate2: [mint]
        public var irate2: [mint]
        
        public var rate3: [mint]
        public var irate3: [mint]
        
        public init() {
            
            let g: CInt = _Internal.primitive_root(mint.mod)
            let rank2: Int = _Internal.countr_zero_constexpr(UInt32(mint.mod) - 1)
            
            root = [mint](repeating: 0, count: rank2 + 1) // root[i]^(2^i) == 1
            iroot = [mint](repeating: 0, count: rank2 + 1) // root[i] * iroot[i] == 1
            
            rate2 = [mint](repeating: 0, count: max(0, rank2 - 2 + 1))
            irate2 = [mint](repeating: 0, count: max(0, rank2 - 2 + 1))
            
            rate3 = [mint](repeating: 0, count: max(0, rank2 - 3 + 1))
            irate3 = [mint](repeating: 0, count: max(0, rank2 - 3 + 1))

            root[rank2] = mint(g).pow(CLongLong((mint.mod - 1) >> rank2))
            iroot[rank2] = root[rank2].inv
            
            root.withUnsafeMutableBufferPointer { _root in
                let root = _root.baseAddress!
                
                iroot.withUnsafeMutableBufferPointer { _iroot in
                    let iroot = _iroot.baseAddress!
                    
                    // for (int i = rank2 - 1; i >= 0; i--) {
                    for i in stride(from: Int(rank2 - 1), through: 0, by: -1) {
                        root[i] = root[i + 1] * root[i + 1]
                        iroot[i] = iroot[i + 1] * iroot[i + 1]
                    }
                    
                    do {
                        var prod: mint = 1; var iprod: mint = 1
                        // for (int i = 0; i <= rank2 - 2; i++) {
                        for i in stride(from: 0, through: rank2 - 2, by: 1) {
                            rate2[i] = root[i + 2] * prod
                            irate2[i] = iroot[i + 2] * iprod
                            prod *= iroot[i + 2]
                            iprod *= root[i + 2]
                        }
                    }
                    
                    do {
                        var prod: mint = 1; var iprod: mint = 1
                        // for (int i = 0; i <= rank2 - 3; i++) {
                        for i in stride(from: 0, through: rank2 - 3, by: 1) {
                            rate3[i] = root[i + 3] * prod
                            irate3[i] = iroot[i + 3] * iprod
                            prod *= iroot[i + 3]
                            iprod *= root[i + 3]
                        }
                    }
                }
            }
        }
        
        struct __Unsafe {
            let root: UnsafePointer<mint>
            let iroot: UnsafePointer<mint>
            let rate2: UnsafePointer<mint>
            let irate2: UnsafePointer<mint>
            let rate3: UnsafePointer<mint>
            let irate3: UnsafePointer<mint>
        }
        
        func __unsafeHandle(_ f: (__Unsafe) -> Void) {
            root.withUnsafeBufferPointer { root in
                iroot.withUnsafeBufferPointer { iroot in
                    rate2.withUnsafeBufferPointer { rate2 in
                        irate2.withUnsafeBufferPointer { irate2 in
                            rate3.withUnsafeBufferPointer { rate3 in
                                irate3.withUnsafeBufferPointer { irate3 in
                                    let handle = __Unsafe(root:   root.baseAddress!,
                                                          iroot:  iroot.baseAddress!,
                                                          rate2:  rate2.baseAddress!,
                                                          irate2: irate2.baseAddress!,
                                                          rate3:  rate3.baseAddress!,
                                                          irate3: irate3.baseAddress!)
                                    f(handle)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func butterfly<mod: static_mod>(_ a: UnsafeMutablePointer<static_modint<mod>>, count n: Int) {
        typealias mint = static_modint<mod>
        
        let h: Int = CUnsignedInt(n).trailingZeroBitCount
        
        // static const fft_info<mint> info;
        let info = fft_info<mod>()
        let umod = ULL(mod.umod)
        var len: Int = 0  // a[i, i+(n>>len), i+2*(n>>len), ..] is transformed
        
        info.__unsafeHandle { info in
            
            while len < h {
                if h - len == 1 {
                    let p = 1 << (h - len - 1)
                    var rot: mint = 1
                    for s in 0 ..< (1 << len) {
                        let offset = s << (h - len)
                        for i in 0 ..< p {
                            let l = a[i + offset]
                            let r = a[i + offset + p] * rot
                            a[i + offset] = l + r
                            a[i + offset + p] = l - r
                        }
                        if s + 1 != 1 << len
                        { rot *= info.rate2[(~UINT(truncatingIfNeeded: s)).trailingZeroBitCount] }
                    }
                    len += 1
                } else {
                    // 4-base
                    let p = 1 << (h - len - 2)
                    var rot: mint = 1; let imag = info.root[2]
                    for s in 0 ..< (1 << len) {
                        let rot2 = rot * rot
                        let rot3 = rot2 * rot
                        let offset = s << (h - len)
                        for i in 0 ..< p {
                            let mod2: ULL = 1 * umod * umod
                            let a0: ULL = 1 * ULL(a[i + offset].val)
                            let a1: ULL = 1 * ULL(a[i + offset + p].val) * ULL(rot.val)
                            let a2: ULL = 1 * ULL(a[i + offset + 2 * p].val) * ULL(rot2.val)
                            let a3: ULL = 1 * ULL(a[i + offset + 3 * p].val) * ULL(rot3.val)
                            let a1na3imag =
                            1 * ULL(mint(unsigned: a1 + mod2 - a3, umod: umod).val) * ULL(imag.val)
                            let na2 = mod2 - a2
                            a[i + offset] = mint(unsigned: a0 + a2 + a1 + a3, umod: umod)
                            a[i + offset + 1 * p] = mint(unsigned: a0 + a2 + (2 * mod2 - (a1 + a3)), umod: umod)
                            a[i + offset + 2 * p] = mint(unsigned: a0 + na2 + a1na3imag, umod: umod)
                            a[i + offset + 3 * p] = mint(unsigned: a0 + na2 + (mod2 - a1na3imag), umod: umod)
                        }
                        if s + 1 != 1 << len
                        { rot *= info.rate3[(~UINT(truncatingIfNeeded: s)).trailingZeroBitCount] }
                    }
                    len += 2
                }
            }
        }
    }
    
    static func butterfly_inv<mod: static_mod>(_ a: UnsafeMutablePointer<static_modint<mod>>, count n: Int) {
        typealias mint = static_modint<mod>
        
        let h: Int = CUnsignedInt(n).trailingZeroBitCount
        
        // static const fft_info<mint> info;
        let info = fft_info<mod>()
        let umod = ULL(mod.umod)

        var len = h  // a[i, i+(n>>len), i+2*(n>>len), ..] is transformed
        
        info.__unsafeHandle { info in
            
            while len != 0 {
                if (len == 1) {
                    let p = 1 << (h - len)
                    var irot: mint = 1
                    for s in 0 ..< (1 << (len - 1)) {
                        let offset = s << (h - len + 1)
                        for i in 0 ..< p {
                            let l = a[i + offset]
                            let r = a[i + offset + p]
                            a[i + offset] = l + r
                            a[i + offset + p] = mint(unsigned:
                                                        (ULL(umod) + ULL(l.val) - ULL(r.val)) *
                                                     ULL(irot.val), umod: umod)
                        }
                        if s + 1 != 1 << (len - 1)
                        { irot *= info.irate2[(~UINT(truncatingIfNeeded: s)).trailingZeroBitCount] }
                    }
                    len -= 1
                } else {
                    // 4-base
                    let p = 1 << (h - len)
                    var irot: mint = 1; let iimag = info.iroot[2]
                    for s in 0 ..< (1 << (len - 2)) {
                        let irot2 = irot * irot
                        let irot3 = irot2 * irot
                        let offset = s << (h - len + 2)
                        for i in 0 ..< p {
                            let a0: ULL = 1 * ULL(a[i + offset + 0 * p].val)
                            let a1: ULL = 1 * ULL(a[i + offset + 1 * p].val)
                            let a2: ULL = 1 * ULL(a[i + offset + 2 * p].val)
                            let a3: ULL = 1 * ULL(a[i + offset + 3 * p].val)
                            
                            let a2na3iimag: ULL =
                            1 *
                            ULL(mint(unsigned: (umod + a2 - a3) * ULL(iimag.val), umod: umod).val)
                            a[i + offset] = mint(unsigned: a0 + a1 + a2 + a3, umod: umod)
                            a[i + offset + 1 * p] =
                            mint(unsigned: (a0 + (umod - a1) + a2na3iimag) * ULL(irot.val), umod: umod)
                            a[i + offset + 2 * p] =
                            mint(unsigned: (a0 + a1 + (umod - a2) + (umod - a3)) *
                                 ULL(irot2.val), umod: umod)
                            a[i + offset + 3 * p] =
                            mint(unsigned: (a0 + (umod - a1) + (umod - a2na3iimag)) *
                                 ULL(irot3.val), umod: umod)
                        }
                        if s + 1 != 1 << (len - 2)
                        { irot *= info.irate3[(~UINT(truncatingIfNeeded: s)).trailingZeroBitCount] }
                    }
                    len -= 2
                }
            }
        }
    }
    
    static func convolution_naive<mod: static_mod, A,B>(_ a: A, _ b: B) -> [static_modint<mod>]
    where A: Collection, A.Element == static_modint<mod>,
          B: Collection, B.Element == static_modint<mod>
    {
        let n = a.count, m = b.count
        var ans = [static_modint<mod>](repeating: 0, count: n + m - 1)
        if n < m {
            for j in 0 ..< m {
                for i in 0 ..< n {
                    ans[i + j] += a[a.index(a.startIndex, offsetBy:i)] * b[b.index(b.startIndex, offsetBy:j)]
                }
            }
        } else {
            for i in 0 ..< n {
                for j in 0 ..< m {
                    ans[i + j] += a[a.index(a.startIndex, offsetBy:i)] * b[b.index(b.startIndex, offsetBy:j)]
                }
            }
        }
        return ans
    }
    
    static func convolution_fft<mod: static_mod,A,B>(_ a: A,_ b: B) -> [static_modint<mod>]
    where A: Collection, A.Element == static_modint<mod>,
          B: Collection, B.Element == static_modint<mod>
    {
        var (a,b) = (a + [], b + [])
        let (n,m) = (a.count, b.count)
        let z: Int = _Internal.bit_ceil(CUnsignedInt(n + m - 1))
        a.resize(z,element: .init())
        b.resize(z,element: .init())
        a.withUnsafeMutableBufferPointer { a_buffer in
            let a = a_buffer.baseAddress!
            b.withUnsafeMutableBufferPointer { b_buffer in
                let b = b_buffer.baseAddress!
                _Internal.butterfly(a, count: z)
                _Internal.butterfly(b, count: z)
                for i in 0 ..< Int(z) {
                    a[i] *= b[i]
                }
                _Internal.butterfly_inv(a, count: z)
            }
        }
        a.resize(n + m - 1, element: .init())
        let iz = static_modint<mod>(z).inv
        a.withUnsafeMutableBufferPointer { a in
            for i in 0 ..< (n + m - 1) { a[i] *= iz }
        }
        return a
    }
}

public func convolution<mod: static_mod, A,B>(_ a: A,_ b: B) -> [static_modint<mod>]
where A: Collection, A.Element == static_modint<mod>,
      B: Collection, B.Element == static_modint<mod>
{
    let (n,m) = (a.count, b.count)
    if n == 0 || m == 0 { return [] }
    
    let z: CInt = _Internal.bit_ceil(CUnsignedInt(n + m - 1))
    assert((static_modint<mod>.mod - 1) % CInt(z) == 0)
    
    if min(n, m) <= 60 { return _Internal.convolution_naive(a, b) }
    return _Internal.convolution_fft(a, b)
}

public func convolution<mod: static_mod, T: FixedWidthInteger>(_ t: mod.Type,_ a: [T],_ b: [T]) -> [T] {
    
    let n = a.count, m = b.count
    if n == 0 || m == 0 { return [] }
    
    typealias mint = static_modint<mod>
    
    let z: Int = _Internal.bit_ceil(CUnsignedInt(n + m - 1))
    assert((Int(mint.mod) - 1) % z == 0)
    
    var a2 = [mint](repeating: 0, count: n), b2 = [mint](repeating: 0, count: m)
    for i in 0 ..< n {
        a2[i] = mint(a[i])
    }
    for i in 0 ..< m {
        b2[i] = mint(b[i])
    }
    let c2 = convolution(a2, b2)
    var c = [T](repeating: 0, count: n + m - 1)
    for i in 0 ..< (n + m - 1) {
        c[i] = T(c2[i].val)
    }
    return c
}

public func convolution<T: FixedWidthInteger>(_ a: [T],_ b: [T]) -> [T] {
    convolution(mod_998_244_353.self, a, b)
}

public func convolution_ll(_ a: [CLongLong],
                           _ b: [CLongLong]) -> [CLongLong] {
    let n = a.count, m = b.count
    if n == 0 || m == 0 { return [] }
    
    typealias ULL = CUnsignedLongLong
    typealias LL = CLongLong
    
    enum const {
        static let MOD1: ULL = 754974721  // 2^24
        static let MOD2: ULL = 167772161  // 2^25
        static let MOD3: ULL = 469762049  // 2^26
        static let M2M3: ULL = MOD2 &* MOD3
        static let M1M3: ULL = MOD1 &* MOD3
        static let M1M2: ULL = MOD1 &* MOD2
        static let M1M2M3: ULL = MOD1 &* MOD2 &* MOD3
        enum mod1: static_mod { static let umod = CUnsignedInt(MOD1); static let isPrime: Bool = false }
        enum mod2: static_mod { static let umod = CUnsignedInt(MOD2); static let isPrime: Bool = false }
        enum mod3: static_mod { static let umod = CUnsignedInt(MOD3); static let isPrime: Bool = false }
        static let i1 = ULL(_Internal.inv_gcd(LL(MOD2) * LL(MOD3), LL(MOD1)).second)
        static let i2 = ULL(_Internal.inv_gcd(LL(MOD1) * LL(MOD3), LL(MOD2)).second)
        static let i3 = ULL(_Internal.inv_gcd(LL(MOD1) * LL(MOD2), LL(MOD3)).second)
    }
    
    typealias mod1 = const.mod1
    typealias mod2 = const.mod2
    typealias mod3 = const.mod3
    
    let MOD1: ULL = const.MOD1
    let MOD2: ULL = const.MOD2
    let MOD3: ULL = const.MOD3
    let M2M3: ULL = const.M2M3
    let M1M3: ULL = const.M1M3
    let M1M2: ULL = const.M1M2
    let M1M2M3: ULL = const.M1M2M3
    
    let i1: ULL = const.i1
    let i2: ULL = const.i2
    let i3: ULL = const.i3
    
    let MAX_AB_BIT: ULL = 24
    assert(MOD1 % (1 << MAX_AB_BIT) == 1, "MOD1 isn't enough to support an array length of 2^24.")
    assert(MOD2 % (1 << MAX_AB_BIT) == 1, "MOD2 isn't enough to support an array length of 2^24.")
    assert(MOD3 % (1 << MAX_AB_BIT) == 1, "MOD3 isn't enough to support an array length of 2^24.")
    assert(n + m - 1 <= (1 << MAX_AB_BIT))
    
    let c1 = convolution(mod1.self, a, b)
    let c2 = convolution(mod2.self, a, b)
    let c3 = convolution(mod3.self, a, b)
    
    var c = [LL](repeating: 0, count: n + m - 1)
    for i in 0 ..< (n + m - 1) {
        var x: ULL = 0
        x &+= (ULL(bitPattern: c1[i]) * i1) % MOD1 &* M2M3
        x &+= (ULL(bitPattern: c2[i]) * i2) % MOD2 &* M1M3
        x &+= (ULL(bitPattern: c3[i]) * i3) % MOD3 &* M1M2
        // B = 2^63, -B <= x, r(real value) < B
        // (x, x - M, x - 2M, or x - 3M) = r (mod 2B)
        // r = c1[i] (mod MOD1)
        // focus on MOD1
        // r = x, x - M', x - 2M', x - 3M' (M' = M % 2^64) (mod 2B)
        // r = x,
        //     x - M' + (0 or 2B),
        //     x - 2M' + (0, 2B or 4B),
        //     x - 3M' + (0, 2B, 4B or 6B) (without mod!)
        // (r - x) = 0, (0)
        //           - M' + (0 or 2B), (1)
        //           -2M' + (0 or 2B or 4B), (2)
        //           -3M' + (0 or 2B or 4B or 6B) (3) (mod MOD1)
        // we checked that
        //   ((1) mod MOD1) mod 5 = 2
        //   ((2) mod MOD1) mod 5 = 3
        //   ((3) mod MOD1) mod 5 = 4
        var diff: LL =
        c1[i] - _Internal.safe_mod(LL(bitPattern: x), LL(bitPattern: MOD1))
        if diff < 0 { diff += LL(bitPattern: MOD1) }
        let offset: [ULL] = [
            0, 0, M1M2M3, 2 * M1M2M3, 3 * M1M2M3]
        x &-= offset[Int(diff % 5)]
        c[i] = LL(bitPattern: x)
    }
    
    return c
}
