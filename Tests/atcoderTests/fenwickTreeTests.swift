//
//  fenwickTreeTests.swift
//  
//
//  Created by narumij on 2023/11/14.
//

import XCTest
@testable import atcoder

fileprivate typealias int = CInt;
fileprivate typealias uint = CUnsignedInt;
fileprivate typealias ll = CLongLong;
fileprivate typealias ull = CUnsignedLongLong;

final class fenwickTreeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func ASSERT_EQ<T: Equatable>(_ lhs: T, _ rhs: T) {
        XCTAssertEqual(lhs, rhs)
    }
    
    func testEmpty() throws {
        var fw_ll = fenwick_tree<ll>();
        ASSERT_EQ(0, fw_ll.sum(0, 0));

        var fw_modint = fenwick_tree<modint>();
        ASSERT_EQ(0, fw_modint.sum(0, 0)?.val());
    }
    
    func testAssign() throws {
        /*
         fenwick_tree<ll> fw;
         fw = fenwick_tree<ll>(10);
         */
    }
    
    func testZero() throws {
        var fw_ll = fenwick_tree<ll>(0);
        ASSERT_EQ(0, fw_ll.sum(0, 0));

        var fw_modint = fenwick_tree<modint>(0);
        ASSERT_EQ(0, fw_modint.sum(0, 0)?.val());
    }
    
    func testOverFlowULL() throws {
        var fw = fenwick_tree<ull>(10);
//        for (int i = 0; i < 10; i++) {
        for i in 0..<10 {
            fw.add(i, (1 << 63) + ull(i));
        }
//        for (int i = 0; i <= 10; i++) {
        for i in 0..<=10 {
//            for (int j = i; j <= 10; j++) {
            for j in 0..<=10 {
                var sum = 0;
//                for (int k = i; k < j; k++) {
                for k in stride(from: i, to: j, by: 1) {
                    sum += k;
                }
                if i <= j {
                    ASSERT_EQ(ull(bitPattern: ll(((j - i) % 2) != 0 ? (1 << 63) + sum : sum)), fw.sum(i, j)
                    );
                }
            }
        }
    }
    
    func testNaiveTest() throws {
//        for (int n = 0; n <= 50; n++) {
        for n in 0..<=50 {
            var fw = fenwick_tree<ll>(n);
//            for (int i = 0; i < n; i++) {
            for i in 0..<n {
                fw.add(i, ll(i * i));
            }
//            for (int l = 0; l <= n; l++) {
            for l in 0..<=n {
//                for (int r = l; r <= n; r++) {
                for r in l..<=n {
                    var sum = 0;
//                    for (int i = l; i < r; i++) {
                    for i in l..<r {
                        sum += i * i;
                    }
                    ASSERT_EQ(ll(sum), fw.sum(l, r));
                }
            }
        }
    }
    
    func testSMintTest() throws {
        enum mod_11: static_mod { static let modValue: barrett = 11 }
        typealias mint = static_modint<mod_11>;
        for n in 0..<=50 {
            var fw = fenwick_tree<mint>(n);
//            for (int i = 0; i < n; i++) {
            for i in 0..<n {
                fw.add(i, mint(i * i));
            }
//            for (int l = 0; l <= n; l++) {
            for l in 0..<=n {
//                for (int r = l; r <= n; r++) {
                for r in l..<=n {
                    var sum = 0;
//                    for (int i = l; i < r; i++) {
                    for i in l..<r {
                        sum += i * i;
                    }
                    ASSERT_EQ(mint(sum), fw.sum(l, r));
                }
            }
        }
    }
    
    func testMintTest() throws {
        typealias mint = modint;
        for n in 0..<=50 {
            var fw = fenwick_tree<mint>(n);
//            for (int i = 0; i < n; i++) {
            for i in 0..<n {
                fw.add(i, mint(i * i));
            }
//            for (int l = 0; l <= n; l++) {
            for l in 0..<=n {
//                for (int r = l; r <= n; r++) {
                for r in l..<=n {
                    var sum = 0;
//                    for (int i = l; i < r; i++) {
                    for i in l..<r {
                        sum += i * i;
                    }
                    ASSERT_EQ(mint(sum), fw.sum(l, r));
                }
            }
        }
    }
    
    func testInvalid() throws {
        throw XCTSkip("いつかやる")
        
        /*
        EXPECT_THROW(auto s = fenwick_tree<int>(-1), std::exception);
        fenwick_tree<int> s(10);

        EXPECT_DEATH(s.add(-1, 0), ".*");
        EXPECT_DEATH(s.add(10, 0), ".*");

        EXPECT_DEATH(s.sum(-1, 3), ".*");
        EXPECT_DEATH(s.sum(3, 11), ".*");
        EXPECT_DEATH(s.sum(5, 3), ".*");
         */
    }
    
    func testBound() throws {
        var fw = fenwick_tree<int>(10);
        fw.add(3, int.max);
        fw.add(5, int.min);
        ASSERT_EQ(int(bitPattern: int.Magnitude(bitPattern: -1)), fw.sum(0, 10));
        ASSERT_EQ(int(bitPattern: int.Magnitude(bitPattern: -1)), fw.sum(3, 6));
        ASSERT_EQ(int.max, fw.sum(3, 4));
        ASSERT_EQ(int.min, fw.sum(4, 10));
    }
    
    func testBoundll() throws {
        
//        throw XCTSkip("クラッシュする。あとでなおす")

        var fw = fenwick_tree<ll>(10);
        fw.add(3, ll.max);
        fw.add(5, ll.min);
        XCTAssertEqual(ll(bitPattern: ll.Magnitude(bitPattern: -1)), fw.sum(0, 10));
        XCTAssertEqual(ll(bitPattern: ll.Magnitude(bitPattern: -1)), fw.sum(3, 6));
        XCTAssertEqual(ll.max, fw.sum(3, 4));
        XCTAssertEqual(ll.min, fw.sum(4, 10));
        /*
         fenwick_tree<ll> fw(10);
         fw.add(3, std::numeric_limits<ll>::max());
         fw.add(5, std::numeric_limits<ll>::min());
         ASSERT_EQ(-1, fw.sum(0, 10));
         ASSERT_EQ(-1, fw.sum(3, 6));
         ASSERT_EQ(std::numeric_limits<ll>::max(), fw.sum(3, 4));
         ASSERT_EQ(std::numeric_limits<ll>::min(), fw.sum(4, 10));
         */
    }
    
    func testOverFlow() throws {
        
//        throw XCTSkip("クラッシュする。あとでなおす")

//         fenwick_tree<int> fw(20);
        var fw = fenwick_tree<int>(20);
//         std::vector<ll> a(20);
        var a = [ll](repeating: 0, count: 20)
//         for (int i = 0; i < 10; i++) {
        for i in 0..<10 {
//             int x = std::numeric_limits<int>::max();
            var x = int.max
             a[i] += ll(x);
             fw.add(i, x);
         }
//         for (int i = 10; i < 20; i++) {
        for i in 10..<20 {
//             int x = std::numeric_limits<int>::min();
            var x = int.min
             a[i] += ll(x);
             fw.add(i, x);
         }
         a[5] += 11111;
         fw.add(5, 11111);

//         for (int l = 0; l <= 20; l++) {
        for l in 0..<=20 {
//             for (int r = l; r <= 20; r++) {
            for r in l..<=20 {
                var sum: ll = 0;
//                 for (int i = l; i < r; i++) {
                for i in l..<r {
                     sum &+= ll(a[i]);
                 }
                 var dif = sum - ll(fw.sum(l, r) ?? 0);
                if dif != 0 {
                    XCTAssertEqual(0, dif % (1 << 32));
                }
             }
         }
    }
    
    func testInt128() throws {
        
        throw XCTSkip("該当する型がない？")

        /*
         fenwick_tree<__int128> fw(20);
         for (int i = 0; i < 20; i++) {
             fw.add(i, i);
         }

         for (int l = 0; l <= 20; l++) {
             for (int r = l; r <= 20; r++) {
                 ll sum = 0;
                 for (int i = l; i < r; i++) {
                     sum += i;
                 }
                 ASSERT_EQ(sum, fw.sum(l, r));
             }
         }
         */
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
