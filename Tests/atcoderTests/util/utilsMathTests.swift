//
//  utilsMathTests.swift
//  
//
//  Created by narumij on 2023/11/14.
//

import XCTest
@testable import atcoder

func is_primitive_root_naive(_ m: CInt,_ g: CInt) -> Bool {
    assert(1 <= g && g < m);
    var x: CInt = 1;
//    for (int i = 1; i <= m - 2; i++) {
    for i in 1..<=(m - 2) {
        x = CInt(CLongLong(x)*CLongLong(g) % CLongLong(m));
        // x == n^i
        if (x == 1) { return false; }
    }
    x = CInt(CLongLong(x)*CLongLong(g) % CLongLong(m));
    assert(x == 1);
    return true;
}

final class utilsMathTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFactorsTest() throws {
//        for (int m = 1; m <= 50000; m++) {
        for m in CInt(1)..<=50000 {
            var f = factors(m);
            var m2 = m;
            for x in f {
                XCTAssertEqual(0, m % x);
                while (m2 % x == 0) { m2 /= x; }
            }
            XCTAssertEqual(1, m2);
        }
    }

    func testIsPrimitiveRootTest() throws {
//        for (int m = 2; m <= 500; m++) {
        for m in CInt(2)..<=500 {
            if (!_internal.is_prime_constexpr(m)) { continue; }
//            for (int g = 1; g < m; g++) {
            for g in 1..<m {
                XCTAssertEqual(is_primitive_root_naive(m, g), is_primitive_root(m, g));
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
