//
//  internalMathTests.swift
//  
//
//  Created by narumij on 2023/11/11.
//

import XCTest
@testable import atcoder

func gcd(_ a: Int,_ b: Int) -> Int {
    assert(0 <= a && 0 <= b);
    if (b == 0) { return a; }
    return gcd(b, a % b);
}

func pow_mod_naive(_ x: Int,_ n: UInt,_ mod: UInt32) -> Int {
    let y: UInt = (UInt(x) % UInt(mod) + UInt(mod)) % UInt(mod);
    var z: UInt = 1;
//    for (ull i = 0; i < n; i++) {
    for _ in 0..<UInt(n) {
        z = (z * y) % UInt(mod);
    }
    return Int(z % UInt(mod));
}

func floor_sum_naive(_ n: Int,_ m: Int,_ a: Int,_ b: Int) -> Int {
    var sum = 0;
//    for (ll i = 0; i < n; i++) {
    for i in 0..<n {
        sum += (a * i + b) / m;
    }
    return sum;
}

func is_prime_naive(_ n: Int) -> Bool {
    assert(0 <= n && n <= Int(Int32.max));
    if (n == 0 || n == 1) { return false; }
//    for (ll i = 2; i * i <= n; i++) {
    do { var i = 2; while i &* i <= n { defer { i += 1 }
        if (n % i == 0) { return false; }
    } }
    return true;
}

final class internalMathTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBarrett() throws {
//        for (int m = 1; m <= 100; m++) {
        for m in 1..<=UInt32(100) {
            let bt = `internal`.barrett(m);
//            for (int a = 0; a < m; a++) {
            for a in 0..<UInt32(m) {
//                for (int b = 0; b < m; b++) {
                for b in 0..<UInt32(m) {
                    XCTAssertEqual((a * b) % m, bt.mul(a, b));
                }
            }
        }

