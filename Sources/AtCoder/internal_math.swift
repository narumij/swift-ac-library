import Foundation

extension _Internal {
    // @param m `1 <= m`
    // @return x mod m
    static func safe_mod(_ x: CLongLong,_ m: CLongLong) -> CLongLong {
        var x = x
        x %= m
        if x < 0 { x += m }
        return x
    }
    
}

func imValue(_ _m: CUnsignedInt) -> CUnsignedLongLong {
    CUnsignedLongLong(bitPattern: -1) / CUnsignedLongLong(_m) &+ 1
}

func imValue(_ _m: CInt) -> CUnsignedLongLong {
    imValue(CUnsignedInt(bitPattern: _m))
}

// Fast modular multiplication by barrett reduction
// Reference: https://en.wikipedia.org/wiki/Barrett_reduction
// NOTE: reconsider after Ice Lake
public struct barrett {
    let m: CUnsignedInt
    let im: CUnsignedLongLong
    public init<Unsigned: UnsignedInteger>(_ _m: Unsigned) {
        m = CUnsignedInt(_m)
        im = imValue(CUnsignedInt(_m))
    }
    public init<Signed: SignedInteger>(_ _m: Signed) {
        m = CUnsignedInt(bitPattern: CInt(_m))
        im = imValue(CInt(_m))
    }
    
    // @return m
    @usableFromInline func umod() -> CUnsignedInt { return m; }
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
        var z = CUnsignedLongLong(a)
        z &*= CUnsignedLongLong(b)
        let x = z.multipliedFullWidth(by: CUnsignedLongLong(im)).high
        let y = x &* CUnsignedLongLong(m)
        return CUnsignedInt(z &- y &+ (z < y ? CUnsignedLongLong(m) : 0))
    }
}

extension _Internal {
    
    // @param n `0 <= n`
    // @param m `1 <= m`
    // @return `(x ** n) % m`
    static func _pow_mod_constexpr(_ x: CLongLong,_ n: CLongLong,_ m: CInt) -> CLongLong {
        var n = n
        if m == 1 { return 0 }
        let _m = CLongLong(CUnsignedInt(m))
        var r = 1 as CLongLong
        var y = safe_mod(x, CLongLong(m))
        while (n) != 0 {
            if n & 1 != 0 { r = (r * y) % _m }
            y = (y &* y) % _m
            n >>= 1
        }
        return r
    }
    
    static var memoized_pow_mod: Memoized3 = .init(source: _pow_mod_constexpr)
    static func pow_mod_constexpr(_ x: CLongLong,_ n: CLongLong,_ m: CInt) -> CLongLong { memoized_pow_mod.get(x,n,m) }

    // Reference:
    // M. Forisek and J. Jancina,
    // Fast Primality Testing for Integers That Fit into a Machine Word
    // @param n `0 <= n`
    static func _is_prime_constexpr(_ n: CInt) -> Bool {
        if n <= 1 { return false }
        if ((1 << n) & (1 << 2 | 1 << 7 | 1 << 61)) != 0 { return true }
        if 1 & n == 0 { return false }
        var d = CLongLong(n - 1)
        while 1 & d == 0 { d >>= 1 }
        let bases: [CLongLong] = [2, 7, 61]
        for a in bases {
            var t: CLongLong = d
            var y: CLongLong = pow_mod_constexpr(a, t, n)
            let n = CLongLong(n)
            while t != n - 1, y != 1, y != n - 1 {
                y = y * y % n
                t <<= 1
            }
            if y != n - 1, t & 1 == 0 {
                return false
            }
        }
        return true
    }
    
    static var memoized_is_prime: Memoized = .init(source: _is_prime_constexpr)
    static func is_prime_constexpr(_ n: CInt) -> Bool { memoized_is_prime.get(n) }
    static func is_prime(_ n: CInt) -> Bool { is_prime_constexpr(n) }
    
