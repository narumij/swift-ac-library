import BigInt
import Numerics
import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

extension LibraryTests.modintTests {
  #if DEBUG
    @Test(.tags(.swiftSpecific))
    func testModulus() throws {
      #expect(mod_1.isPrime == _Internal.is_prime(Int(mod_1.m)))
      #expect(mod_11.isPrime == _Internal.is_prime(Int(mod_11.m)))
      #expect(mod_12.isPrime == _Internal.is_prime(Int(mod_12.m)))
      #expect(mod_1_000_000_007.isPrime == _Internal.is_prime(Int(mod_1_000_000_007.m)))
      #expect(mod_1_000_000_008.isPrime == _Internal.is_prime(Int(mod_1_000_000_008.m)))
      #expect(INT32_MAX.isPrime == _Internal.is_prime(Int(INT32_MAX.m)))
      #expect(INT_MAX.isPrime == _Internal.is_prime(Int(INT_MAX.m)))
      #expect(mod_value.mod_UINT32_MAX.umod == UInt(CUnsignedInt.max))
    }
  #endif
  @Test(.tags(.swiftSpecific))
  func testDynamicBorderAlt() throws {

    let ab: [(mod: uint, a: ll, int, [(b: ll, int, int, int)])] = [
      (
        2_147_483_647, 0, 0,
        [
          (0, 0, 0, 0),
          (2_147_483_647, 0, 0, 0),
          (1_073_741_823, 1_073_741_823, 1_073_741_824, 0),
          (1_073_741_823, 1_073_741_823, 1_073_741_824, 0),
        ]
      ),
      (
        2_147_483_647, 2_147_483_647, 0,
        [
          (0, 0, 0, 0),
          (2_147_483_647, 0, 0, 0),
          (1_073_741_823, 1_073_741_823, 1_073_741_824, 0),
          (1_073_741_823, 1_073_741_823, 1_073_741_824, 0),
        ]
      ),
      (
        2_147_483_647, 1_073_741_823, 1_879_048_191,
        [
          (0, 1_073_741_823, 1_073_741_823, 0),
          (2_147_483_647, 1_073_741_823, 1_073_741_823, 0),
          (1_073_741_823, 2_147_483_646, 0, 536_870_912),
          (1_073_741_823, 2_147_483_646, 0, 536_870_912),
        ]
      ),
      (
        2_147_483_647, 1_073_741_823, 1_879_048_191,
        [
          (0, 1_073_741_823, 1_073_741_823, 0),
          (2_147_483_647, 1_073_741_823, 1_073_741_823, 0),
          (1_073_741_823, 2_147_483_646, 0, 536_870_912),
          (1_073_741_823, 2_147_483_646, 0, 536_870_912),
        ]
      ),
    ]

    typealias mint = modint

    for (mod, a, ans1, bb) in ab {
      mint.set_mod(Int(mod))
      let a = uint(a)
      #expect(ans1 == int((mint(a).pow(3)).val), "pow mod = \(mod)")
      for (b, ans2, ans3, ans4) in bb {
        let b = uint(b)
        #expect(ans2 == int((mint(a) + mint(b)).val), "+ mod = \(mod)")
        #expect(ans3 == int((mint(a) - mint(b)).val), "- mod = \(mod)")
        #expect(ans4 == int((mint(a) * mint(b)).val), "* mod = \(mod)")
      }
    }
  }
  @Test(.tags(.swiftSpecific))
  func testDynamicUsage2() throws {
    typealias mint = modint
    mint.set_mod(998_244_353)
    do {
      var m = mint(1)
      m += mint(2)
      #expect(3 == m.val)
    }
    do {
      var m = mint(1)
      m += 2
      #expect(3 == m.val)
    }

    mint.set_mod(3)
    do {
      var m = mint(2)
      m -= mint(1)
      #expect(1 == m.val)
    }
    do {
      var m = mint(1)
      m += 2
      #expect(0 == m.val)
    }

    mint.set_mod(11)
    do {
      var m = mint(3)
      m *= mint(5)
      #expect(4 == m.val)
    }
  }
  @Test(.tags(.swiftSpecific))
  func testSome() throws {
    typealias mint = modint998244353
    #expect(1 == int((mint(3) / 2).val) - int((mint.mod + 1) / 2))
    #expect(4 == int((mint(9) / 2).val) - int((mint.mod + 1) / 2))
    #expect(18 == (mint(36) / 2).val)

    #expect(0 == mint(false).val)
    #expect(0 == modint(false).val)

    #expect(0 == mint(false))
    #expect(0 == modint(false))

    #expect("0" == modint(false).description)
  }
  @Test(.tags(.swiftSpecific))
  func testUsageStaticWithInt() throws {
    typealias mint = modint998244353
    #expect(5 == mint(2) + 3)
    #expect(5 == 2 + mint(3))
    #expect(1 == mint(3) - 2)
    #expect(1 == 3 - mint(2))
    #expect(4 == mint(2) * 2)
    #expect(4 == 2 * mint(2))
    #expect(3 == mint(12) / 4)
    #expect(3 == 12 / mint(4))

    var a: mint = 2
    a *= 6
    a /= 4
    a += 3
    a -= 2
    #expect(4 == a)
  }
  @Test(.tags(.swiftSpecific))
  func testUsageDynamicWithInt() throws {
    typealias mint = modint
    #expect(5 == mint(2) + 3)
    #expect(5 == 2 + mint(3))
    #expect(1 == mint(3) - 2)
    #expect(1 == 3 - mint(2))
    #expect(4 == mint(2) * 2)
    #expect(4 == 2 * mint(2))
    #expect(3 == mint(12) / 4)
    #expect(3 == 12 / mint(4))

    var a: mint = 2
    a *= 6
    a /= 4
    a += 3
    a -= 2
    #expect(4 == a)
  }
  @Test(.tags(.swiftSpecific))
  func testEtc() throws {
    typealias mint = modint998244353
    let K = 2
    _ = mint(1) / K
  }
  @Test(.tags(.swiftSpecific))
  func testEtc2() throws {
    let ne1: (ull, int) = (998_244_352, 932_051_909)
    #expect(ne1.0 == CUnsignedLongLong(modint.mod - 1))
    #expect(ne1.1 == int(modint(CUnsignedLongLong(bitPattern: CLongLong(-1))).val))
    let ne2: (ull, int) = (0, 932_051_910)
    #expect(ne2.1 == int((modint(CUnsignedLongLong(bitPattern: CLongLong(-1))) + modint(1)).val))
  }
  @Test(.tags(.swiftSpecific))
  func testNumeric() throws {
    #expect(modint998244353(exactly: 0) != nil)
    #expect(modint998244353(exactly: mod_998_244_353.umod - 1) != nil)
    #expect(modint998244353(exactly: -1) == nil)
    #expect(modint998244353(exactly: mod_998_244_353.umod + 1) == nil)
  }
  #if DEBUG
    @Test(.disabled("Release-only stress test"), .tags(.swiftSpecific))
  #else
    @Test(.tags(.swiftSpecific))
  #endif
  func testStress() throws {

    typealias mint = modint998244353
    var (a, b, c, d): (mint, mint, mint, mint) = (100, 100, 100, 100)
    for _ in 0..<10 {
      for _ in 0..<1_000_000 {
        a += 998_244_352
        b -= 998_244_352
        c *= 998_244_352
        d /= 998_244_352
      }
    }
  }
}
