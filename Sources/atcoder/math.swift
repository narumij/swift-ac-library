import Foundation

func pow_mod(_ x: Int,_ n: Int,_ m: Int) -> Int {
    var n = n
    assert(0 <= n && 1 <= m);
    if (m == 1) { return 0; }
    let bt = `internal`.barrett(UInt(m));
    var r: UInt = 1, y = UInt(`internal`.safe_mod(x, m));
    while ((n) != 0) {
        if ((n & 1) != 0) { r = UInt(bt.mul(r, y)); }
        y = UInt(bt.mul(y, y));
        n >>= 1;
    }
    return Int(r);
}

func inv_mod(_ x: Int,_ m: Int) -> Int {
    assert(1 <= m);
    let z = `internal`.inv_gcd(x, m);
    assert(z.first == 1);
    return z.second;
}

// (rem, mod)
func crt(_ r: [Int],
         _ m: [Int]) -> (first: Int, second: Int) {
    assert(r.count == m.count);
    var n = r.count;
    // Contracts: 0 <= r0 < m0
    var r0 = 0, m0 = 1;
//    for (int i = 0; i < n; i++) {
    for i in 0..<n {
        assert(1 <= m[i]);
        var r1 = `internal`.safe_mod(r[i], m[i]), m1 = m[i];
        if (m0 < m1) {
            swap(&r0, &r1);
            swap(&m0, &m1);
        }
        if (m0 % m1 == 0) {
            if (r0 % m1 != r1) { return (0, 0); }
            continue;
        }
        // assume: m0 > m1, lcm(m0, m1) >= 2 * max(m0, m1)

        // (r0, m0), (r1, m1) -> (r2, m2 = lcm(m0, m1));
        // r2 % m0 = r0
        // r2 % m1 = r1
        // -> (r0 + x*m0) % m1 = r1
        // -> x*u0*g = r1-r0 (mod u1*g) (u0*g = m0, u1*g = m1)
        // -> x = (r1 - r0) / g * inv(u0) (mod u1)

        // im = inv(u0) (mod u1) (0 <= im < u1)
        var g, im: Int;
        (g, im) = `internal`.inv_gcd(m0, m1);

        var u1 = (m1 / g);
        // |r1 - r0| < (m0 + m1) <= lcm(m0, m1)
        if (((r1 - r0) % g) != 0) { return (0, 0); }

        // u1 * u1 <= m1 * m1 / g / g <= m0 * m1 / g = lcm(m0, m1)
        var x = (r1 - r0) / g % u1 * im % u1;

        // |r0| + |m0 * x|
        // < m0 + m0 * (u1 - 1)
        // = m0 + m0 * m1 / g - m0
        // = lcm(m0, m1)
        r0 += x * m0;
        m0 *= u1;  // -> lcm(m0, m1)
        if (r0 < 0) { r0 += m0; }
    }
    return (r0, m0);
}

func floor_sum(_ n: Int,_ m: Int,_ a: Int,_ b: Int) -> Int {
    var a = a, b = b, n = n, m = m
    assert(0 <= n && n < (1 << 32));
    assert(1 <= m && m < (1 << 32));
    var ans: UInt = 0;
    if (a < 0) {
        let a2: UInt = UInt(`internal`.safe_mod(a, m));
        ans -= UInt(1) * UInt(n) * (UInt(n) - UInt(1)) / UInt(2) * ((a2 - UInt(a)) / UInt(m));
        a = Int(a2);
    }
    if (b < 0) {
        let b2: UInt = UInt(`internal`.safe_mod(b, m));
        ans -= UInt(1) * UInt(n) * ((b2 - UInt(b)) / UInt(m));
        b = Int(b2);
    }
    return Int(ans + `internal`.floor_sum_unsigned(UInt(n), UInt(m), UInt(a), UInt(b)));
}
