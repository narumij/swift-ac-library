import XCTest
import AtCoder
import Numerics

fileprivate typealias int = CInt;
fileprivate typealias uint = CUnsignedInt;
fileprivate typealias ll = CLongLong;
fileprivate typealias ull = CUnsignedLongLong;

extension dynamic_mod {
    // 型の生存期間が各テストメソッドのスコープを超えるので、都度リセットする必要がある。
    static func reset() {
        bt = .default
    }
}

final class modintTests: XCTestCase {
    
    enum mod_1:             static_mod { static let mod: mod_value = 1 }
    enum mod_11:            static_mod { static let mod: mod_value = 11 }
    enum mod_12:            static_mod { static let mod: mod_value = 12 }
    enum mod_1_000_000_007: static_mod { static let mod: mod_value = .mod_1_000_000_007 }
    enum mod_1_000_000_008: static_mod { static let mod: mod_value = 1_000_000_008 }
    enum INT32_MAX:         static_mod { static let mod: mod_value = .mod_INT32_MAX }
    
    func testDynamicBorder() throws {
        
        typealias mint = modint;
        let mod_upper = CUnsignedInt(CInt.max);
        // for (unsigned int mod = mod_upper; mod >= mod_upper - 20; mod--) {
        for mod in mod_upper ..>= (mod_upper - 20) as StrideThrough<uint> {
            mint.set_mod(int(mod))
            var v: [ll] = []
            // for (int i = 0; i < 10; i++) {
            for i in 0 ..< 10 as Range<int> {
                v.append(ll(i))
                v.append(ll(int(mod) - i))
                v.append(ll(int(mod) / 2 + i))
                v.append(ll(int(mod) / 2 - i))
            }
            for a in v {
                let mod = ll(mod)
                XCTAssertEqual(uint(((a &* a) % mod &* a) % mod), (mint(a).pow(3)).val, "mod = \(mod), a = \(a)")
                for b in v {
                    XCTAssertEqual(uint((a &+ b) % mod), (mint(a) + mint(b)).val, "mod = \(mod)")
                    XCTAssertEqual(uint((a &- b &+ mod) % mod), (mint(a) - mint(b)).val, "mod = \(mod)")
                    XCTAssertEqual(uint((a &* b) % mod), (mint(a) * mint(b)).val, "mod = \(mod)")
                }
            }
        }
        
        mod_dynamic.reset()
    }
    
    func testDynamicBorderAlt() throws {
        
        let ab: [(mod: uint,a:ll,uint,[(b:ll,uint,uint,uint)])] = [
            (2147483647,0,0,
             [(0,0,0,0),
              (2147483647,0,0,0),
              (1073741823,1073741823,1073741824,0),
              (1073741823,1073741823,1073741824,0),
             ]),
            (2147483647,2147483647,0,
             [(0,0,0,0),
              (2147483647,0,0,0),
              (1073741823,1073741823,1073741824,0),
              (1073741823,1073741823,1073741824,0),
             ]),
            (2147483647,1073741823,1879048191,
             [(0,1073741823,1073741823,0),
              (2147483647,1073741823,1073741823,0),
              (1073741823,2147483646,0,536870912),
              (1073741823,2147483646,0,536870912),
             ]),
            (2147483647,1073741823,1879048191,
             [(0,1073741823,1073741823,0),
              (2147483647,1073741823,1073741823,0),
              (1073741823,2147483646,0,536870912),
              (1073741823,2147483646,0,536870912),
             ]),
        ]
        
        typealias mint = modint;
        
        for (mod, a, ans1, bb) in ab {
            mint.set_mod(CInt(mod));
            let a = uint(a)
            XCTAssertEqual(ans1, (mint(a).pow(3)).val, "pow mod = \(mod)");
            for (b, ans2, ans3, ans4) in bb {
                let b = uint(b)
                XCTAssertEqual(ans2, (mint(a) + mint(b)).val, "+ mod = \(mod)");
                XCTAssertEqual(ans3, (mint(a) - mint(b)).val, "- mod = \(mod)");
                XCTAssertEqual(ans4, (mint(a) * mint(b)).val, "* mod = \(mod)");
            }
        }
        
        mod_dynamic.reset()
    }
    
    func testULL() throws {
        modint.set_mod(998244353);
        XCTAssertNotEqual(uint(modint.mod - 1), modint(ull(bitPattern: -1)).val)
        XCTAssertNotEqual(0, (ull(bitPattern: -1) + modint(1)).val);
        typealias mint = modint998244353;
        XCTAssertNotEqual(uint(mint.mod - 1), mint(ull(bitPattern: -1)).val);
        XCTAssertNotEqual(0, (ull(bitPattern: -1) + mint(1)).val);
        
        mod_dynamic.reset()
    }
    
