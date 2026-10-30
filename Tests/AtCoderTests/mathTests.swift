import Algorithms
import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

private func gcd<LL>(_ a: LL, _ b: LL) -> LL
where LL: SignedInteger {
  assert(0 <= a && 0 <= b)
  if b == 0 { return a }
  return gcd(b, a % b)
}

private func pow_mod_naive(_ x: ll, _ n: ull, _ mod: uint) -> ll {
  let y: ull = ull((x % ll(mod) + ll(mod)) % ll(mod))
  var z: ull = 1
  for _ in 0..<n as Range<ull> {
    z = (z * y) % ull(mod)
  }
  return ll(z % ull(mod))
}

#if DEBUG
  private func floor_sum_naive<LL>(_ n: LL, _ m: LL, _ a: LL, _ b: LL) -> LL
  where LL: FixedWidthInteger & SignedInteger {
    var sum: LL = 0
    for i in 0..<n {
      let z: LL = a * i + b
      sum += (z - AtCoderTests.___safe_mod(z, m)) / m
    }
    return sum
  }
#endif

private func is_prime_naive(_ n: ll) -> Bool {
  assert(0 <= n && n <= CInt.max)
  if n == 0 || n == 1 { return false }
  for i in 2 ..<= n as StrideThrough<ll> {
    if n % i == 0 { return false }
  }
  return true
}

//private func safe_mod<LL>(_ x: LL, _ m: LL) -> LL
//where LL: FixedWidthInteger {
//  var x = x
//  x %= m
//  if x < 0 { x += m }
//  return x
//}

extension LibraryTests {
  final class mathTests {

    @Test(.tags(.aclPort))
    func testPowMod() throws {

      //    typealias ll = Int
      //    typealias CInt = Int
      //    typealias int = Int

      func naive(_ x: ll, _ n: ll, _ mod: CInt) -> ll {
        #if DEBUG
          let y: ll = _Internal.safe_mod(x, ll(mod))
        #else
          let y: ll = ___safe_mod(x, ll(mod))
        #endif
        var z: ull = 1 % ull(mod)
        for _ in 0..<n as Range<ll> {
          z = (z * ull(y)) % ull(mod)
        }
        return ll(z)
      }

      #if DEBUG
        for a in (-100..<100 as Range<int>).randomSample(count: 20) {
          for b in (0 ..<= 100 as StrideThrough<int>).randomSample(count: 20) {
            for c in (1 ..<= 100 as StrideThrough<int>).randomSample(count: 20) {
              #expect(naive(ll(a), ll(b), c) == pow_mod(ll(a), ll(b), c))
            }
          }
        }
      #else
        for a in -100..<100 as Range<ll> {
          for b in 0 ..<= 100 as StrideThrough<ll> {
            for c in 1 ..<= 100 as StrideThrough<int> {
              #expect(naive(a, b, c) == pow_mod(a, b, c))
            }
          }
        }
      #endif
    }

    @Test(.tags(.swiftSpecific))
    func testPowMod_Int() throws {

      func naive(_ x: Int, _ n: Int, _ mod: Int) -> Int {
        #if DEBUG
          let y = Int(___safe_mod(x, mod))
        #else
          let y = ___safe_mod(x, mod)
        #endif
        var z = 1 % mod
        for _ in 0..<n {
          z = (z * y) % mod
        }
        return z
      }

      for a in -100..<100 {
        for b in 0 ..<= 100 {
          for c in 1 ..<= 100 {
            #expect(naive(a, b, c) == pow_mod(a, b, c))
          }
        }
      }
    }

    typealias ll = Int
    typealias CInt = Int
    typealias int = Int

    @Test(.tags(.aclPort))
    func testInvBoundHand() throws {
      let minll = ll.min
      let maxll = ll.max
      #expect(inv_mod(-1, maxll) == inv_mod(minll, maxll))
      #expect(1 == inv_mod(maxll, maxll - 1))
      #expect(maxll - 1 == inv_mod(maxll - 1, maxll))
      #expect(2 == inv_mod(maxll / 2 + 1, maxll))
    }

