//
//  mathTests.swift
//  
//
//  Created by narumij on 2023/11/11.
//

import XCTest
@testable import atcoder

fileprivate typealias uint = CUnsignedInt;
fileprivate typealias ll = CLongLong;
fileprivate typealias ull = CUnsignedLongLong;

fileprivate func gcd(_ a: ll,_ b: ll) -> ll {
    assert(0 <= a && 0 <= b);
    if (b == 0) { return a; }
    return gcd(b, a % b);
}

fileprivate func pow_mod_naive(_ x: ll,_ n: ull,_ mod: uint) -> ll {
    let y: ull = ull((x % ll(mod) + ll(mod)) % ll(mod));
    var z: ull = 1;
//    for (ull i = 0; i < n; i++) {
    for _ in 0..<ull(n) {
        z = (z * y) % ull(mod);
    }
    return ll(z % ull(mod));
}

fileprivate func floor_sum_naive(_ n: ll,_ m: ll,_ a: ll,_ b: ll) -> ll {
    var sum: ll = 0;
//    for (ll i = 0; i < n; i++) {
    for i in 0..<n {
        var z: ll = a * i + b;
        sum += (z - `internal`.safe_mod(z, m)) / m;
    }
    return sum;
}

fileprivate func is_prime_naive(_ n: ll) -> Bool {
    assert(0 <= n && n <= CInt.max);
    if (n == 0 || n == 1) { return false; }
//    for (ll i = 2; i * i <= n; i++) {
    for i in ll(2)..<=n {
        if (n % i == 0) { return false; }
    }
    return true;
}

final class mathTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPowMod() throws {
        
        //throw XCTSkip("時間がかかるのでスキップ。一度テストは通っている。")
        
