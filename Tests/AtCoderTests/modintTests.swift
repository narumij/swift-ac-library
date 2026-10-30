import BigInt
import Numerics
import Testing

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

extension LibraryTests {
  // Tests change the shared dynamic modulus; keep them serial and reset it per test.
  @Suite(.serialized)
  final class modintTests {
    init() { mod_dynamic.reset() }
    deinit { mod_dynamic.reset() }

    @usableFromInline
    enum mod_1: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 1 }
    @usableFromInline
    enum mod_11: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 11 }
    @usableFromInline
    enum mod_12: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 12 }
    @usableFromInline
    enum mod_1_000_000_007: static_mod_value {
      nonisolated(unsafe) static let mod: mod_value = .mod_1_000_000_007
    }
    @usableFromInline
    enum mod_1_000_000_008: static_mod_value {
      nonisolated(unsafe) static let mod: mod_value = 1_000_000_008
    }
    @usableFromInline
    enum INT32_MAX: static_mod_value {
      nonisolated(unsafe) static let mod: mod_value = .mod_INT32_MAX
    }
    @usableFromInline
    enum INT_MAX: static_mod_value {
      nonisolated(unsafe) static let mod: mod_value = .init(Int.max)
    }

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

    @Test(.tags(.aclPort))
    func testDynamicBorder() throws {

      typealias mint = modint
      let mod_upper = CUnsignedInt(CInt.max)
      // for (unsigned int mod = mod_upper; mod >= mod_upper - 20; mod--) {
      for mod in mod_upper ..>= (mod_upper - 20) as StrideThrough<uint> {
        mint.set_mod(Int(mod))
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
          #expect(
            int(((a &* a) % mod &* a) % mod) == int((mint(a).pow(3)).val), "mod = \(mod), a = \(a)")
          for b in v {
            #expect(int((a &+ b) % mod) == int((mint(a) + mint(b)).val), "mod = \(mod)")
            #expect(int((a &- b &+ mod) % mod) == int((mint(a) - mint(b)).val), "mod = \(mod)")
            #expect(int((a &* b) % mod) == int((mint(a) * mint(b)).val), "mod = \(mod)")
          }
        }
      }
    }

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

    @Test(.tags(.aclPort))
    func testULL() throws {
      modint.set_mod(998_244_353)
      #expect(int(modint.mod - 1) != int(modint(ull(bitPattern: -1)).val))
      #expect(0 != (ull(bitPattern: -1) + modint(1)).val)
      typealias mint = modint998244353
      #expect(int(mint.mod - 1) != int(mint(ull(bitPattern: -1)).val))
      #expect(0 != (ull(bitPattern: -1) + mint(1)).val)
    }

    @Test(.tags(.aclPort))
    func testMod1() throws {
      modint.set_mod(1)
      // for (int i = 0; i < 100; i++) {
      for i in 0..<100 as Range<int> {
        // for (int j = 0; j < 100; j++) {
        for j in 0..<100 as Range<int> {
          #expect((modint(i) * modint(j)).val == 0)
        }
      }
      #expect((modint(1234) + modint(5678)).val == 0)
      #expect((modint(1234) - modint(5678)).val == 0)
      #expect((modint(1234) * modint(5678)).val == 0)
      #expect((modint(1234).pow(5678)) == 0)
      #expect(0 == modint(0).inv)

      #expect(0 == modint(true).val)

      typealias mint = static_modint<mod_1>
      // for (int i = 0; i < 100; i++) {
      for i in 0..<100 as Range<int> {
        // for (int j = 0; j < 100; j++) {
        for j in 0..<100 as Range<int> {
          #expect((mint(i) * mint(j)).val == 0)
        }
      }
      #expect((mint(1234) + mint(5678)).val == 0)
      #expect((mint(1234) - mint(5678)).val == 0)
      #expect((mint(1234) * mint(5678)).val == 0)
      #expect((mint(1234).pow(5678)) == 0)
      #expect(0 == modint(0).inv)

      #expect(0 == mint(true).val)
    }

    @Test(.tags(.aclPort))
    func testModIntMax() throws {
      modint.set_mod(Int(int.max))
      // for (int i = 0; i < 100; i++) {
      for i in 0..<100 as Range<int> {
        // for (int j = 0; j < 100; j++) {
        for j in 0..<100 as Range<int> {
          #expect(int((modint(i) * modint(j)).val) == int(i * j))
        }
      }
      #expect((modint(1234) + modint(5678)).val == 1234 + 5678)
      #expect(int((modint(1234) - modint(5678)).val) == int(CInt.max - 5678 + 1234))
      #expect((modint(1234) * modint(5678)).val == 1234 * 5678)

      typealias mint = static_modint<INT32_MAX>
      // for (int i = 0; i < 100; i++) {
      for i in 0..<100 as Range<int> {
        // for (int j = 0; j < 100; j++) {
        for j in 0..<100 as Range<int> {
          #expect(int((mint(i) * mint(j)).val) == int(i * j))
        }
      }
      #expect((mint(1234) + mint(5678)).val == 1234 + 5678)
      #expect(int((mint(1234) - mint(5678)).val) == int(Int32.max - 5678 + 1234))
      #expect((mint(1234) * mint(5678)).val == 1234 * 5678)
      #expect((mint(Int32.max) + mint(Int32.max)).val == 0)
    }

    @Test(.tags(.aclPort))
    @available(macOS 15.0, *)
    func testInt128() throws {

      if #available(macOS 15.0, *) {
        modint.set_mod(998_244_353)
        #expect(12_345_678 == modint(Int128(12_345_678)).val)
        #expect(12_345_678 == modint(UInt128(12_345_678)).val)
        #expect(12_345_678 == modint(Int128(12_345_678)).val)
        #expect(12_345_678 == modint((UInt128)(12_345_678)).val)
        #expect(modint(2).pow(100).val == modint(Int128(1) << 100).val)
        #expect(modint(2).pow(100).val == modint(UInt128(1) << 100).val)
        typealias mint = static_modint<mod_998_244_353>
        #expect(12_345_678 == mint(Int128(12_345_678)).val)
        #expect(12_345_678 == mint(UInt128(12_345_678)).val)
        #expect(12_345_678 == mint(Int128(12_345_678)).val)
        #expect(12_345_678 == mint((UInt128)(12_345_678)).val)
        #expect(mint(2).pow(100).val == mint(Int128(1) << 100).val)
        #expect(mint(2).pow(100).val == mint(UInt128(1) << 100).val)
      }
    }

    @Test(.tags(.aclPort))
    func testInv() throws {

      for i in 1..<10 as Range<int> {
        let x = static_modint<mod_11>(i).inv.val
        #expect(1 == (int(x) * i) % 11)
      }

      #if false
        for i in 1..<11 as Range<int> {
          if gcd(i, 12) != 1 { continue }
          let x = static_modint<mod_12>(i).inv.val
          #expect(1 == (int(x) * i) % 12)
        }
      #endif

      for i in 1..<100_000 as Range<int> {
        let x = static_modint<mod_1_000_000_007>(i).inv.val
        #expect(1 == (ll(x) * ll(i)) % 1_000_000_007)
      }

      #if false
        for i in 1..<100_000 as Range<int> {
          if gcd(i, 1_000_000_008) != 1 { continue }
          let x = static_modint<mod_1_000_000_008>(i).inv.val
          #expect(1 == (ll(x) * ll(i)) % 1_000_000_008)
        }
      #endif

      #if false
        // テスト自体は通る
        for i in 1..<100_000 as Range<Int> {
          if gcd(i, Int.max) != 1 { continue }
          let x = static_modint<INT_MAX>(i).inv.val
          #expect(1 == (BigInt(x) * BigInt(i)) % BigInt(Int.max))
        }
      #endif

      modint.set_mod(998_244_353)
      for i in 1..<100000 as Range<int> {
        let x = modint(i).inv.val
        #expect(0 <= x)
        #expect(998_244_353 - 1 >= x)
        #expect(1 == (ll(x) * ll(i)) % 998_244_353)
      }

      #if false
        modint.set_mod(1_000_000_008)
        for i in 1..<100000 as Range<int> {
          if gcd(i, 1_000_000_008) != 1 { continue }
          let x = modint(i).inv.val
          #expect(1 == (ll(x) * ll(i)) % 1_000_000_008)
        }

        modint.set_mod(Int(int.max))
        for i in 1..<100000 as Range<int> {
          if gcd(i, int.max) != 1 { continue }
          let x = modint(i).inv.val
          #expect(1 == (ll(x) * ll(i) % ll(int.max)))
        }

        // テスト自体は通る
        modint.set_mod(Int.max)
        for i in 1..<100000 as Range<Int> {
          if gcd(i, Int.max) != 1 { continue }
          let x = modint(i).inv.val
          #expect(1 == (BigInt(x) * BigInt(i) % BigInt(Int.max)))
        }
      #endif
    }

    @Test(.tags(.aclPort))
    func testConstUsage() throws {
      typealias sint = static_modint<mod_11>
      let a: sint = 9
      #expect(9 == a.val)
      typealias dint = modint
      dint.set_mod(11)
      let b: dint = 9
      #expect(9 == b.val)
    }

    #if false
      @Test(.tags(.aclPort))
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

    @Test(.tags(.aclPort))
    func testStaticUsage() throws {
      typealias mint = static_modint<mod_11>
      #expect(11 == mint.mod)
      #expect(4 == +mint(4))
      #expect(7 == -mint(4))

      #expect(!(mint(1) == mint(3)))
      #expect(mint(1) != mint(3))
      #expect(mint(1) == mint(12))
      #expect(!(mint(1) != mint(12)))

      // Swift Packageでは実施不可
      // XCTAssertThrowsError(mint(3).pow(-1), ".*")
    }

    @Test(.tags(.aclPort))
    func testDynamicUsage() throws {

      // C++版では整数で型の区別をしていたようだが、Swiftでは型を挿入することにする。
      // generics型ではstored propertyを使えないため、non genericsのdynamic_mod派生にbtを持たせている。
      enum _12345: dynamic_mod { nonisolated(unsafe) static var bt: barrett = .default }
      #expect(998_244_353 == dynamic_modint<_12345>.mod)

      dynamic_modint<_12345>.set_mod(11)
      #expect(mod_dynamic.bt != _12345.bt)
      #expect(modint.mod != dynamic_modint<_12345>.mod)

      typealias mint = modint

      mint.set_mod(998_244_353)
      #expect(998_244_353 == mint.mod)
      #expect(3 == (mint(1) + mint(2)).val)
      #expect(3 == (1 + mint(2)).val)
      #expect(3 == (mint(1) + 2).val)

      mint.set_mod(3)
      #expect(3 == mint.mod)
      #expect(1 == (mint(2) - mint(1)).val)
      #expect(0 == (mint(1) + mint(2)).val)

      mint.set_mod(11)
      #expect(11 == mint.mod)
      #expect(4 == (mint(3) * mint(5)).val)

      #expect(4 == +mint(4))
      #expect(7 == -mint(4))

      #expect(!(mint(1) == mint(3)))
      #expect(mint(1) != mint(3))
      #expect(mint(1) == mint(12))
      #expect(!(mint(1) != mint(12)))

      // Swift Packageでは実施不可
      // XCTAssertThrowsError(mint(3).pow(-1), ".*")
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

    @Test(.tags(.aclPort))
    func testConstructor() throws {
      modint.set_mod(11)
      #expect(1 == modint(true).val)
      #expect(3 == modint((CChar)(3)).val)
      #expect(3 == modint((CSignedChar)(3)).val)
      #expect(3 == modint((CUnsignedChar)(3)).val)
      #expect(3 == modint((CShort)(3)).val)
      #expect(3 == modint((CUnsignedShort)(3)).val)
      #expect(3 == modint((CInt)(3)).val)
      #expect(3 == modint((CUnsignedInt)(3)).val)
      #expect(3 == modint((CLong)(3)).val)
      #expect(3 == modint((CUnsignedLong)(3)).val)
      #expect(3 == modint((CLongLong)(3)).val)
      #expect(3 == modint((CUnsignedLongLong)(3)).val)
      #expect(1 == modint((CSignedChar)(-10)).val)
      #expect(1 == modint((CShort)(-10)).val)
      #expect(1 == modint((CInt)(-10)).val)
      #expect(1 == modint((CLong)(-10)).val)
      #expect(1 == modint((CLongLong)(-10)).val)

      #expect(2 == (CInt(1) + modint(1)).val)
      #expect(2 == (CShort(1) + modint(1)).val)

      let m = modint()
      #expect(0 == m.val)
    }

    @Test(.tags(.aclPort))
    func testConstructorStatic() throws {
      typealias mint = static_modint<mod_11>
      #expect(1 == mint(true).val)
      #expect(3 == mint((CChar)(3)).val)
      #expect(3 == mint((CSignedChar)(3)).val)
      #expect(3 == mint((CUnsignedChar)(3)).val)
      #expect(3 == mint((CShort)(3)).val)
      #expect(3 == mint((CUnsignedShort)(3)).val)
      #expect(3 == mint((CInt)(3)).val)
      #expect(3 == mint((CUnsignedInt)(3)).val)
      #expect(3 == mint((CLong)(3)).val)
      #expect(3 == mint((CUnsignedLong)(3)).val)
      #expect(3 == mint((CLongLong)(3)).val)
      #expect(3 == mint((CUnsignedLongLong)(3)).val)
      #expect(1 == mint((CSignedChar)(-10)).val)
      #expect(1 == mint((CShort)(-10)).val)
      #expect(1 == mint((CInt)(-10)).val)
      #expect(1 == mint((CLong)(-10)).val)
      #expect(1 == mint((CLongLong)(-10)).val)

      #expect(2 == (CInt(1) + mint(1)).val)
      #expect(2 == (CShort(1) + mint(1)).val)

      let m = mint()
      #expect(0 == m.val)
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

}
