import Numerics
import XCTest

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

//private typealias int = CInt
//private typealias uint = CUnsignedInt
//private typealias ll = CLongLong
//private typealias ull = CUnsignedLongLong

extension dynamic_mod {
  // 型の生存期間が各テストメソッドのスコープを超えるので、都度リセットする必要がある。
  static func reset() {
    bt = .default
  }
}

final class modintTests: XCTestCase {

  @usableFromInline typealias mod_1 = mod<1,IsNotPrime>
  @usableFromInline typealias mod_11 = mod<11, IsPrime>
  @usableFromInline typealias mod_12 = mod<12, IsNotPrime>
  @usableFromInline typealias mod_1_000_000_007 = mod<1_000_000_007, IsPrime>
  @usableFromInline typealias mod_1_000_000_008 = mod<1_000_000_008, IsNotPrime>
  @usableFromInline typealias INT32_MAX = mod<2_147_483_647, IsNotPrime>

  override func setUpWithError() throws {
      // Put setup code here. This method is called before the invocation of each test method in the class.
    mod_dynamic.reset()
  }

  override func tearDownWithError() throws {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testDynamicBorder() throws {

    typealias mint = modint
    let mod_upper = CUnsignedInt(CInt.max)
    // for (unsigned int mod = mod_upper; mod >= mod_upper - 20; mod--) {
    for mod in mod_upper ..>= (mod_upper - 20) as StrideThrough<uint> {
      mint.set_mod(int(mod))
      var v: [ll] = []
      // for (int i = 0; i < 10; i++) {
      for i in 0..<10 as Range<int> {
        v.append(ll(i))
        v.append(ll(int(mod) - i))
        v.append(ll(int(mod) / 2 + i))
        v.append(ll(int(mod) / 2 - i))
      }
      for a in v {
        let mod = ll(mod)
        XCTAssertEqual(
          int(((a &* a) % mod &* a) % mod), (mint(a).pow(3)).val, "mod = \(mod), a = \(a)")
        for b in v {
          XCTAssertEqual(int((a &+ b) % mod), (mint(a) + mint(b)).val, "mod = \(mod)")
          XCTAssertEqual(int((a &- b &+ mod) % mod), (mint(a) - mint(b)).val, "mod = \(mod)")
          XCTAssertEqual(int((a &* b) % mod), (mint(a) * mint(b)).val, "mod = \(mod)")
        }
      }
    }
  }

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
      mint.set_mod(CInt(mod))
      let a = uint(a)
      XCTAssertEqual(ans1, (mint(a).pow(3)).val, "pow mod = \(mod)")
      for (b, ans2, ans3, ans4) in bb {
        let b = uint(b)
        XCTAssertEqual(ans2, (mint(a) + mint(b)).val, "+ mod = \(mod)")
        XCTAssertEqual(ans3, (mint(a) - mint(b)).val, "- mod = \(mod)")
        XCTAssertEqual(ans4, (mint(a) * mint(b)).val, "* mod = \(mod)")
      }
    }
  }

  func testULL() throws {
    modint.set_mod(998_244_353)
    XCTAssertNotEqual(int(modint.mod - 1), modint(ull(bitPattern: -1)).val)
    XCTAssertNotEqual(0, (ull(bitPattern: -1) + modint(1)).val)
    typealias mint = modint998244353
    XCTAssertNotEqual(int(mint.mod - 1), mint(ull(bitPattern: -1)).val)
    XCTAssertNotEqual(0, (ull(bitPattern: -1) + mint(1)).val)
  }

  func testMod1() throws {
    modint.set_mod(1)
    // for (int i = 0; i < 100; i++) {
    for i in 0..<100 as Range<int> {
      // for (int j = 0; j < 100; j++) {
      for j in 0..<100 as Range<int> {
        XCTAssertEqual((modint(i) * modint(j)).val, 0)
      }
    }
    XCTAssertEqual((modint(1234) + modint(5678)).val, 0)
    XCTAssertEqual((modint(1234) - modint(5678)).val, 0)
    XCTAssertEqual((modint(1234) * modint(5678)).val, 0)
    XCTAssertEqual((modint(1234).pow(5678)), 0)
    XCTAssertEqual(0, modint(0).inv)

    XCTAssertEqual(0, modint(true).val)

    typealias mint = static_modint<mod_1>
    // for (int i = 0; i < 100; i++) {
    for i in 0..<100 as Range<int> {
      // for (int j = 0; j < 100; j++) {
      for j in 0..<100 as Range<int> {
        XCTAssertEqual((mint(i) * mint(j)).val, 0)
      }
    }
    XCTAssertEqual((mint(1234) + mint(5678)).val, 0)
    XCTAssertEqual((mint(1234) - mint(5678)).val, 0)
    XCTAssertEqual((mint(1234) * mint(5678)).val, 0)
    XCTAssertEqual((mint(1234).pow(5678)), 0)
    XCTAssertEqual(0, modint(0).inv)

    XCTAssertEqual(0, mint(true).val)
  }

  func testModIntMax() throws {
    modint.set_mod(CInt.max)
    // for (int i = 0; i < 100; i++) {
    for i in 0..<100 as Range<int> {
      // for (int j = 0; j < 100; j++) {
      for j in 0..<100 as Range<int> {
        XCTAssertEqual((modint(i) * modint(j)).val, int(i * j))
      }
    }
    XCTAssertEqual((modint(1234) + modint(5678)).val, 1234 + 5678)
    XCTAssertEqual((modint(1234) - modint(5678)).val, int(CInt.max - 5678 + 1234))
    XCTAssertEqual((modint(1234) * modint(5678)).val, 1234 * 5678)

    typealias mint = static_modint<INT32_MAX>
    // for (int i = 0; i < 100; i++) {
    for i in 0..<100 as Range<int> {
      // for (int j = 0; j < 100; j++) {
      for j in 0..<100 as Range<int> {
        XCTAssertEqual((mint(i) * mint(j)).val, int(i * j))
      }
    }
    XCTAssertEqual((mint(1234) + mint(5678)).val, 1234 + 5678)
    XCTAssertEqual((mint(1234) - mint(5678)).val, int(Int32.max - 5678 + 1234))
    XCTAssertEqual((mint(1234) * mint(5678)).val, 1234 * 5678)
    XCTAssertEqual((mint(Int32.max) + mint(Int32.max)).val, 0)
  }

  func testInt128() throws {

    if #available(macOS 15.0, *) {
      modint.set_mod(998_244_353)
      XCTAssertEqual(12_345_678, modint(Int128(12_345_678)).val)
      XCTAssertEqual(12_345_678, modint(UInt128(12_345_678)).val)
      XCTAssertEqual(12_345_678, modint(Int128(12_345_678)).val)
      XCTAssertEqual(12_345_678, modint((UInt128)(12_345_678)).val)
      XCTAssertEqual(modint(2).pow(100).val, modint(Int128(1) << 100).val)
      XCTAssertEqual(modint(2).pow(100).val, modint(UInt128(1) << 100).val)
      typealias mint = static_modint<mod_998_244_353>
      XCTAssertEqual(12_345_678, mint(Int128(12_345_678)).val)
      XCTAssertEqual(12_345_678, mint(UInt128(12_345_678)).val)
      XCTAssertEqual(12_345_678, mint(Int128(12_345_678)).val)
      XCTAssertEqual(12_345_678, mint((UInt128)(12_345_678)).val)
      XCTAssertEqual(mint(2).pow(100).val, mint(Int128(1) << 100).val)
      XCTAssertEqual(mint(2).pow(100).val, mint(UInt128(1) << 100).val)
    } else {
      // Fallback on earlier versions
      throw XCTSkip("__int128がない")
    }
  }

  func testInv() throws {

    for i in 1..<10 as Range<int> {
      let x = static_modint<mod_11>(i).inv.val
      XCTAssertEqual(1, (int(x) * i) % 11)
    }

    for i in 1..<11 as Range<int> {
      if gcd(i, 12) != 1 { continue }
      let x = static_modint<mod_12>(i).inv.val
      XCTAssertEqual(1, (int(x) * i) % 12)
    }

    for i in 1..<100_000 as Range<int> {
      let x = static_modint<mod_1_000_000_007>(i).inv.val
      XCTAssertEqual(1, (ll(x) * ll(i)) % 1_000_000_007)
    }

    for i in 1..<100_000 as Range<int> {
      if gcd(i, 1_000_000_008) != 1 { continue }
      let x = static_modint<mod_1_000_000_008>(i).inv.val
      XCTAssertEqual(1, (ll(x) * ll(i)) % 1_000_000_008)
    }

    modint.set_mod(998_244_353)
    for i in 1..<100000 as Range<int> {
      let x = modint(i).inv.val
      XCTAssertLessThanOrEqual(0, x)
      XCTAssertGreaterThanOrEqual(998_244_353 - 1, x)
      XCTAssertEqual(1, (ll(x) * ll(i)) % 998_244_353)
    }

    modint.set_mod(1_000_000_008)
    for i in 1..<100000 as Range<int> {
      if gcd(i, 1_000_000_008) != 1 { continue }
      let x = modint(i).inv.val
      XCTAssertEqual(1, (ll(x) * ll(i)) % 1_000_000_008)
    }

    modint.set_mod(CInt.max)
    for i in 1..<100000 as Range<int> {
      if gcd(i, int.max) != 1 { continue }
      let x = modint(i).inv.val
      XCTAssertEqual(1, (ll(x) * ll(i) % ll(int.max)))
    }
  }

  func testConstUsage() throws {
    typealias sint = static_modint<mod_11>
    let a: sint = 9
    XCTAssertEqual(9, a.val)
    typealias dint = modint
    dint.set_mod(11)
    let b: dint = 9
    XCTAssertEqual(9, b.val)
  }

  #if false
    func testIncrement() throws {
      throw XCTSkip("Increment演算子がSwiftにはない")
      /*
         using sint = static_modint<11>;
         using dint = modint;
         dint::set_mod(11);

         {
         sint a;
         a = 8;
         ASSERT_EQ(9, (++a).val());
         ASSERT_EQ(10, (++a).val());
         ASSERT_EQ(0, (++a).val());
         ASSERT_EQ(1, (++a).val());
         a = 3;
         ASSERT_EQ(2, (--a).val());
         ASSERT_EQ(1, (--a).val());
         ASSERT_EQ(0, (--a).val());
         ASSERT_EQ(10, (--a).val());
         a = 8;
         ASSERT_EQ(8, (a++).val());
         ASSERT_EQ(9, (a++).val());
         ASSERT_EQ(10, (a++).val());
         ASSERT_EQ(0, (a++).val());
         ASSERT_EQ(1, a.val());
         a = 3;
         ASSERT_EQ(3, (a--).val());
         ASSERT_EQ(2, (a--).val());
         ASSERT_EQ(1, (a--).val());
         ASSERT_EQ(0, (a--).val());
         ASSERT_EQ(10, a.val());
         }
         {
         dint a;
         a = 8;
         ASSERT_EQ(9, (++a).val());
         ASSERT_EQ(10, (++a).val());
         ASSERT_EQ(0, (++a).val());
         ASSERT_EQ(1, (++a).val());
         a = 3;
         ASSERT_EQ(2, (--a).val());
         ASSERT_EQ(1, (--a).val());
         ASSERT_EQ(0, (--a).val());
         ASSERT_EQ(10, (--a).val());
         a = 8;
         ASSERT_EQ(8, (a++).val());
         ASSERT_EQ(9, (a++).val());
         ASSERT_EQ(10, (a++).val());
         ASSERT_EQ(0, (a++).val());
         ASSERT_EQ(1, a.val());
         a = 3;
         ASSERT_EQ(3, (a--).val());
         ASSERT_EQ(2, (a--).val());
         ASSERT_EQ(1, (a--).val());
         ASSERT_EQ(0, (a--).val());
         ASSERT_EQ(10, a.val());
         }
         */
    }
  #endif

  func testStaticUsage() throws {
    typealias mint = static_modint<mod_11>
    XCTAssertEqual(11, mint.mod)
    XCTAssertEqual(4, +mint(4))
    XCTAssertEqual(7, -mint(4))

    XCTAssertFalse(mint(1) == mint(3))
    XCTAssertTrue(mint(1) != mint(3))
    XCTAssertTrue(mint(1) == mint(12))
    XCTAssertFalse(mint(1) != mint(12))

    // Swift Packageでは実施不可
    // XCTAssertThrowsError(mint(3).pow(-1), ".*")
  }

  func testDynamicUsage() throws {

    // C++版では整数で型の区別をしていたようだが、Swiftでは型を挿入することにする。
    // generics型ではstored propertyを使えないため、non genericsのdynamic_mod派生にbtを持たせている。
    enum _12345: dynamic_mod { nonisolated(unsafe) static var bt: barrett = .default }
    XCTAssertEqual(998_244_353, dynamic_modint<_12345>.mod)

    dynamic_modint<_12345>.set_mod(11)
    XCTAssertNotEqual(mod_dynamic.bt, _12345.bt)
    XCTAssertNotEqual(modint.mod, dynamic_modint<_12345>.mod)

    typealias mint = modint

    mint.set_mod(998_244_353)
    XCTAssertEqual(998_244_353, mint.mod)
    XCTAssertEqual(3, (mint(1) + mint(2)).val)
    XCTAssertEqual(3, (1 + mint(2)).val)
    XCTAssertEqual(3, (mint(1) + 2).val)

    mint.set_mod(3)
    XCTAssertEqual(3, mint.mod)
    XCTAssertEqual(1, (mint(2) - mint(1)).val)
    XCTAssertEqual(0, (mint(1) + mint(2)).val)

    mint.set_mod(11)
    XCTAssertEqual(11, mint.mod)
    XCTAssertEqual(4, (mint(3) * mint(5)).val)

    XCTAssertEqual(4, +mint(4))
    XCTAssertEqual(7, -mint(4))

    XCTAssertFalse(mint(1) == mint(3))
    XCTAssertTrue(mint(1) != mint(3))
    XCTAssertTrue(mint(1) == mint(12))
    XCTAssertFalse(mint(1) != mint(12))

    // Swift Packageでは実施不可
    // XCTAssertThrowsError(mint(3).pow(-1), ".*")
  }

  func testDynamicUsage2() throws {
    typealias mint = modint
    mint.set_mod(998_244_353)
    do {
      var m = mint(1)
      m += mint(2)
      XCTAssertEqual(3, m.val)
    }
    do {
      var m = mint(1)
      m += 2
      XCTAssertEqual(3, m.val)
    }

    mint.set_mod(3)
    do {
      var m = mint(2)
      m -= mint(1)
      XCTAssertEqual(1, m.val)
    }
    do {
      var m = mint(1)
      m += 2
      XCTAssertEqual(0, m.val)
    }

    mint.set_mod(11)
    do {
      var m = mint(3)
      m *= mint(5)
      XCTAssertEqual(4, m.val)
    }
  }

  func testConstructor() throws {
    modint.set_mod(11)
    XCTAssertEqual(1, modint(true).val)
    XCTAssertEqual(3, modint((CChar)(3)).val)
    XCTAssertEqual(3, modint((CSignedChar)(3)).val)
    XCTAssertEqual(3, modint((CUnsignedChar)(3)).val)
    XCTAssertEqual(3, modint((CShort)(3)).val)
    XCTAssertEqual(3, modint((CUnsignedShort)(3)).val)
    XCTAssertEqual(3, modint((CInt)(3)).val)
    XCTAssertEqual(3, modint((CUnsignedInt)(3)).val)
    XCTAssertEqual(3, modint((CLong)(3)).val)
    XCTAssertEqual(3, modint((CUnsignedLong)(3)).val)
    XCTAssertEqual(3, modint((CLongLong)(3)).val)
    XCTAssertEqual(3, modint((CUnsignedLongLong)(3)).val)
    XCTAssertEqual(1, modint((CSignedChar)(-10)).val)
    XCTAssertEqual(1, modint((CShort)(-10)).val)
    XCTAssertEqual(1, modint((CInt)(-10)).val)
    XCTAssertEqual(1, modint((CLong)(-10)).val)
    XCTAssertEqual(1, modint((CLongLong)(-10)).val)

    XCTAssertEqual(2, (CInt(1) + modint(1)).val)
    XCTAssertEqual(2, (CShort(1) + modint(1)).val)

    let m = modint()
    XCTAssertEqual(0, m.val)
  }

  func testConstructorStatic() throws {
    typealias mint = static_modint<mod_11>
    XCTAssertEqual(1, mint(true).val)
    XCTAssertEqual(3, mint((CChar)(3)).val)
    XCTAssertEqual(3, mint((CSignedChar)(3)).val)
    XCTAssertEqual(3, mint((CUnsignedChar)(3)).val)
    XCTAssertEqual(3, mint((CShort)(3)).val)
    XCTAssertEqual(3, mint((CUnsignedShort)(3)).val)
    XCTAssertEqual(3, mint((CInt)(3)).val)
    XCTAssertEqual(3, mint((CUnsignedInt)(3)).val)
    XCTAssertEqual(3, mint((CLong)(3)).val)
    XCTAssertEqual(3, mint((CUnsignedLong)(3)).val)
    XCTAssertEqual(3, mint((CLongLong)(3)).val)
    XCTAssertEqual(3, mint((CUnsignedLongLong)(3)).val)
    XCTAssertEqual(1, mint((CSignedChar)(-10)).val)
    XCTAssertEqual(1, mint((CShort)(-10)).val)
    XCTAssertEqual(1, mint((CInt)(-10)).val)
    XCTAssertEqual(1, mint((CLong)(-10)).val)
    XCTAssertEqual(1, mint((CLongLong)(-10)).val)

    XCTAssertEqual(2, (CInt(1) + mint(1)).val)
    XCTAssertEqual(2, (CShort(1) + mint(1)).val)

    let m = mint()
    XCTAssertEqual(0, m.val)
  }

  func testSome() throws {
    typealias mint = modint998244353
    XCTAssertEqual(1, (mint(3) / 2).val - int((mint.mod + 1) / 2))
    XCTAssertEqual(4, (mint(9) / 2).val - int((mint.mod + 1) / 2))
    XCTAssertEqual(18, (mint(36) / 2).val)

    XCTAssertEqual(0, mint(false).val)
    XCTAssertEqual(0, modint(false).val)

    XCTAssertEqual(0, mint(false))
    XCTAssertEqual(0, modint(false))

    XCTAssertEqual("0", modint(false).description)
  }

  func testUsageStaticWithInt() throws {
    typealias mint = modint998244353
    XCTAssertEqual(5, mint(2) + 3)
    XCTAssertEqual(5, 2 + mint(3))
    XCTAssertEqual(1, mint(3) - 2)
    XCTAssertEqual(1, 3 - mint(2))
    XCTAssertEqual(4, mint(2) * 2)
    XCTAssertEqual(4, 2 * mint(2))
    XCTAssertEqual(3, mint(12) / 4)
    XCTAssertEqual(3, 12 / mint(4))

    var a: mint = 2
    a *= 6
    a /= 4
    a += 3
    a -= 2
    XCTAssertEqual(4, a)
  }

  func testUsageDynamicWithInt() throws {
    typealias mint = modint
    XCTAssertEqual(5, mint(2) + 3)
    XCTAssertEqual(5, 2 + mint(3))
    XCTAssertEqual(1, mint(3) - 2)
    XCTAssertEqual(1, 3 - mint(2))
    XCTAssertEqual(4, mint(2) * 2)
    XCTAssertEqual(4, 2 * mint(2))
    XCTAssertEqual(3, mint(12) / 4)
    XCTAssertEqual(3, 12 / mint(4))

    var a: mint = 2
    a *= 6
    a /= 4
    a += 3
    a -= 2
    XCTAssertEqual(4, a)
  }

  func testEtc() throws {
    typealias mint = modint998244353
    let K = 2
    _ = mint(1) / K
  }

  func testEtc2() throws {
    let ne1: (ull, int) = (998_244_352, 932_051_909)
    XCTAssertEqual(ne1.0, CUnsignedLongLong(modint.mod - 1))
    XCTAssertEqual(ne1.1, modint(CUnsignedLongLong(bitPattern: CLongLong(-1))).val)
    let ne2: (ull, int) = (0, 932_051_910)
    XCTAssertEqual(ne2.1, (modint(CUnsignedLongLong(bitPattern: CLongLong(-1))) + modint(1)).val)
  }

  func testStress() throws {

    #if DEBUG
      throw XCTSkip()
    #endif

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
