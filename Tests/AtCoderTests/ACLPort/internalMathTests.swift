import BigInt
import Numerics
import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

private func is_prime_naive(_ n: Int) -> Bool {
  assert(0 <= n && n <= ll(CInt.max))
  if n == 0 || n == 1 { return false }
  do {
    var i: Int = 2
    while i &* i <= n {
      defer { i += 1 }
      if n % i == 0 { return false }
    }
  }
  return true
}

func ___safe_mod<LL>(_ x: LL, _ m: LL) -> LL
where LL: FixedWidthInteger {
  var x = x
  x %= m
  if x < 0 { x += m }
  return x
}

#if DEBUG
  private typealias INT = CInt
  private typealias UINT = CUnsignedInt
  private typealias LL = CLongLong
  private typealias ULL = CUnsignedLongLong

  private func _pow_mod_constexpr(_ x: LL, _ n: LL, _ m: INT) -> LL {
    var n = n
    if m == 1 { return 0 }
    let _m = ULL(UINT(bitPattern: m))
    var r: ULL = 1
    var y = ULL(bitPattern: ___safe_mod(x, LL(m)))
    while (n) != 0 {
      if n & 1 != 0 { r = (r * y) % _m }
      y = (y &* y) % _m
      n >>= 1
    }
    return LL(bitPattern: r)
  }

  nonisolated(unsafe)
    private var memoized_pow_mod: _Internal.Memoized3 = .init(source: _pow_mod_constexpr)

  private func pow_mod_constexpr(_ x: LL, _ n: LL, _ m: INT) -> LL {
    memoized_pow_mod.get(x, n, m)
  }

  func _is_prime_constexpr(_ n: CInt) -> Bool {
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
#endif

func inv_gcd<LL>(_ a: LL, _ b: LL) -> (first: LL, second: LL)
where LL: FixedWidthInteger {
  let a = ___safe_mod(a, b)
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

extension LibraryTests {
  final class internalMathTests {

    #if DEBUG
      @Test(.tags(.aclPort))
      func testBarrett() throws {
        //        for (int m = 1; m <= 100; m++) {
        for m in 1 ..<= 100 {
          let bt = barrett(UInt(m))
          //            for (int a = 0; a < m; a++) {
          for a in 0..<m {
            //                for (int b = 0; b < m; b++) {
            for b in 0..<m {
              #expect((a * b) % m == Int(bt.mul(UInt(a), UInt(b))))
            }
          }
        }

        let bt = barrett(1)
        #expect(0 as UInt == bt.mul(0, 0))
      }

      @Test(.tags(.aclPort))
      func testBarrettCIntBorder() throws {

        typealias ll = Int

        let mod_upper = UInt(CInt.max)

        //        for (unsigned int mod = mod_upper; mod >= mod_upper - 20; mod--) {
        for mod in stride(from: mod_upper, through: mod_upper - 20, by: -1) {
          let bt = barrett(UInt(mod))
          var v: [UInt] = []
          //            for (int i = 0; i < 10; i++) {
          for i in UInt(0)..<UInt(10) {
            v.append(i)
            v.append(mod - i)
            v.append(mod / 2 + i)
            v.append(mod / 2 - i)
          }

          for a in v {
            let a2 = ll(a)
            #expect(((a2 &* a2) % ll(mod) &* a2) % ll(mod) == ll(bt.mul(a, bt.mul(a, a))))
            for b in v {
              let b2 = ll(b)
              #expect((a2 * b2) % ll(mod) == ll(bt.mul(UInt(a), UInt(b))))
            }
          }
        }
      }

      @Test(.tags(.aclPort))
      func testBarrettCUnsignedIntBorder() throws {

        typealias ull = UInt
        //        throw XCTSkip()

        let mod_upper = UInt(CUnsignedInt.max)
        //        for (unsigned int mod = mod_upper; mod >= mod_upper - 20; mod--) {
        for mod in stride(from: mod_upper, through: mod_upper - 20, by: -1) {
          let bt = barrett(mod)
          var v: [UInt] = []
          //            for (int i = 0; i < 10; i++) {
          for i in UInt(0)..<UInt(10) {
            v.append(i)
            v.append(mod - i)
            v.append(mod / 2 + i)
            v.append(mod / 2 - i)
          }
          for a in v {
            let a2 = ull(a)
            #expect(((a2 &* a2) % ull(mod) &* a2) % ull(mod) == ull(bt.mul(a, bt.mul(a, a))))
            for b in v {
              let b2 = ull(b)
              #expect((a2 &* b2) % ull(mod) == ull(bt.mul(a, b)))
            }
          }
        }
      }

      @Test(.tags(.aclPort))
      func testIsPrime() throws {

        #expect(!(_Internal.is_prime(121)))
        #expect(!(_Internal.is_prime(11 * 13)))
        #expect(_Internal.is_prime(1_000_000_007))
        #expect(!(_Internal.is_prime(1_000_000_008)))
        #expect(_Internal.is_prime(1_000_000_009))
        //        for (int i = 0; i <= 10000; i++) {
        for i in 0 ..<= 10000 {
          #expect(is_prime_naive(i) == _Internal.is_prime_constexpr(Int(i)))
        }
        //        for (int i = 0; i <= 10000; i++) {
        for i in 0 ..<= 10000 {
          let x = Int(CInt.max) - i
          #expect(is_prime_naive(x) == _Internal.is_prime_constexpr(Int(x)))
        }
      }

      #if false
        @Test(.tags(.aclPort))
        func testSafeMod() throws {

          return  // Previously skipped: "__int128はSwiftでは利用できないため"

          /*
           std::vector<ll> preds;
           for (int i = 0; i <= 100; i++) {
               preds.push_back(i);
               preds.push_back(-i);
               preds.push_back(i);
               preds.push_back(std::numeric_limits<ll>::min() + i);
               preds.push_back(std::numeric_limits<ll>::max() - i);
           }

           for (auto a : preds) {
               for (auto b : preds) {
                   if (b <= 0) continue;
                   ll ans = (ll)((__int128(a) % b + b) % b);
                   ASSERT_EQ(ans, internal::safe_mod(a, b));
               }
           }
           */
        }
      #endif

      @Test(.tags(.aclPort))
      func testInvGcdBound() throws {

        typealias ll = Int

        //        throw XCTSkip()

        var pred = [ll]()
        //        for i in 0..<=10 {
        for i in 0 ..<= ll(10) {
          pred.append(i)
          pred.append(-i)
          pred.append(ll.min + i)
          pred.append(ll.max - i)

          pred.append(ll.min / 2 + i)
          pred.append(ll.min / 2 - i)
          pred.append(ll.max / 2 + i)
          pred.append(ll.max / 2 - i)

          pred.append(ll.min / 3 + i)
          pred.append(ll.min / 3 - i)
          pred.append(ll.max / 3 + i)
          pred.append(ll.max / 3 - i)
        }
        pred.append(998_244_353)
        pred.append(1_000_000_007)
        pred.append(1_000_000_009)
        pred.append(-998_244_353)
        pred.append(-1_000_000_007)
        pred.append(-1_000_000_009)

        for a in pred {
          for b in pred {
            if b <= 0 { continue }
            let a2 = _Internal.safe_mod(a, b)
            let eg = _Internal.inv_gcd(a, b)
            #if false
              let g = gcd(a2, b)
              #expect(g == eg.first)
            #endif
            #expect(0 <= eg.second, "a - \(a), b - \(b)")
            #expect(eg.second <= b / eg.first, "a - \(a), b - \(b)")
            #if false
              #expect(BigInt(g) % BigInt(b) == BigInt(eg.second) * BigInt(a2) % BigInt(b))
            #endif
          }
        }
      }

      @Test(.tags(.aclPort))
      func testPrimitiveRootTestNaive() throws {
        //        for (int m = 2; m <= 10000; m++) {
        for m in 2 ..<= 10000 {
          if !_Internal.is_prime_constexpr(Int(m)) { continue }
          let n = _Internal.primitive_root_constexpr(m)
          #expect(1 <= n)
          #expect(n < m)
          var x: Int = 1
          //            for (int i = 1; i <= m - 2; i++) {
          for _ in 1 ..<= (m - 2) {
            x = x * n % m
            // x == n^i
            #expect(1 != x)
          }
          x = x * n % m
          #expect(1 == x)
        }
      }

      @Test(.tags(.aclPort))
      func testPrimitiveRootTemplateTest() throws {

        #expect(is_primitive_root(2, (_Internal.primitive_root(2))))
        #expect(is_primitive_root(3, (_Internal.primitive_root(3))))
        #expect(is_primitive_root(5, (_Internal.primitive_root(5))))
        #expect(is_primitive_root(7, (_Internal.primitive_root(7))))
        #expect(is_primitive_root(11, (_Internal.primitive_root(11))))
        #expect(is_primitive_root(998_244_353, (_Internal.primitive_root(998_244_353))))
        #expect(is_primitive_root(1_000_000_007, (_Internal.primitive_root(1_000_000_007))))

        #expect(is_primitive_root(469_762_049, (_Internal.primitive_root(469_762_049))))
        #expect(is_primitive_root(167_772_161, (_Internal.primitive_root(167_772_161))))
        #expect(is_primitive_root(754_974_721, (_Internal.primitive_root(754_974_721))))
        #expect(is_primitive_root(324_013_369, (_Internal.primitive_root(324_013_369))))
        #expect(is_primitive_root(831_143_041, (_Internal.primitive_root(831_143_041))))
        #expect(is_primitive_root(1_685_283_601, (_Internal.primitive_root(1_685_283_601))))
      }

      @Test(.tags(.aclPort))
      func testPrimitiveRootTest() throws {
        //        for (int i = 0; i < 1000; i++) {
        for i in 0..<1000 {
          let x = Int(CInt.max) - i
          if !_Internal.is_prime_constexpr(Int(x)) { continue }
          #expect(is_primitive_root(x, _Internal.primitive_root_constexpr(x)))
        }
      }

    #endif
  }

}
