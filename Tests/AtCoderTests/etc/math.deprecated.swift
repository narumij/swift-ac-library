import Foundation
@testable import AtCoder

// MARK: - deprecated

@available(*, deprecated, message: "Use pow_mod(_:Int,_:Int,:Int) instead")
@inlinable
public func inv_mod<LL>(
  _ x: LL,
  _ m: LL
) -> LL
where LL: SignedInteger {
  assert(1 <= m)
  let z = _Internal.inv_gcd(x, m)
  assert(z.first == 1)
  return z.second
}

@available(*, deprecated, message: "Use pow_mod(_:Int,_:Int,:Int) instead")
@inlinable
public func pow_mod(
  _ x: CLongLong,
  _ n: CLongLong,
  _ m: CInt
) -> CLongLong {
  CLongLong(pow_mod(Int(x), Int(n), Int(m)))
}

/// (rem, mod)
@available(*, deprecated, message: "Use crt(_:[Int],_:[Int]) instead")
@inlinable
public func crt<LL>(
  _ r: [LL],
  _ m: [LL]
) -> (rem: LL, mod: LL)
where LL: SignedInteger {
  assert(r.count == m.count)
  let n = r.count
  // Contracts: 0 <= r0 < m0
  var r0 = 0 as LL
  var m0 = 1 as LL
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
    var g: LL
    var im: LL
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

@available(*, deprecated, message: "Use floor_sum(_:Int,_:Int,:Int,_:Int) instead")
@inlinable
public func floor_sum(
  _ n: CLongLong,
  _ m: CLongLong,
  _ a: CLongLong,
  _ b: CLongLong
) -> CLongLong {
  CLongLong(floor_sum(Int(n), Int(m), Int(a), Int(b)))
}