    // @param b `1 <= b`
    // @return pair(g, x) s.t. g = gcd(a, b), xa = g (mod b), 0 <= x < b/g
    static func inv_gcd(_ a: CLongLong,_ b: CLongLong) -> (first: CLongLong, second: CLongLong) {
        let a = safe_mod(a, b)
        if a == 0 { return (b, 0) }
        
        // Contracts:
        // [1] s - m0 * a = 0 (mod b)
        // [2] t - m1 * a = 0 (mod b)
        // [3] s * |m1| + t * |m0| <= b
        var s = b, t = a
        var m0: CLongLong = 0, m1: CLongLong = 1
        
        while t != 0 {
            let u: CLongLong = s / t
            s -= t * u
            m0 -= m1 * u  // |m1 * u| <= |m1| * s <= b
            
            // [3]:
            // (s - t * u) * |m1| + t * |m0 - m1 * u|
            // <= s * |m1| - t * u * |m1| + t * (|m0| + |m1| * u)
            // = s * |m1| + t * |m0| <= b
            
            var tmp = s
            s = t
            t = tmp
            tmp = m0
            m0 = m1
            m1 = tmp
        }
        // by [3]: |m0| <= b/g
        // by g != b: |m0| < b/g
        if m0 < 0 { m0 += b / s }
        return (s, m0)
    }
    
    // Compile time primitive root
    // @param m must be prime
    // @return primitive root (and minimum in now)
    static func _primitive_root_constexpr(_ m: CInt) -> CInt {
        if m == 2 { return 1 }
        if m == 167772161 { return 3 }
        if m == 469762049 { return 3 }
        if m == 754974721 { return 11 }
        if m == 998244353 { return 3 }
        var divs = [CInt](repeating: 0, count: 20)
        divs[0] = 2
        var cnt = 1
        var x = (m - 1) / 2
        while x % 2 == 0 { x /= 2 }
        //    for (int i = 3; (long long)(i)*i <= x; i += 2) {
        do { var i: CInt = 3; while CLongLong(i)*CLongLong(i) <= x { defer { i += 2 }
            if x % i == 0 {
                divs[cnt] = i; cnt += 1
                while x % i == 0 {
                    x /= i
                }
            }
        } }
        if (x > 1) {
            divs[cnt] = x; cnt += 1
        }
        //    for (int g = 2;; g++) {
        do { var g: CInt = 2; while true { defer { g += 1 }
            var ok = true
            //        for (int i = 0; i < cnt; i++) {
            for i in 0..<CInt(cnt) {
                if pow_mod_constexpr(CLongLong(g), CLongLong((m - 1) / divs[Int(i)]), m) == 1 {
                    ok = false
                    break
                }
            }
            if ok { return g }
        } }
    }
    
    static var memoized_primitve_root: Memoized = .init(source: _primitive_root_constexpr)
    static func primitive_root_constexpr(_ m: CInt) -> CInt { memoized_primitve_root.get(m) }
    static func primitive_root(_ m: CInt) -> CInt { primitive_root_constexpr(m) }

    // @param n `n < 2^32`
    // @param m `1 <= m < 2^32`
    // @return sum_{i=0}^{n-1} floor((ai + b) / m) (mod 2^64)
    static func floor_sum_unsigned(_ n: CUnsignedLongLong,
                                   _ m: CUnsignedLongLong,
                                   _ a: CUnsignedLongLong,
                                   _ b: CUnsignedLongLong) -> CUnsignedLongLong {
        var (n,m,a,b) = (n,m,a,b)
        var ans: CUnsignedLongLong = 0
        while true {
            if (a >= m) {
                ans += n * (n &- 1) / 2 * (a / m)
                a %= m
            }
            if b >= m {
                ans += n * (b / m)
                b %= m
            }
            let y_max = a * n + b
            if y_max < m { break }
            // y_max < m * (n + 1)
            // floor(y_max / m) <= n
            n = y_max / m
            b = y_max % m
            swap(&m, &a)
        }
        return ans
    }
}

extension _Internal {
    
    struct Memoized<A: Hashable, Output> {
        var cache: [A:Output] = [:]
        let source: (A) -> Output
        mutating func get(_ a: A) -> Output {
            if let p = cache[a] { return p }
            let p = source(a)
            cache[a] = p
            return p
        }
    }
    
    struct Memoized3<A: Hashable, B: Hashable, C: Hashable, Output> {
        struct Key: Hashable {
            var a: A; var b: B; var c: C
        }
        var cache: [Key:Output] = [:]
        let source: (A,B,C) -> Output
        mutating func get(_ a: A,_ b: B,_ c: C) -> Output {
            let key = Key(a: a, b: b, c: c)
            if let p = cache[key] { return p }
            let p = source(a,b,c)
            cache[key] = p
            return p
        }
    }
}
