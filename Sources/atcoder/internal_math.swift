import Foundation

extension `internal` {
// @param m `1 <= m`
// @return x mod m
static func safe_mod(_ x: Int,_ m: Int) -> Int {
    var x = x
    x %= m;
    if (x < 0) { x += m; }
    return x;
}

// Fast modular multiplication by barrett reduction
// Reference: https://en.wikipedia.org/wiki/Barrett_reduction
// NOTE: reconsider after Ice Lake
struct barrett {
    var _m: UInt;
    var im: UInt;

    // @param m `1 <= m`
    init(_ m: UInt) { _m = m; im = UInt.max / m &+ 1 }

    // @return m
    func umod() -> UInt { return _m; }

    // @param a `0 <= a < m`
    // @param b `0 <= b < m`
    // @return `a * b % m`
    func mul(_ a: UInt,_ b: UInt) -> UInt {
        // [1] m = 1
        // a = b = im = 0, so okay

        // [2] m >= 2
        // im = ceil(2^64 / m)
        // -> im * m = 2^64 + r (0 <= r < m)
        // let z = a*b = c*m + d (0 <= c, d < m)
        // a*b * im = (c*m + d) * im = c*(im*m) + d*im = c*2^64 + c*r + d*im
        // c*r + d*im < m * m + m * im < m * m + 2^64 + m <= 2^64 + m * (m + 1) < 2^64 * 2
        // ((ab * im) >> 64) == c or c + 1
        var z: UInt = a;
        z &*= b;
        let x: UInt = z.multipliedFullWidth(by: UInt(im)).high
        let y: UInt = x * UInt(_m);
        return z &- y &+ (z < y ? UInt(_m) : 0);
    }
};

// @param n `0 <= n`
// @param m `1 <= m`
// @return `(x ** n) % m`
static func pow_mod_constexpr(_ x: Int,_ n: Int,_ m: Int) -> Int {
    var n = n
    if (m == 1) { return 0; }
    let _m = UInt(m);
    var r: UInt = 1;
    var y: UInt = UInt(safe_mod(x, m));
    while ((n) != 0) {
        if (n & 1 != 0) { r = (r * y) % _m; }
        y = (y &* y) % _m;
        n >>= 1;
    }
    return Int(r);
}

// Reference:
// M. Forisek and J. Jancina,
// Fast Primality Testing for Integers That Fit into a Machine Word
// @param n `0 <= n`
static func is_prime_constexpr(_ n: Int) -> Bool {
    if (n <= 1) { return false; }
    if (((1 << n) & (1 << 2 | 1 << 7 | 1 << 61)) != 0) { return true; }
    if (1 & n == 0) { return false; }
    var d = n - 1;
    while (1 & d == 0) { d >>= 1; }
    let bases = [2, 7, 61];
    for a in bases {
        var t = d;
        var y = pow_mod_constexpr(a, t, n);
        while (t != n - 1 && y != 1 && y != n - 1) {
            y = y * y % n;
            t <<= 1;
        }
        if (y != n - 1 && t & 1 == 0) {
            return false;
        }
    }
    return true;
}
static func is_prime(_ n: Int) -> Bool { is_prime_constexpr(n); }

// @param b `1 <= b`
// @return pair(g, x) s.t. g = gcd(a, b), xa = g (mod b), 0 <= x < b/g
static func inv_gcd(_ a: Int,_ b: Int) -> (first: Int,second: Int) {
    let a = safe_mod(a, b);
    if (a == 0) { return (b, 0); }

    // Contracts:
    // [1] s - m0 * a = 0 (mod b)
    // [2] t - m1 * a = 0 (mod b)
    // [3] s * |m1| + t * |m0| <= b
    var s = b, t = a;
    var m0 = 0, m1 = 1;

    while ((t) != 0) {
        let u = s / t;
        s -= t * u;
        m0 -= m1 * u;  // |m1 * u| <= |m1| * s <= b

        // [3]:
        // (s - t * u) * |m1| + t * |m0 - m1 * u|
        // <= s * |m1| - t * u * |m1| + t * (|m0| + |m1| * u)
        // = s * |m1| + t * |m0| <= b

        var tmp = s;
        s = t;
        t = tmp;
        tmp = m0;
        m0 = m1;
        m1 = tmp;
    }
    // by [3]: |m0| <= b/g
    // by g != b: |m0| < b/g
    if (m0 < 0) { m0 += b / s; }
    return (s, m0);
}

// Compile time primitive root
// @param m must be prime
// @return primitive root (and minimum in now)
static func primitive_root_constexpr(_ m: Int) -> Int {
    if (m == 2) { return 1; }
    if (m == 167772161) { return 3; }
    if (m == 469762049) { return 3; }
    if (m == 754974721) { return 11; }
    if (m == 998244353) { return 3; }
    var divs = [Int](repeating: 0, count: 20);
    divs[0] = 2;
    var cnt = 1;
    var x = (m - 1) / 2;
    while (x % 2 == 0) { x /= 2; }
//    for (int i = 3; (long long)(i)*i <= x; i += 2) {
    do { var i = 3; while i*i <= x { defer { i += 2 }
        if (x % i == 0) {
            divs[cnt] = i; cnt += 1
            while (x % i == 0) {
                x /= i;
            }
        }
    } }
    if (x > 1) {
        divs[cnt] = x; cnt += 1
    }
//    for (int g = 2;; g++) {
    do { var g = 2; while true { defer { g += 1 }
        var ok = true;
//        for (int i = 0; i < cnt; i++) {
        for i in 0..<cnt {
            if (pow_mod_constexpr(g, (m - 1) / divs[i], m) == 1) {
                ok = false;
                g -= 1 /* defer 補正 */
                break;
            }
        }
        if (ok) { return g; }
    } }
}
//template <int m> constexpr int primitive_root = primitive_root_constexpr(m);

// @param n `n < 2^32`
// @param m `1 <= m < 2^32`
// @return sum_{i=0}^{n-1} floor((ai + b) / m) (mod 2^64)
static func floor_sum_unsigned(_ n: UInt,
                               _ m: UInt,
                               _ a: UInt,
                               _ b: UInt) -> UInt {
    var a = a, b = b, n = n, m = m
    var ans: UInt = 0;
    while (true) {
        if (a >= m) {
            ans += n * (n - 1) / 2 * (a / m);
            a %= m;
        }
        if (b >= m) {
            ans += n * (b / m);
            b %= m;
        }

        let y_max = a * n + b;
        if (y_max < m) { break; }
        // y_max < m * (n + 1)
        // floor(y_max / m) <= n
        n = UInt(y_max / m);
        b = UInt(y_max % m);
        swap(&m, &a);
    }
    return ans;
}
}
