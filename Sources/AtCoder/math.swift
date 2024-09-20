import Foundation

@inlinable
public func pow_mod(_ x: CLongLong, _ n: CLongLong, _ m: CInt) -> CLongLong {
  var n = n
  assert(0 <= n && 1 <= m)
  if m == 1 { return 0 }
  let bt = barrett(CUnsignedInt(m))
  var r: CUnsignedInt = 1
  var y = CUnsignedInt(_Internal.safe_mod(x, CLongLong(m)))
  while n != 0 {
    if n & 1 != 0 { r = bt.mul(r, y) }
    y = bt.mul(y, y)
    n >>= 1
  }
  return CLongLong(r)
}

@inlinable
public func inv_mod(_ x: CLongLong, _ m: CLongLong) -> CLongLong {
  assert(1 <= m)
  let z = _Internal.inv_gcd(x, m)
  assert(z.first == 1)
  return z.second
}

/// (rem, mod)
@inlinable
public func crt(
  _ r: [CLongLong],
  _ m: [CLongLong]
) -> (rem: CLongLong, mod: CLongLong) {
  assert(r.count == m.count)
  let n = r.count
  // Contracts: 0 <= r0 < m0
  var r0 = 0 as CLongLong
  var m0 = 1 as CLongLong
  for i in 0..<n {
    assert(1 <= m[i])
    var r1 = _Internal.safe_mod(r[i], m[i])
    var m1 = m[i]
    if m0 < m1 {
      swap(&r0, &r1)
      swap(&m0, &m1)
    }
    if m0 % m1 == 0 {
      if r0 % m1 != r1 { return (0, 0) }
      continue
    }
    // assume: m0 > m1, lcm(m0, m1) >= 2 * max(m0, m1)

    // (r0, m0), (r1, m1) -> (r2, m2 = lcm(m0, m1));
    // r2 % m0 = r0
    // r2 % m1 = r1
    // -> (r0 + x*m0) % m1 = r1
    // -> x*u0*g = r1-r0 (mod u1*g) (u0*g = m0, u1*g = m1)
    // -> x = (r1 - r0) / g * inv(u0) (mod u1)

    // im = inv(u0) (mod u1) (0 <= im < u1)
    var g: CLongLong
    var im: CLongLong
    (g, im) = _Internal.inv_gcd(m0, m1)

    let u1 = (m1 / g)
    // |r1 - r0| < (m0 + m1) <= lcm(m0, m1)
    if (r1 - r0) % g != 0 { return (0, 0) }

    // u1 * u1 <= m1 * m1 / g / g <= m0 * m1 / g = lcm(m0, m1)
    let x = (r1 - r0) / g % u1 * im % u1

    // |r0| + |m0 * x|
    // < m0 + m0 * (u1 - 1)
    // = m0 + m0 * m1 / g - m0
    // = lcm(m0, m1)
    r0 += x * m0
    m0 *= u1  // -> lcm(m0, m1)
    if r0 < 0 { r0 += m0 }
  }
  return (r0, m0)
}

@inlinable
public func floor_sum(_ n: CLongLong, _ m: CLongLong, _ a: CLongLong, _ b: CLongLong) -> CLongLong {
  typealias ULL = CUnsignedLongLong
  typealias LL = CLongLong
  var (a, b) = (a, b)
  assert(0 <= n && n < ((1 as CLongLong) << 32))
  assert(1 <= m && m < ((1 as CLongLong) << 32))
  var ans: CLongLong = 0
  if a < 0 {
    let a2 = _Internal.safe_mod(a, m)
    ans -= 1 * n * (n &- 1) / 2 * ((a2 - a) / m)
    a = a2
  }
  if b < 0 {
    let b2 = _Internal.safe_mod(b, m)
    ans -= 1 * n * ((b2 - b) / m)
    b = b2
  }
  return ans + LL(_Internal.floor_sum_unsigned(ULL(n), ULL(m), ULL(a), ULL(b)))
}
