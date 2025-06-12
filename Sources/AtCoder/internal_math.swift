import Foundation

extension _Internal {
  /// @param m `1 <= m`
  /// @return x mod m
  @inlinable
  static func safe_mod<LL>(_ x: LL, _ m: LL) -> LL
  where LL: FixedWidthInteger {
    var x = x
    x %= m
    if x < 0 { x += m }
    return x
  }
}

/// Fast modular multiplication by barrett reduction
/// Reference: https://en.wikipedia.org/wiki/Barrett_reduction
/// NOTE: reconsider after Ice Lake
public struct barrett {

  @usableFromInline
  let m, im: UInt

  @inlinable @inline(__always)
  public init<Unsigned: UnsignedInteger>(_ _m: Unsigned) {
    m = UInt(_m)
    im = UInt(bitPattern: -1) / UInt(_m) &+ 1
  }

  @inlinable @inline(__always)
  public init<Signed: SignedInteger>(_ _m: Signed) {
    m = UInt(bitPattern: Int(_m))
    im = UInt(bitPattern: -1) / UInt(bitPattern: Int(_m)) &+ 1
  }

  /// @return m
  @inlinable
  public func umod<Unsigned>() -> Unsigned where Unsigned: UnsignedInteger { Unsigned(m) }

  /// @param a `0 <= a < m`
  /// @param b `0 <= b < m`
  /// @return `a * b % m`
  @inlinable
  public func mul<Unsigned>(_ a: Unsigned, _ b: Unsigned) -> Unsigned
  where Unsigned: UnsignedInteger {
    // [1] m = 1
    // a = b = im = 0, so okay

    // [2] m >= 2
    // im = ceil(2^64 / m)
    // -> im * m = 2^64 + r (0 <= r < m)
    // let z = a*b = c*m + d (0 <= c, d < m)
    // a*b * im = (c*m + d) * im = c*(im*m) + d*im = c*2^64 + c*r + d*im
    // c*r + d*im < m * m + m * im < m * m + 2^64 + m <= 2^64 + m * (m + 1) < 2^64 * 2
    // ((ab * im) >> 64) == c or c + 1
    var z = UInt(a)
    z &*= UInt(b)
    #if os(macOS)
      let x: UInt
      if #available(macOS 15.0, *) {
        x = UInt((UInt128(z) * UInt128(im)) >> 64)
      } else {
        x = z.multipliedFullWidth(by: im).high
      }
    #else
      let x = UInt((UInt128(z) * UInt128(im)) >> 64)
    #endif
    let y = x &* m
    return Unsigned(z &- y &+ (z < y ? m : 0))
  }
}

extension _Internal {
  
  /// @param n `0 <= n`
  /// @param m `1 <= m`
  /// @return `(x ** n) % m`
  @inlinable
  static func _pow_mod_constexpr(_ x: LL, _ n: LL, _ m: INT) -> LL {
    precondition(n >= 0)
    if m == 1 { return 0 }
    let _m = ULL(UINT(bitPattern: m))
    var r: ULL = 1
    var y = ULL(bitPattern: safe_mod(x, LL(m)))
    var n = n
    while (n) != 0 {
      if n & 1 != 0 { r = (r * y) % _m }
      y = (y &* y) % _m
      n >>= 1 // 負の数の場合、符号ビットがあるため、永遠に-1のまま
    }
    return LL(bitPattern: r)
  }

  @usableFromInline
  nonisolated(unsafe)
  static var memoized_pow_mod: Memoized3 = .init(source: _pow_mod_constexpr)
  @inlinable
  static func pow_mod_constexpr(_ x: LL, _ n: LL, _ m: INT) -> LL {
    memoized_pow_mod.get(x, n, m)
  }

