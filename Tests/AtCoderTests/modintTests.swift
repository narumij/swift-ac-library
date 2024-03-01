//
//  modintTests.swift
//  
//
//  Created by narumij on 2023/11/12.
//

import XCTest
@testable import AtCoder

fileprivate typealias uint = CUnsignedInt;
fileprivate typealias ll = CLongLong;
fileprivate typealias ull = CUnsignedLongLong;

fileprivate func gcd(_ a: ll,_ b: ll) -> ll{
    if (b == 0) { return a; }
    return gcd(b, a % b);
}

final class modintTests: XCTestCase {

    enum mod_1:             static_mod { static let mod: mod_value = 1 }
    enum mod_11:            static_mod { static let mod: mod_value = 11 }
    enum mod_12:            static_mod { static let mod: mod_value = 12 }
    enum mod_1_000_000_007: static_mod { static let mod: mod_value = .mod_1_000_000_007 }
    enum mod_1_000_000_008: static_mod { static let mod: mod_value = 1_000_000_008 }
    enum INT32_MAX:         static_mod { static let mod: mod_value = .mod_INT32_MAX }

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

        typealias mint = static_modint<mod_1>;
//        for (int i = 0; i < 100; i++) {
        for i in 0..<100 {
//            for (int j = 0; j < 100; j++) {
            for j in 0..<100 {
                XCTAssertEqual((mint(i) * mint(j)).val(), 0);
            }
        }
        XCTAssertEqual((mint(1234) + mint(5678)).val(), 0);
        XCTAssertEqual((mint(1234) - mint(5678)).val(), 0);
        XCTAssertEqual((mint(1234) * mint(5678)).val(), 0);
        XCTAssertEqual((mint(1234).pow(5678)), 0);
        XCTAssertEqual(0, modint(0).inv());

        XCTAssertEqual(0, mint(true).val());
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
        