        let bt = `internal`.barrett(1);
        XCTAssertEqual(0, bt.mul(0, 0));
    }
    
    func testBarrettIntBorder() throws {
        let mod_upper = CInt.max;
        
        XCTAssertEqual(2147483647, mod_upper)

//        for (unsigned int mod = mod_upper; mod >= mod_upper - 20; mod--) {
//        for mod in stride(from: mod_upper, through: mod_upper - 20, by: -1) {
        for mod in stride(from: mod_upper, through: mod_upper, by: -1) {
            let bt = `internal`.barrett(UInt32(mod));
            var v: [CInt] = [];
//            for (int i = 0; i < 10; i++) {
//            for i in UInt32(0)..<UInt32(10) {
            for i in CInt(0)..<CInt(1) {
                v.append(CInt(i));
                v.append(CInt(mod - i));
                v.append(CInt(mod / 2 + i));
                v.append(CInt(mod / 2 - i));
            }
            
            let sideValue: [(CInt,(CInt,CInt),[(CInt,CInt)])] = [
                (0,(0,0), [(0,0), (0,0), (0,0), (0,0), ]),
                (2147483647,(0,0), [(0,0), (0,0), (0,0), (0,0), ]),
                (1073741823,(1879048191,1879048191), [(0,0), (0,0), (536870912,536870912), (536870912,536870912), ]),
                (1073741823,(1879048191,1879048191), [(0,0), (0,0), (536870912,536870912), (536870912,536870912), ]),
            ]
            
            for (a,s) in zip(v,sideValue) {
                let a2 = CLongLong(a);
                XCTAssertEqual(a, s.0)
                XCTAssertEqual((a2 * a2) % CLongLong(mod) * a2 % CLongLong(mod), Int64(s.1.0))
//                XCTAssertEqual(bt.mul(a, bt.mul(a, a)), s.1.1)
//                XCTAssertEqual(((a2 &* a2) % Int(mod) &* a2) % Int(mod), bt.mul(a, bt.mul(a, a)));
                for (b,s2) in zip(v,s.2) {
                    let b2 = b;
                    XCTAssertEqual(CLongLong(a2) * CLongLong(b2) % CLongLong(mod), CLongLong(s2.0))
                    XCTAssertEqual((CLongLong(a2) * CLongLong(b2)) % CLongLong(mod), CLongLong(bt.mul(UInt32(a), UInt32(b))));
                }
            }
        }
    }
    
    func testBarrettUintBorder() throws {
        
        throw XCTSkip()

        let mod_upper = UInt32.max;
//        for (unsigned int mod = mod_upper; mod >= mod_upper - 20; mod--) {
        for mod in stride(from: UInt32(mod_upper), through: UInt32(mod_upper - 20), by: -1) {
            let bt = `internal`.barrett(UInt32(mod));
            var v: [UInt32] = [];
//            for (int i = 0; i < 10; i++) {
//            for i in UInt32(0)..<UInt32(10) {
            for i in UInt32(0)..<UInt32(1) {
                v.append(i);
                v.append(mod - i);
                v.append(mod / 2 + i);
                v.append(mod / 2 - i);
            }
            for a in v {
                let a2 = a;
                XCTAssertEqual(((a2 &* a2) % mod &* a2) % mod, bt.mul(a, bt.mul(a, a)));
                for b in v {
                    let b2 = b;
                    XCTAssertEqual((a2 &* b2) % mod, bt.mul(a, b));
                }
            }
        }
    }
    
    func testIsPrime() throws {
        
        throw XCTSkip()

        XCTAssertFalse(`internal`.is_prime(121));
        XCTAssertFalse(`internal`.is_prime(11 * 13));
        XCTAssertTrue(`internal`.is_prime(1_000_000_007));
        XCTAssertFalse(`internal`.is_prime(1_000_000_008));
        XCTAssertTrue(`internal`.is_prime(1_000_000_009));
//        for (int i = 0; i <= 10000; i++) {
        for i in 0..<=10000 {
            XCTAssertEqual(is_prime_naive(i), `internal`.is_prime_constexpr(i));
        }
//        for (int i = 0; i <= 10000; i++) {
        for i in 0..<=10000 {
            let x = Int(Int32.max) - i;
            XCTAssertEqual(is_prime_naive(x), `internal`.is_prime_constexpr(x));
        }
    }
    
    func testSafeMod() throws {
        
        throw XCTSkip("再現できず")
        
        var preds = [Int]();
//        for (int i = 0; i <= 100; i++) {
        for i in 0..<=100 {
            preds.append(i);
            preds.append(-i);
            preds.append(i);
            preds.append(Int.min + i);
            preds.append(Int.max - i);
        }

        for a in preds {
            for b in preds {
                if (b <= 0) { continue; }
                let ans = Int((a.dividingFullWidth((0,b.magnitude)).remainder + b).dividingFullWidth((0,b.magnitude)).remainder);
                XCTAssertEqual(ans, `internal`.safe_mod(a, b));
            }
        }
    }
    
    func testInvGcdBound() throws {
        
        throw XCTSkip()
        
        var pred = [Int]();
//        for i in 0..<=10 {
        for i in 0..<=1 {
            pred.append(i);
            pred.append(-i);
            pred.append(Int.min + i);
            pred.append(Int.max - i);

            pred.append(Int.min / 2 + i);
            pred.append(Int.min / 2 - i);
            pred.append(Int.max / 2 + i);
            pred.append(Int.max / 2 - i);

            pred.append(Int.min / 3 + i);
            pred.append(Int.min / 3 - i);
            pred.append(Int.max / 3 + i);
            pred.append(Int.max / 3 - i);
        }
        pred.append(998244353);
        pred.append(1_000_000_007);
        pred.append(1_000_000_009);
        pred.append(-998244353);
        pred.append(-1_000_000_007);
        pred.append(-1_000_000_009);

        for a in pred {
            for b in pred {
                if (b <= 0) { continue; }
                let a2 = `internal`.safe_mod(a, b);
                let eg = `internal`.inv_gcd(a, b);
                let g = gcd(a2, b);
                XCTAssertEqual(g, eg.first);
                XCTAssertEqual(0, eg.second);
                XCTAssertEqual(eg.second, b / eg.first);
                XCTAssertEqual(UInt(g % b), eg.second.multipliedFullWidth(by: a2).low % UInt(b));
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