  /// Reference:
  /// M. Forisek and J. Jancina,
  /// Fast Primality Testing for Integers That Fit into a Machine Word
  /// @param n `0 <= n`
  @inlinable
  static func _is_prime_constexpr(_ n: INT) -> Bool {
    if n <= 1 { return false }
    if ((1 << n) & (1 << 2 | 1 << 7 | 1 << 61)) != 0 { return true }
    if 1 & n == 0 { return false }
    var d = LL(n - 1)
    while 1 & d == 0 { d >>= 1 }
    let bases: [LL] = [2, 7, 61]
    for a in bases {
      var t: LL = d
      var y: LL = pow_mod_constexpr(a, t, n)
      let n = LL(n)
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

  @usableFromInline
  nonisolated(unsafe)
  static var memoized_is_prime: Memoized = .init(source: _is_prime_constexpr)
  @inlinable
  static func is_prime_constexpr(_ n: INT) -> Bool { memoized_is_prime.get(n) }
  @inlinable
  static func is_prime(_ n: INT) -> Bool { is_prime_constexpr(n) }

  /// @param b `1 <= b`
  /// @return pair(g, x) s.t. g = gcd(a, b), xa = g (mod b), 0 <= x < b/g
  @inlinable
  static func inv_gcd<LL>(_ a: LL, _ b: LL) -> (first: LL, second: LL)
  where LL: FixedWidthInteger {
    let a = safe_mod(a, b)
    if a == 0 { return (b, 0) }

    // Contracts:
    // [1] s - m0 * a = 0 (mod b)
    // [2] t - m1 * a = 0 (mod b)
    // [3] s * |m1| + t * |m0| <= b
    var s = b
    var t = a
    var m0: LL = 0
    var m1: LL = 1

    while t != 0 {
      let u: LL = s / t
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

  /// Compile time primitive root
  /// @param m must be prime
  /// @return primitive root (and minimum in now)
  @inlinable
  static func _primitive_root_constexpr(_ m: Int) -> Int {
    if m == 2 { return 1 }
    if m == 167_772_161 { return 3 }
    if m == 469_762_049 { return 3 }
    if m == 754_974_721 { return 11 }
    if m == 998_244_353 { return 3 }
    var divs = [Int](repeating: 0, count: 20)
    divs[0] = 2
    var cnt = 1
    var x = (m - 1) / 2
    while x % 2 == 0 { x /= 2 }
    //    for (int i = 3; (long long)(i)*i <= x; i += 2) {
    for i in sequence(first: 3, next: { $0 * $0 <= x ? $0 + 2 : nil }) {
      if x % i == 0 {
        divs[cnt] = i
        cnt += 1
        while x % i == 0 {
          x /= i
        }
      }
    }

    if x > 1 {
      divs[cnt] = x
      cnt += 1
    }
    // for (int g = 2;; g++) {
    for g in sequence(first: 2, next: { $0 + 1 }) {
      var ok = true
      for i in 0..<INT(cnt) {
        if pow_mod_constexpr(LL(g), LL((m - 1) / divs[Int(i)]), INT(m)) == 1 {
          ok = false
          break
        }
      }
      if ok { return g }
    }

    fatalError()
  }

  @usableFromInline
  nonisolated(unsafe)
    static var memoized_primitve_root: Memoized = .init(source: _primitive_root_constexpr)
  @inlinable
  static func primitive_root_constexpr(_ m: Int) -> Int { memoized_primitve_root.get(m) }
  @inlinable
  static func primitive_root(_ m: Int) -> Int { primitive_root_constexpr(m) }

  /// @param n `n < 2^32`
  /// @param m `1 <= m < 2^32`
  /// @return sum_{i=0}^{n-1} floor((ai + b) / m) (mod 2^64)
  @inlinable
  static func floor_sum_unsigned<ULL>(
    _ n: ULL,
    _ m: ULL,
    _ a: ULL,
    _ b: ULL
  ) -> ULL
  where ULL: FixedWidthInteger & UnsignedInteger {
    var (n, m, a, b) = (n, m, a, b)
    var ans: ULL = 0
    while true {
      if a >= m {
        let a_m = a.quotientAndRemainder(dividingBy: m)
        ans += n * (n &- 1) / 2 * a_m.quotient
        a = a_m.remainder
      }
      if b >= m {
        let b_m = b.quotientAndRemainder(dividingBy: m)
        ans += n * b_m.quotient
        b = b_m.remainder
      }
      let y_max = a * n + b
      if y_max < m { break }
      // y_max < m * (n + 1)
      // floor(y_max / m) <= n
      (n, b) = y_max.quotientAndRemainder(dividingBy: m)
      swap(&m, &a)
    }
    return ans
  }
}

extension _Internal {

  @usableFromInline
  struct Memoized<A: Hashable, Output> {
    @usableFromInline var cache: [A: Output] = [:]
    @usableFromInline let source: (A) -> Output
    @inlinable
    mutating func get(_ a: A) -> Output {
      if let p = cache[a] { return p }
      let p = source(a)
      cache[a] = p
      return p
    }
  }

  @usableFromInline
  struct Memoized3<A: Hashable, B: Hashable, C: Hashable, Output> {
    public struct Key: Hashable {
      @inlinable init(a: A, b: B, c: C) {
        self.a = a
        self.b = b
        self.c = c
      }
      public var a: A
      public var b: B
      public var c: C
    }
    @usableFromInline var cache: [Key: Output] = [:]
    @usableFromInline let source: (A, B, C) -> Output
    @inlinable
    mutating func get(_ a: A, _ b: B, _ c: C) -> Output {
      let key = Key(a: a, b: b, c: c)
      if let p = cache[key] { return p }
      let p = source(a, b, c)
      cache[key] = p
      return p
    }
  }
}