    @Test(.tags(.swiftSpecific))
    func testInvBoundHand_Int() throws {
      let minll = Int(ll.min)
      let maxll = Int(ll.max)
      #expect(inv_mod(-1, maxll) == inv_mod(minll, maxll))
      #expect(1 == inv_mod(maxll, maxll - 1))
      #expect(maxll - 1 == inv_mod(maxll - 1, maxll))
      #expect(2 == inv_mod(maxll / 2 + 1, maxll))
    }

    #if DEBUG
      @Test(.tags(.aclPort))
      func testInvMod() throws {
        //        for (int a = -100; a <= 100; a++) {
        for a in ll(-100) ..<= 100 {
          //            for (int b = 1; b <= 1000; b++) {
          for b in ll(1) ..<= 1000 {
            if gcd(_Internal.safe_mod(a, b), b) != 1 { continue }
            let c = inv_mod(a, b)
            #expect(0 <= c)
            #expect(c < b)
            #expect(1 % b == ((a * c) % b + b) % b)
          }
        }
      }

      @Test(.tags(.swiftSpecific))
      func testInvMod_Int() throws {
        for a in -100 ..<= 100 {
          for b in 1 ..<= 1000 {
            if gcd(_Internal.safe_mod(a, b), b) != 1 { continue }
            let c = inv_mod(a, b)
            #expect(0 <= c)
            #expect(c < b)
            #expect(1 % b == ((a * c) % b + b) % b)
          }
        }
      }
    #endif

    @Test(.tags(.aclPort))
    func testInvModZero() throws {
      #expect(0 == inv_mod(ll(0), ll(1)))
      //        for (int i = 0; i < 10; i++) {
      for i in ll(0)..<10 {
        #expect(0 == inv_mod(i, 1))
        #expect(0 == inv_mod(-i, 1))
        #expect(0 == inv_mod(ll.min + i, 1))
        #expect(0 == inv_mod(ll.max - i, 1))
      }
    }

    @Test(.tags(.swiftSpecific))
    func testInvModZero_Int() throws {
      #expect(0 == inv_mod(0, 1))
      //        for (int i = 0; i < 10; i++) {
      for i in 0..<10 {
        #expect(0 == inv_mod(i, 1))
        #expect(0 == inv_mod(-i, 1))
        #expect(0 == inv_mod(Int(ll.min) + i, 1))
        #expect(0 == inv_mod(Int(ll.max) - i, 1))
      }
    }

    #if DEBUG
      @Test(.tags(.aclPort))
      func testFloorSum() throws {
        // for (int n = 0; n < 20; n++) {
        for n in 0..<20 {
          // for (int m = 1; m < 20; m++) {
          for m in 1..<20 {
            // for (int a = -20; a < 20; a++) {
            for a in -20..<20 {
              // for (int b = -20; b < 20; b++) {
              for b in -20..<20 {
                #expect(floor_sum_naive(n, m, a, b) == floor_sum(n, m, a, b))
              }
            }
          }
        }
      }

    #endif

    @Test(.tags(.aclPort))
    func testCRTHand() throws {
      let res = crt([1, 2, 1] as [ll], [2, 3, 2] as [ll])
      #expect(5 == res.rem)
      #expect(6 == res.mod)
    }

    @Test(.tags(.swiftSpecific))
    func testCRTHand_Int() throws {
      let res = crt([1, 2, 1], [2, 3, 2])
      #expect(5 == res.rem)
      #expect(6 == res.mod)
    }

    #if DEBUG
      @Test(.tags(.aclPort))
      func testCRT2() throws {
        //        for (int a = 1; a <= 20; a++) {
        for a in ll(1) ..<= 20 {
          //            for (int b = 1; b <= 20; b++) {
          for b in ll(1) ..<= 20 {
            //                for (int c = -10; c <= 10; c++) {
            for c in ll(-10) ..<= 10 {
              //                    for (int d = -10; d <= 10; d++) {
              for d in ll(-10)..<10 {
                let res = crt([c, d], [a, b])
                if res.mod == 0 {
                  //                            for (int x = 0; x < a * b / gcd(a, b); x++) {
                  do {
                    var x: ll = 0
                    while x < a * b / gcd(a, b) {
                      defer { x += 1 }
                      #expect(x % a != c || x % b != d)
                    }
                  }
                  continue
                }
                #expect(a * b / gcd(a, b) == res.mod)
                #expect(_Internal.safe_mod(c, a) == res.rem % a)
                #expect(_Internal.safe_mod(d, b) == res.rem % b)
              }
            }
          }
        }
      }