        typealias mint = static_modint<INT32_MAX>;
//        for (int i = 0; i < 100; i++) {
        for i in uint(0)..<100 {
//            for (int j = 0; j < 100; j++) {
            for j in uint(0)..<100 {
                XCTAssertEqual((mint(i) * mint(j)).val(), i * j);
            }
        }
        XCTAssertEqual((mint(1234) + mint(5678)).val(), 1234 + 5678);
        XCTAssertEqual((mint(1234) - mint(5678)).val(), uint(Int32.max - 5678 + 1234));
        XCTAssertEqual((mint(1234) * mint(5678)).val(), 1234 * 5678);
        XCTAssertEqual((mint(Int32.max) + mint(Int32.max)).val(), 0);
    }
    
    func testInt128() throws {
        throw XCTSkip("該当する型がない？")
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
        
//        for (int i = 1; i < 10; i++) {
        for i in uint(1)..<10 {
            let x = static_modint<mod_11>(i).inv().val();
            XCTAssertEqual(1, (x * i) % 11);
        }

//        for (int i = 1; i < 11; i++) {
        for i in uint(1)..<11 {
            if (gcd(ll(i), 12) != 1) { continue; }
            let x = static_modint<mod_12>(i).inv().val();
            XCTAssertEqual(1, (x * i) % 12);
        }

//        for (int i = 1; i < 100000; i++) {
        for i in ll(1)..<100_000 {
            let x = static_modint<mod_1_000_000_007>(i).inv().val();
            XCTAssertEqual(1, (ll(x) * i) % 1_000_000_007);
        }

//        for (int i = 1; i < 100000; i++) {
        for i in ll(1)..<100_000 {
            if (gcd(ll(i), 1_000_000_008) != 1) { continue; }
            let x = static_modint<mod_1_000_000_008>(i).inv().val();
            XCTAssertEqual(1, (ll(x) * i) % 1_000_000_008);
        }
        
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
        typealias sint = static_modint<mod_11>;
        let a: sint  = 9;
        XCTAssertEqual(9, a.val());
        typealias dint = modint;
        dint.set_mod(11);
        let b: dint = 9;
        XCTAssertEqual(9, b.val());
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
        typealias mint = static_modint<mod_11>;
        XCTAssertEqual(11, mint.mod());
        XCTAssertEqual(4, +mint(4));
        XCTAssertEqual(7, -mint(4));

        XCTAssertFalse(mint(1) == mint(3));
        XCTAssertTrue(mint(1) != mint(3));
        XCTAssertTrue(mint(1) == mint(12));
        XCTAssertFalse(mint(1) != mint(12));

//        XCTAssertThrowsError(mint(3).pow(-1), ".*");
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
    
    func testDynamicUsage2() throws {
        typealias mint = modint;
        mint.set_mod(998244353);
        do {
            var m = mint(1)
            m += mint(2)
            XCTAssertEqual(3, m.val());
        }
        do {
            var m = mint(1)
            m += 2
            XCTAssertEqual(3, m.val());
        }

        mint.set_mod(3);
        do {
            var m = mint(2)
            m -= mint(1)
            XCTAssertEqual(1, m.val());
        }
        do {
            var m = mint(1)
            m += 2
            XCTAssertEqual(0, m.val());
        }

        mint.set_mod(11);
        do {
            var m = mint(3)
            m *= mint(5)
            XCTAssertEqual(4, m.val());
        }
    }

    func testConstructor() throws {
        modint.set_mod(11);
        XCTAssertEqual(1, modint(true).val());
        XCTAssertEqual(3, modint((CChar)(3)).val());
        XCTAssertEqual(3, modint((CSignedChar)(3)).val());
        XCTAssertEqual(3, modint((CUnsignedChar)(3)).val());
        XCTAssertEqual(3, modint((CShort)(3)).val());
        XCTAssertEqual(3, modint((CUnsignedShort)(3)).val());
        XCTAssertEqual(3, modint((CInt)(3)).val());
        XCTAssertEqual(3, modint((CUnsignedInt)(3)).val());
        XCTAssertEqual(3, modint((CLong)(3)).val());
        XCTAssertEqual(3, modint((CUnsignedLong)(3)).val());
        XCTAssertEqual(3, modint((CLongLong)(3)).val());
        XCTAssertEqual(3, modint((CUnsignedLongLong)(3)).val());
        XCTAssertEqual(1, modint((CSignedChar)(-10)).val());
        XCTAssertEqual(1, modint((CShort)(-10)).val());
        XCTAssertEqual(1, modint((CInt)(-10)).val());
        XCTAssertEqual(1, modint((CLong)(-10)).val());
        XCTAssertEqual(1, modint((CLongLong)(-10)).val());

//        XCTAssertEqual(2, (CInt(1) + modint(1)).val());
//        XCTAssertEqual(2, (CShort(1) + modint(1)).val());
        
        let m = modint();
        XCTAssertEqual(0, m.val());
    }
    
    func testConstructorStatic() throws {
        typealias mint = static_modint<mod_11>;
        XCTAssertEqual(1, mint(true).val());
        XCTAssertEqual(3, mint((CChar)(3)).val());
        XCTAssertEqual(3, mint((CSignedChar)(3)).val());
        XCTAssertEqual(3, mint((CUnsignedChar)(3)).val());
        XCTAssertEqual(3, mint((CShort)(3)).val());
        XCTAssertEqual(3, mint((CUnsignedShort)(3)).val());
        XCTAssertEqual(3, mint((CInt)(3)).val());
        XCTAssertEqual(3, mint((CUnsignedInt)(3)).val());
        XCTAssertEqual(3, mint((CLong)(3)).val());
        XCTAssertEqual(3, mint((CUnsignedLong)(3)).val());
        XCTAssertEqual(3, mint((CLongLong)(3)).val());
        XCTAssertEqual(3, mint((CUnsignedLongLong)(3)).val());
        XCTAssertEqual(1, mint((CSignedChar)(-10)).val());
        XCTAssertEqual(1, mint((CShort)(-10)).val());
        XCTAssertEqual(1, mint((CInt)(-10)).val());
        XCTAssertEqual(1, mint((CLong)(-10)).val());
        XCTAssertEqual(1, mint((CLongLong)(-10)).val());

//        XCTAssertEqual(2, (CInt(1) + mint(1)).val());
//        XCTAssertEqual(2, (CShort(1) + mint(1)).val());

        let m = mint();
        XCTAssertEqual(0, m.val());
    }
    
    func testSome() throws {
        typealias mint = modint998244353
        XCTAssertEqual(1, (mint(3) / 2).val() - CUnsignedInt((mint.mod() + 1) / 2))
        XCTAssertEqual(4, (mint(9) / 2).val() - CUnsignedInt((mint.mod() + 1) / 2))
        XCTAssertEqual(18, (mint(36) / 2).val())
        
        XCTAssertEqual(0, mint(false).val());
        XCTAssertEqual(0, modint(false).val());
        
        XCTAssertEqual("0", modint(false).description);
    }
    
    func testEtc() throws {
        typealias mint = modint998244353
        let K = 2
        var p = mint(1) / K
    }
    
    func testIntOperatorsStatic() throws {
        typealias mint = modint998244353
        XCTAssertEqual(998244353, mint.id)
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
    
    func testIntOperatorsDynamic() throws {
        typealias mint = modint
        XCTAssertEqual(-1, mint.id)
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
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