        func naive(_ x: ll,_ n: ll,_ mod: CInt) -> ll {
            let y: ll = `internal`.safe_mod(x, ll(mod));
            var z: ull = 1 % ull(mod);
//            for (ll i = 0; i < n; i++) {
            for i in ll(0)..<n {
                z = (z * ull(y)) % ull(mod);
            }
            return ll(z);
        };
//        for (int a = -100; a <= 100; a++) {
        for a in CInt(-100)..<100 {
//            for (int b = 0; b <= 100; b++) {
            for b in CInt(0)..<=100 {
//                for (int c = 1; c <= 100; c++) {
                for c in CInt(1)..<=100 {
                    XCTAssertEqual(naive(ll(a), ll(b), c), pow_mod(ll(a), ll(b), c));
                }
            }
        }
    }
    
    func testInvBoundHand() throws {
        let minll = ll.min;
        let maxll = ll.max;
        XCTAssertEqual(inv_mod(-1, maxll), inv_mod(minll, maxll));
        XCTAssertEqual(1, inv_mod(maxll, maxll - 1));
        XCTAssertEqual(maxll - 1, inv_mod(maxll - 1, maxll));
        XCTAssertEqual(2, inv_mod(maxll / 2 + 1, maxll));
    }
    
    func testInvMod() throws {
//        for (int a = -100; a <= 100; a++) {
        for a in ll(-100)..<=100 {
//            for (int b = 1; b <= 1000; b++) {
            for b in ll(1)..<=1000 {
                if (gcd(`internal`.safe_mod(a, b), b) != 1) { continue; }
                let c = inv_mod(a, b);
                XCTAssertLessThanOrEqual(0, c);
                XCTAssertLessThan(c, b);
                XCTAssertEqual(1 % b, ((a * c) % b + b) % b);
            }
        }
    }
    
    func testInvModZero() throws {
        XCTAssertEqual(0, inv_mod(0, 1));
//        for (int i = 0; i < 10; i++) {
        for i in ll(0)..<10 {
            XCTAssertEqual(0, inv_mod(i, 1));
            XCTAssertEqual(0, inv_mod(-i, 1));
            XCTAssertEqual(0, inv_mod(ll.min + i, 1));
            XCTAssertEqual(0, inv_mod(ll.max - i, 1));
        }
    }
    
    func testFloorSum() throws {
//        for (int n = 0; n < 20; n++) {
        for n in ll(0)..<20 {
//            for (int m = 1; m < 20; m++) {
            for m in ll(1)..<20 {
//                for (int a = -20; a < 20; a++) {
                for a in ll(-20)..<20 {
//                    for (int b = -20; b < 20; b++) {
                    for b in ll(-20)..<20 {
                        XCTAssertEqual(floor_sum_naive(n, m, a, b),
                                       floor_sum(n, m, a, b));
                    }
                }
            }
        }
    }
    
    func testCRTHand() throws {
        let res = crt([1, 2, 1], [2, 3, 2]);
        XCTAssertEqual(5, res.first);
        XCTAssertEqual(6, res.second);
    }
    
    func testCRT2() throws {
//        for (int a = 1; a <= 20; a++) {
        for a in ll(1)..<=20 {
//            for (int b = 1; b <= 20; b++) {
            for b in ll(1)..<=20 {
//                for (int c = -10; c <= 10; c++) {
                for c in ll(-10)..<=10 {
//                    for (int d = -10; d <= 10; d++) {
                    for d in ll(-10)..<10 {
                        let res = crt([c, d], [a, b]);
                        if (res.second == 0) {
//                            for (int x = 0; x < a * b / gcd(a, b); x++) {
                            do { var x: ll = 0; while x < a * b / gcd(a, b) { defer { x += 1 }
                                XCTAssertTrue(x % a != c || x % b != d);
                            } }
                            continue;
                        }
                        XCTAssertEqual(a * b / gcd(a, b), res.second);
                        XCTAssertEqual(`internal`.safe_mod(c, a), res.first % a);
                        XCTAssertEqual(`internal`.safe_mod(d, b), res.first % b);
                    }
                }
            }
        }
    }
    
    func testCRT3() throws {
//        for (int a = 1; a <= 5; a++) {
        for a in ll(1)..<=5 {
//            for (int b = 1; b <= 5; b++) {
            for b in ll(1)..<=5 {
//                for (int c = 1; c <= 5; c++) {
                for c in ll(1)..<=5 {
//                    for (int d = -5; d <= 5; d++) {
                    for d in ll(-5)..<=5 {
//                        for (int e = -5; e <= 5; e++) {
                        for e in ll(-5)..<=5 {
//                            for (int f = -5; f <= 5; f++) {
                            for f in ll(-5)..<=5 {
                                let res = crt([d, e, f], [a, b, c]);
                                var lcm = a * b / gcd(a, b);
                                lcm = lcm * c / gcd(lcm, c);
                                if (res.second == 0) {
//                                    for (int x = 0; x < lcm; x++) {
                                    for x in 0..<lcm {
                                        XCTAssertTrue(x % a != d || x % b != e ||
                                                    x % c != f);
                                    }
                                    continue;
                                }
                                XCTAssertEqual(lcm, res.second);
                                XCTAssertEqual(`internal`.safe_mod(d, a), res.first % a);
                                XCTAssertEqual(`internal`.safe_mod(e, b), res.first % b);
                                XCTAssertEqual(`internal`.safe_mod(f, c), res.first % c);
                            }
                        }
                    }
                }
            }
        }
    }
    
    func testCRTOverflow() throws {
        let r0: ll = 0;
        let r1: ll = 1_000_000_000_000 - 2;
        let m0: ll = 900577;
        let m1: ll = 1_000_000_000_000;
        let res = crt([r0, r1], [m0, m1]);
        XCTAssertEqual(m0 * m1, res.second);
        XCTAssertEqual(r0, res.first % m0);
        XCTAssertEqual(r1, res.first % m1);
    }
    
    func testCRTBound() throws {
        let INF = ll.max;
        var pred = [ll]();
//        for (int i = 1; i <= 10; i++) {
        for i in ll(1)..<=10 {
            pred.append(i);
            pred.append(INF - (i - 1));
        }
        pred.append(998244353);
        pred.append(1_000_000_007);
        pred.append(1_000_000_009);

        for ab in [(INF, INF),
                   (1, INF),
                   (INF, 1),
                   (7, INF),
                   (INF / 337, 337),
                   (2, (INF - 1) / 2)] {
            var a = ab.0;
            var b = ab.1;
//            for (int ph = 0; ph < 2; ph++) {
            for ph in 0..<2 {
//                for (ll ans : pred) {
                for ans in pred {
                    var res = crt([ans % a, ans % b], [a, b]);
                    var lcm = a / gcd(a, b) * b;
                    XCTAssertEqual(lcm, res.second);
                    XCTAssertEqual(ans % lcm, res.first);
                }
                swap(&a, &b);
            }
        }
        let factor_inf = ([49, 73, 127, 337, 92737, 649657] as [ll]).permutations()
        for factor_inf in factor_inf {
//            for (ll ans : pred) {
            for ans in pred {
                var r: [ll] = []; var m: [ll] = []
//                for (ll f : factor_inf) {
                for f in factor_inf {
                    r.append(ans % f);
                    m.append(f);
                }
                let res = crt(r, m);
                XCTAssertEqual(ans % INF, res.first);
                XCTAssertEqual(INF, res.second);
            }
        }
        let factor_infn1 = ([2, 3, 715827883, 2147483647] as [ll]).permutations();
//        do {
        for factor_infn1 in factor_infn1 {
            //            for (ll ans : pred) {
            for ans in pred {
                var r: [ll] = []; var m: [ll] = []
                //                for (ll f : factor_infn1) {
                for f in factor_infn1 {
                    r.append(ans % f);
                    m.append(f);
                }
                let res = crt(r, m);
                XCTAssertEqual(ans % (INF - 1), res.first);
                XCTAssertEqual(INF - 1, res.second);
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