      @Test(.tags(.swiftSpecific))
      func testCRT2_Int() throws {
        for a in 1 ..<= 20 {
          for b in 1 ..<= 20 {
            for c in -10 ..<= 10 {
              for d in -10..<10 {
                let res = crt([c, d], [a, b])
                if res.mod == 0 {
                  // for (int x = 0; x < a * b / gcd(a, b); x++) {
                  do {
                    var x = 0
                    while x < a * b / gcd(a, b) {
                      defer { x += 1 }
                      #expect(x % a != c || x % b != d)
                    }
                  }
                  continue
                }
                #expect(a * b / gcd(a, b) == res.mod)
                #expect(_Internal.safe_mod(c, a) == res.rem % a)
                #expect(_Internal.safe_mod(d, b) == res.rem % b)
              }
            }
          }
        }
      }
    #endif

    #if DEBUG
      @Test(.tags(.aclPort))
      func testCRT3() throws {
        //        for (int a = 1; a <= 5; a++) {
        for a in ll(1) ..<= 5 {
          //            for (int b = 1; b <= 5; b++) {
          for b in ll(1) ..<= 5 {
            //                for (int c = 1; c <= 5; c++) {
            for c in ll(1) ..<= 5 {
              //                    for (int d = -5; d <= 5; d++) {
              for d in ll(-5) ..<= 5 {
                //                        for (int e = -5; e <= 5; e++) {
                for e in ll(-5) ..<= 5 {
                  //                            for (int f = -5; f <= 5; f++) {
                  for f in ll(-5) ..<= 5 {
                    let res = crt([d, e, f], [a, b, c])
                    var lcm = a * b / gcd(a, b)
                    lcm = lcm * c / gcd(lcm, c)
                    if res.mod == 0 {
                      //                                    for (int x = 0; x < lcm; x++) {
                      for x in 0..<lcm {
                        #expect(x % a != d || x % b != e || x % c != f)
                      }
                      continue
                    }
                    #expect(lcm == res.mod)
                    #expect(_Internal.safe_mod(d, a) == res.rem % a)
                    #expect(_Internal.safe_mod(e, b) == res.rem % b)
                    #expect(_Internal.safe_mod(f, c) == res.rem % c)
                  }
                }
              }
            }
          }
        }
      }

      @Test(.tags(.swiftSpecific))
      func testCRT3_Int() throws {
        for a in 1 ..<= 5 {
          for b in 1 ..<= 5 {
            for c in 1 ..<= 5 {
              for d in -5 ..<= 5 {
                for e in -5 ..<= 5 {
                  for f in -5 ..<= 5 {
                    let res = crt([d, e, f], [a, b, c])
                    var lcm = a * b / gcd(a, b)
                    lcm = lcm * c / gcd(lcm, c)
                    if res.mod == 0 {
                      // for (int x = 0; x < lcm; x++) {
                      for x in 0..<lcm {
                        #expect(x % a != d || x % b != e || x % c != f)
                      }
                      continue
                    }
                    #expect(lcm == res.mod)
                    #expect(_Internal.safe_mod(d, a) == res.rem % a)
                    #expect(_Internal.safe_mod(e, b) == res.rem % b)
                    #expect(_Internal.safe_mod(f, c) == res.rem % c)
                  }
                }
              }
            }
          }
        }
      }
    #endif

    @Test(.tags(.aclPort))
    func testCRTOverflow() throws {
      let r0: ll = 0
      let r1: ll = 1_000_000_000_000 - 2
      let m0: ll = 900577
      let m1: ll = 1_000_000_000_000
      let res = crt([r0, r1], [m0, m1])
      #expect(m0 * m1 == res.mod)
      #expect(r0 == res.rem % m0)
      #expect(r1 == res.rem % m1)
    }