    func testMod1() throws {
        modint.set_mod(1)
        // for (int i = 0; i < 100; i++) {
        for i in 0 ..< 100 as Range<int> {
            // for (int j = 0; j < 100; j++) {
            for j in 0 ..< 100 as Range<int> {
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
        for i in 0 ..< 100 as Range<int> {
            // for (int j = 0; j < 100; j++) {
            for j in 0 ..< 100 as Range<int> {
                XCTAssertEqual((mint(i) * mint(j)).val, 0)
            }
        }
        XCTAssertEqual((mint(1234) + mint(5678)).val, 0)
        XCTAssertEqual((mint(1234) - mint(5678)).val, 0)
        XCTAssertEqual((mint(1234) * mint(5678)).val, 0)
        XCTAssertEqual((mint(1234).pow(5678)), 0)
        XCTAssertEqual(0, modint(0).inv)
        
        XCTAssertEqual(0, mint(true).val)
        
        mod_dynamic.reset()
    }
    
    func testModIntMax() throws {
        modint.set_mod(CInt.max)
        // for (int i = 0; i < 100; i++) {
        for i in 0 ..< 100 as Range<int> {
            // for (int j = 0; j < 100; j++) {
            for j in 0 ..< 100 as Range<int> {
                XCTAssertEqual((modint(i) * modint(j)).val, uint(i * j))
            }
        }
        XCTAssertEqual((modint(1234) + modint(5678)).val, 1234 + 5678)
        XCTAssertEqual((modint(1234) - modint(5678)).val, uint(CInt.max - 5678 + 1234))
        XCTAssertEqual((modint(1234) * modint(5678)).val, 1234 * 5678)
        
        typealias mint = static_modint<INT32_MAX>
        // for (int i = 0; i < 100; i++) {
        for i in 0 ..< 100 as Range<int> {
            // for (int j = 0; j < 100; j++) {
            for j in 0 ..< 100 as Range<int> {
                XCTAssertEqual((mint(i) * mint(j)).val, uint(i * j))
            }
        }
        XCTAssertEqual((mint(1234) + mint(5678)).val, 1234 + 5678)
        XCTAssertEqual((mint(1234) - mint(5678)).val, uint(Int32.max - 5678 + 1234))
        XCTAssertEqual((mint(1234) * mint(5678)).val, 1234 * 5678)
        XCTAssertEqual((mint(Int32.max) + mint(Int32.max)).val, 0)
        
        mod_dynamic.reset()
    }
    
#if false
    func testInt128() throws {
        throw XCTSkip("__int128がSwiftにはない")
        /*
         modint::set_mod(998244353);
         ASSERT_EQ(12345678, modint(__int128_t(12345678)).val());
         ASSERT_EQ(12345678, modint(__uint128_t(12345678)).val());
         ASSERT_EQ(12345678, modint(__int128(12345678)).val());
         ASSERT_EQ(12345678, modint((unsigned __int128)(12345678)).val());
         ASSERT_EQ(modint(2).pow(100).val(), modint(__int128_t(1) << 100).val());
         ASSERT_EQ(modint(2).pow(100).val(), modint(__uint128_t(1) << 100).val());
         using mint = static_modint<998244353>;
         ASSERT_EQ(12345678, mint(__int128_t(12345678)).val());
         ASSERT_EQ(12345678, mint(__uint128_t(12345678)).val());
         ASSERT_EQ(12345678, mint(__int128(12345678)).val());
         ASSERT_EQ(12345678, mint((unsigned __int128)(12345678)).val());
         ASSERT_EQ(mint(2).pow(100).val(), mint(__int128_t(1) << 100).val());
         ASSERT_EQ(mint(2).pow(100).val(), mint(__uint128_t(1) << 100).val());
         */
    }
#endif
    
    func testInv() throws {
        
        for i in 1 ..< 10 as Range<int> {
            let x = static_modint<mod_11>(i).inv.val
            XCTAssertEqual(1, (int(x) * i) % 11)
        }
        
        for i in 1 ..< 11 as Range<int> {
            if gcd(i, 12) != 1 { continue }
            let x = static_modint<mod_12>(i).inv.val
            XCTAssertEqual(1, (int(x) * i) % 12)
        }
        
        for i in 1 ..< 100_000 as Range<int> {
            let x = static_modint<mod_1_000_000_007>(i).inv.val
            XCTAssertEqual(1, (ll(x) * ll(i)) % 1_000_000_007)
        }
        
        for i in 1 ..< 100_000 as Range<int> {
            if gcd(i, 1_000_000_008) != 1 { continue }
            let x = static_modint<mod_1_000_000_008>(i).inv.val
            XCTAssertEqual(1, (ll(x) * ll(i)) % 1_000_000_008)
        }
        
        modint.set_mod(998244353);
        for i in 1 ..< 100000 as Range<int> {
            let x = modint(i).inv.val
            XCTAssertLessThanOrEqual(0, x)
            XCTAssertGreaterThanOrEqual(998244353 - 1, x)
            XCTAssertEqual(1, (ll(x) * ll(i)) % 998244353)
        }
        
        modint.set_mod(1_000_000_008);
        for i in 1 ..< 100000 as Range<int> {
            if gcd(i, 1_000_000_008) != 1 { continue }
            let x = modint(i).inv.val
            XCTAssertEqual(1, (ll(x) * ll(i)) % 1_000_000_008)
        }
        
        modint.set_mod(CInt.max);
        for i in 1 ..< 100000 as Range<int> {
            if gcd(i, int.max) != 1 { continue }
            let x = modint(i).inv.val
            XCTAssertEqual(1, (ll(x) * ll(i) % ll(int.max)))
        }
        
        mod_dynamic.reset()
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
        typealias mint = static_modint<mod_11>;
        XCTAssertEqual(11, mint.mod);
        XCTAssertEqual(4, +mint(4));
        XCTAssertEqual(7, -mint(4));
        
        XCTAssertFalse(mint(1) == mint(3));
        XCTAssertTrue(mint(1) != mint(3));
        XCTAssertTrue(mint(1) == mint(12));
        XCTAssertFalse(mint(1) != mint(12));
        
        // Swift Packageでは実施不可
        // XCTAssertThrowsError(mint(3).pow(-1), ".*");
    }
    
    func testDynamicUsage() throws {
        
        // C++版では整数で型の区別をしていたようだが、Swiftでは型を挿入することにする。
        // generics型ではstored propertyを使えないため、non genericsのdynamic_mod派生にbtを持たせている。
        enum _12345: dynamic_mod { static var bt: barrett = .default }
        XCTAssertEqual(998244353, dynamic_modint<_12345>.mod)
        
        dynamic_modint<_12345>.set_mod(11)
        XCTAssertNotEqual(mod_dynamic.bt, _12345.bt)
        XCTAssertNotEqual(modint.mod, dynamic_modint<_12345>.mod)
        
        typealias mint = modint
        
        mint.set_mod(998244353)
        XCTAssertEqual(998244353, mint.mod)
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
        // XCTAssertThrowsError(mint(3).pow(-1), ".*");
        
        mod_dynamic.reset()
    }
    
    func testDynamicUsage2() throws {
        typealias mint = modint;
        mint.set_mod(998244353);
        do {
            var m = mint(1)
            m += mint(2)
            XCTAssertEqual(3, m.val);
        }
        do {
            var m = mint(1)
            m += 2
            XCTAssertEqual(3, m.val);
        }
        
        mint.set_mod(3);
        do {
            var m = mint(2)
            m -= mint(1)
            XCTAssertEqual(1, m.val);
        }
        do {
            var m = mint(1)
            m += 2
            XCTAssertEqual(0, m.val);
        }
        
        mint.set_mod(11);
        do {
            var m = mint(3)
            m *= mint(5)
            XCTAssertEqual(4, m.val);
        }
        
        mod_dynamic.reset()
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
        
        mod_dynamic.reset()
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
        
        let m = mint();
        XCTAssertEqual(0, m.val)
    }
    
    func testSome() throws {
        typealias mint = modint998244353
        XCTAssertEqual(1, (mint(3) / 2).val - CUnsignedInt((mint.mod + 1) / 2))
        XCTAssertEqual(4, (mint(9) / 2).val - CUnsignedInt((mint.mod + 1) / 2))
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
        
        mod_dynamic.reset()
    }
    
    func testEtc() throws {
        typealias mint = modint998244353
        let K = 2
        _ = mint(1) / K
    }
    
    func testEtc2() throws {
        let ne1: (CUnsignedLongLong,CUnsignedInt) = (998244352,932051909)
        XCTAssertEqual(ne1.0, CUnsignedLongLong(modint.mod - 1));
        XCTAssertEqual(ne1.1, modint(CUnsignedLongLong(bitPattern: CLongLong(-1))).val);
        let ne2: (CUnsignedInt,CUnsignedInt) = (0,932051910)
        XCTAssertEqual(ne2.1, (modint(CUnsignedLongLong(bitPattern: CLongLong(-1))) + modint(1)).val);
    }
    
}
