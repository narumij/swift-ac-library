//
//  modintTests.swift
//  
//
//  Created by narumij on 2023/11/12.
//

import XCTest
@testable import atcoder

fileprivate typealias uint = CUnsignedInt;
fileprivate typealias ll = CLongLong;
fileprivate typealias ull = CUnsignedLongLong;

fileprivate func gcd(_ a: ll,_ b: ll) -> ll{
    if (b == 0) { return a; }
    return gcd(b, a % b);
}

final class modintTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDynamicBorder() throws {
        
        typealias mint = modint;
        let mod_upper = CUnsignedInt(CInt.max);
//        for (unsigned int mod = mod_upper; mod >= mod_upper - 20; mod--) {
        for mod in mod_upper..>=(mod_upper - 20) {
            mint.set_mod(CInt(mod));
            var v: [ll] = [];
//            for (int i = 0; i < 10; i++) {
            for i in ll(0)..<10 {
                v.append(i);
                v.append(ll(mod) - i);
                v.append(ll(mod) / 2 + i);
                v.append(ll(mod) / 2 - i);
            }
//            for (ll a : v) {
            for a in v {
                let mod = ll(mod)
                XCTAssertEqual(uint(((a &* a) % mod &* a) % mod), (mint(uint(a)).pow(3)).val(), "mod = \(mod), a = \(a)");
//                for (ll b : v) {
                for b in v {
                    XCTAssertEqual(uint((a &+ b) % mod), (mint(uint(a)) + mint(uint(b))).val(), "mod = \(mod)");
                    XCTAssertEqual(uint((a &- b &+ mod) % mod), (mint(uint(a)) - mint(uint(b))).val(), "mod = \(mod)");
                    XCTAssertEqual(uint((a &* b) % mod), (mint(uint(a)) * mint(uint(b))).val(), "mod = \(mod)");
                }
            }
        }
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
            XCTAssertEqual(ans1, (mint(a).pow(3)).val(), "pow mod = \(mod)");
            for (b, ans2, ans3, ans4) in bb {
                let b = uint(b)
                XCTAssertEqual(ans2, (mint(a) + mint(b)).val(), "+ mod = \(mod)");
                XCTAssertEqual(ans3, (mint(a) - mint(b)).val(), "- mod = \(mod)");
                XCTAssertEqual(ans4, (mint(a) * mint(b)).val(), "* mod = \(mod)");
            }
        }
    }

    func testULL() throws {
        modint.set_mod(998244353);
        XCTAssertNotEqual(
            CUnsignedLongLong(modint.mod() - 1),
            CUnsignedLongLong(modint(CUnsignedLongLong(bitPattern: CLongLong(-1))).val()));
        XCTAssertNotEqual(0, (modint(CUnsignedLongLong(bitPattern: CLongLong(-1))) + modint(1)).val());
        
        let ne1: (CUnsignedLongLong,CUnsignedInt) = (998244352,932051909)
        XCTAssertEqual(ne1.0, CUnsignedLongLong(modint.mod() - 1));
        XCTAssertEqual(ne1.1, modint(CUnsignedLongLong(bitPattern: CLongLong(-1))).val());
        let ne2: (CUnsignedInt,CUnsignedInt) = (0,932051910)
        XCTAssertEqual(ne2.1, (modint(CUnsignedLongLong(bitPattern: CLongLong(-1))) + modint(1)).val());
        
        do {
            typealias mint = modint998244353;
            XCTAssertNotEqual(UInt32(mint.mod()) - 1, mint(CUnsignedLongLong(bitPattern: CLongLong(-1))).val());
            XCTAssertNotEqual(0, (mint(CUnsignedLongLong(bitPattern: CLongLong(-1))) + mint(1)).val());
        }
    }
    
    func testMod1() throws {
        modint.set_mod(1);
//        for (int i = 0; i < 100; i++) {
        for i in CInt(0)..<100 {
//            for (int j = 0; j < 100; j++) {
            for j in CInt(0)..<100 {
                XCTAssertEqual((modint(i) * modint(j)).val(), 0);
            }
        }
        XCTAssertEqual((modint(1234) + modint(5678)).val(), 0);
        XCTAssertEqual((modint(1234) - modint(5678)).val(), 0);
        XCTAssertEqual((modint(1234) * modint(5678)).val(), 0);
        XCTAssertEqual((modint(1234).pow(5678)), 0);
        XCTAssertEqual(0, modint(0).inv());

        XCTAssertEqual(0, modint(true).val());

        /*
        using mint = static_modint<1>;
        for (int i = 0; i < 100; i++) {
            for (int j = 0; j < 100; j++) {
                ASSERT_EQ((mint(i) * mint(j)).val(), 0);
            }
        }
        ASSERT_EQ((mint(1234) + mint(5678)).val(), 0);
        ASSERT_EQ((mint(1234) - mint(5678)).val(), 0);
        ASSERT_EQ((mint(1234) * mint(5678)).val(), 0);
        ASSERT_EQ((mint(1234).pow(5678)), 0);
        ASSERT_EQ(0, modint(0).inv());

        ASSERT_EQ(0, mint(true).val());
         */
    }
    
    func testModIntMax() throws {
        modint.set_mod(CInt.max);
//        for (int i = 0; i < 100; i++) {
        for i in CInt(0)..<100 {
//            for (int j = 0; j < 100; j++) {
            for j in CInt(0)..<100 {
                XCTAssertEqual((modint(i) * modint(j)).val(), uint(i * j));
            }
        }
        XCTAssertEqual((modint(1234) + modint(5678)).val(), 1234 + 5678);
        XCTAssertEqual((modint(1234) - modint(5678)).val(), uint(CInt.max - 5678 + 1234));
        XCTAssertEqual((modint(1234) * modint(5678)).val(), 1234 * 5678);
        /*
        using mint = static_modint<INT32_MAX>;
        for (int i = 0; i < 100; i++) {
            for (int j = 0; j < 100; j++) {
                ASSERT_EQ((mint(i) * mint(j)).val(), i * j);
            }
        }
        ASSERT_EQ((mint(1234) + mint(5678)).val(), 1234 + 5678);
        ASSERT_EQ((mint(1234) - mint(5678)).val(), INT32_MAX - 5678 + 1234);
        ASSERT_EQ((mint(1234) * mint(5678)).val(), 1234 * 5678);
        ASSERT_EQ((mint(INT32_MAX) + mint(INT32_MAX)).val(), 0);
         */
    }
    
    func testInt128() throws {
        throw XCTSkip("わからない")
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
    
    func testInv() throws {
        /*
        for (int i = 1; i < 10; i++) {
            int x = static_modint<11>(i).inv().val();
            ASSERT_EQ(1, (x * i) % 11);
        }

        for (int i = 1; i < 11; i++) {
            if (gcd(i, 12) != 1) continue;
            int x = static_modint<12>(i).inv().val();
            ASSERT_EQ(1, (x * i) % 12);
        }

        for (int i = 1; i < 100000; i++) {
            int x = static_modint<1'000'000'007>(i).inv().val();
            ASSERT_EQ(1, (ll(x) * i) % 1'000'000'007);
        }

        for (int i = 1; i < 100000; i++) {
            if (gcd(i, 1'000'000'008) != 1) continue;
            int x = static_modint<1'000'000'008>(i).inv().val();
            ASSERT_EQ(1, (ll(x) * i) % 1'000'000'008);
        }
         */
        modint.set_mod(998244353);
//        for (int i = 1; i < 100000; i++) {
        for i in ll(1)..<100000 {
            let x = modint(i).inv().val();
            XCTAssertLessThanOrEqual(0, x);
            XCTAssertGreaterThanOrEqual(998244353 - 1, x);
            XCTAssertEqual(1, (ll(x) * i) % 998244353);
        }

        modint.set_mod(1_000_000_008);
//        for (int i = 1; i < 100000; i++) {
        for i in ll(1)..<100000 {
            if (gcd(i, 1_000_000_008) != 1) { continue; }
            let x = modint(i).inv().val();
            XCTAssertEqual(1, (ll(x) * i) % 1_000_000_008);
        }

        modint.set_mod(CInt.max);
//        for (int i = 1; i < 100000; i++) {
        for i in ll(1)..<100000 {
            if (gcd(i, ll(CInt.max)) != 1) { continue; }
            let x = modint(i).inv().val();
            XCTAssertEqual(1, (ll(x) * i) % ll(CInt.max));
        }
    }
    
    func testConstUsage() throws {
        throw XCTSkip("よくわからない")
        /*
         using sint = static_modint<11>;
         const sint a = 9;
         ASSERT_EQ(9, a.val());
         using dint = modint;
         dint::set_mod(11);
         const dint b = 9;
         ASSERT_EQ(9, b.val());
         */
    }
    
    func testIncrement() throws {
        throw XCTSkip("Swiftには無い")
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
    
    func testStaticUsage() throws {
        throw XCTSkip("未実装")
        /*
         using mint = static_modint<11>;
         ASSERT_EQ(11, mint::mod());
         ASSERT_EQ(4, +mint(4));
         ASSERT_EQ(7, -mint(4));

         ASSERT_FALSE(mint(1) == mint(3));
         ASSERT_TRUE(mint(1) != mint(3));
         ASSERT_TRUE(mint(1) == mint(12));
         ASSERT_FALSE(mint(1) != mint(12));

         EXPECT_DEATH(mint(3).pow(-1), ".*");
         */
    }
    
    func testDynamicUsage() throws {
//        XCTAssertEqual(998244353, dynamic_modint<12345>::mod());
        typealias mint = modint;
        mint.set_mod(998244353);
        XCTAssertEqual(998244353, mint.mod());
        XCTAssertEqual(3, (mint(1) + mint(2)).val());
        XCTAssertEqual(3, (1 + mint(2)).val());
        XCTAssertEqual(3, (mint(1) + 2).val());

        mint.set_mod(3);
        XCTAssertEqual(3, mint.mod());
        XCTAssertEqual(1, (mint(2) - mint(1)).val());
        XCTAssertEqual(0, (mint(1) + mint(2)).val());

        mint.set_mod(11);
        XCTAssertEqual(11, mint.mod());
        XCTAssertEqual(4, (mint(3) * mint(5)).val());

        XCTAssertEqual(4, +mint(4));
        XCTAssertEqual(7, -mint(4));

        XCTAssertFalse(mint(1) == mint(3));
        XCTAssertTrue(mint(1) != mint(3));
        XCTAssertTrue(mint(1) == mint(12));
        XCTAssertFalse(mint(1) != mint(12));

//        XCTAssertThrowsError(mint(3).pow(-1), ".*");
    }
    
    func testConstructor() throws {
        throw XCTSkip("いつかやる")
        /*
         modint::set_mod(11);
         ASSERT_EQ(1, modint(true).val());
         ASSERT_EQ(3, modint((char)(3)).val());
         ASSERT_EQ(3, modint((signed char)(3)).val());
         ASSERT_EQ(3, modint((unsigned char)(3)).val());
         ASSERT_EQ(3, modint((short)(3)).val());
         ASSERT_EQ(3, modint((unsigned short)(3)).val());
         ASSERT_EQ(3, modint((int)(3)).val());
         ASSERT_EQ(3, modint((unsigned int)(3)).val());
         ASSERT_EQ(3, modint((long)(3)).val());
         ASSERT_EQ(3, modint((unsigned long)(3)).val());
         ASSERT_EQ(3, modint((long long)(3)).val());
         ASSERT_EQ(3, modint((unsigned long long)(3)).val());
         ASSERT_EQ(1, modint((signed char)(-10)).val());
         ASSERT_EQ(1, modint((short)(-10)).val());
         ASSERT_EQ(1, modint((int)(-10)).val());
         ASSERT_EQ(1, modint((long)(-10)).val());
         ASSERT_EQ(1, modint((long long)(-10)).val());

         ASSERT_EQ(2, (int(1) + modint(1)).val());
         ASSERT_EQ(2, (short(1) + modint(1)).val());

         modint m;
         ASSERT_EQ(0, m.val());
         */
    }
    
    func testConstructorStatic() throws {
        throw XCTSkip("未実装")
        /*
         using mint = static_modint<11>;
         ASSERT_EQ(1, mint(true).val());
         ASSERT_EQ(3, mint((char)(3)).val());
         ASSERT_EQ(3, mint((signed char)(3)).val());
         ASSERT_EQ(3, mint((unsigned char)(3)).val());
         ASSERT_EQ(3, mint((short)(3)).val());
         ASSERT_EQ(3, mint((unsigned short)(3)).val());
         ASSERT_EQ(3, mint((int)(3)).val());
         ASSERT_EQ(3, mint((unsigned int)(3)).val());
         ASSERT_EQ(3, mint((long)(3)).val());
         ASSERT_EQ(3, mint((unsigned long)(3)).val());
         ASSERT_EQ(3, mint((long long)(3)).val());
         ASSERT_EQ(3, mint((unsigned long long)(3)).val());
         ASSERT_EQ(1, mint((signed char)(-10)).val());
         ASSERT_EQ(1, mint((short)(-10)).val());
         ASSERT_EQ(1, mint((int)(-10)).val());
         ASSERT_EQ(1, mint((long)(-10)).val());
         ASSERT_EQ(1, mint((long long)(-10)).val());

         ASSERT_EQ(2, (int(1) + mint(1)).val());
         ASSERT_EQ(2, (short(1) + mint(1)).val());

         mint m;
         ASSERT_EQ(0, m.val());
         */
    }
    
    func testSome() throws {
        typealias mint = modint998244353
        XCTAssertEqual(1, (mint(3) / 2).val() - CUnsignedInt((mint.mod() + 1) / 2))
        
        XCTAssertEqual(4, (mint(9) / 2).val() - CUnsignedInt((mint.mod() + 1) / 2))
        
        XCTAssertEqual(18, (mint(36) / 2).val())
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