    @Test(.tags(.swiftSpecific))
    func testCRTOverflow_Int() throws {
      let r0 = 0
      let r1 = 1_000_000_000_000 - 2
      let m0 = 900577
      let m1 = 1_000_000_000_000
      let res = crt([r0, r1], [m0, m1])
      #expect(m0 * m1 == res.mod)
      #expect(r0 == res.rem % m0)
      #expect(r1 == res.rem % m1)
    }

    @Test(.tags(.aclPort))
    func testCRTBound() throws {
      let INF = ll.max
      var pred = [ll]()
      for i in 1 ..<= 10 as StrideThrough<ll> {
        pred.append(i)
        pred.append(INF - (i - 1))
      }
      pred.append(998_244_353)
      pred.append(1_000_000_007)
      pred.append(1_000_000_009)

      for ab in [
        (INF, INF),
        (1, INF),
        (INF, 1),
        (7, INF),
        (INF / 337, 337),
        (2, (INF - 1) / 2),
      ] {
        var a = ab.0
        var b = ab.1
        for _ /* ph */ in 0..<2 {
          for ans in pred {
            let res = crt([ans % a, ans % b], [a, b])
            let lcm = a / gcd(a, b) * b
            #expect(lcm == res.mod)
            #expect(ans % lcm == res.rem)
          }
          swap(&a, &b)
        }
      }
      let factor_inf = ([49, 73, 127, 337, 92737, 649657] as [ll]).permutations()
      for factor_inf in factor_inf {
        for ans in pred {
          var r: [ll] = []
          var m: [ll] = []
          for f in factor_inf {
            r.append(ans % f)
            m.append(f)
          }
          let res = crt(r, m)
          #expect(ans % INF == res.rem)
          #expect(INF == res.mod)
        }
      }
      let factor_infn1 = ([2, 3, 715_827_883, 2_147_483_647] as [ll]).permutations()
      for factor_infn1 in factor_infn1 {
        for ans in pred {
          var r: [ll] = []
          var m: [ll] = []
          for f in factor_infn1 {
            r.append(ans % f)
            m.append(f)
          }
          let res = crt(r, m)
          #expect(ans % (INF - 1) == res.rem)
          #expect(INF - 1 == res.mod)
        }
      }
    }

    @Test(.tags(.swiftSpecific))
    func testCRTBound_Int() throws {
      let INF = Int(ll.max)
      var pred = [Int]()
      for i in 1 ..<= 10 as StrideThrough<Int> {
        pred.append(i)
        pred.append(INF - (i - 1))
      }
      pred.append(998_244_353)
      pred.append(1_000_000_007)
      pred.append(1_000_000_009)

      for ab in [
        (INF, INF),
        (1, INF),
        (INF, 1),
        (7, INF),
        (INF / 337, 337),
        (2, (INF - 1) / 2),
      ] {
        var a = ab.0
        var b = ab.1
        for _ /* ph */ in 0..<2 {
          for ans in pred {
            let res = crt([ans % a, ans % b], [a, b])
            let lcm = a / gcd(a, b) * b
            #expect(lcm == res.mod)
            #expect(ans % lcm == res.rem)
          }
          swap(&a, &b)
        }
      }
      let factor_inf = ([49, 73, 127, 337, 92737, 649657] as [Int]).permutations()
      for factor_inf in factor_inf {
        for ans in pred {
          var r: [Int] = []
          var m: [Int] = []
          for f in factor_inf {
            r.append(ans % f)
            m.append(f)
          }
          let res = crt(r, m)
          #expect(ans % INF == res.rem)
          #expect(INF == res.mod)
        }
      }
      let factor_infn1 = ([2, 3, 715_827_883, 2_147_483_647] as [Int]).permutations()
      for factor_infn1 in factor_infn1 {
        for ans in pred {
          var r: [Int] = []
          var m: [Int] = []
          for f in factor_infn1 {
            r.append(ans % f)
            m.append(f)
          }
          let res = crt(r, m)
          #expect(ans % (INF - 1) == res.rem)
          #expect(INF - 1 == res.mod)
        }
      }
    }
  }

}
