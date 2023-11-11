//
//  convolutionTests.swift
//  
//
//  Created by narumij on 2023/11/12.
//

import XCTest
@testable import atcoder

fileprivate typealias uint = CUnsignedInt;
fileprivate typealias ll = CLongLong;
fileprivate typealias ull = CUnsignedLongLong;

//template <class mint, internal::is_static_modint_t<mint>* = nullptr>
func conv_naive<mint: modint_protocol>(_ a: [mint],_ b: [mint]) -> [mint] {
    let n = a.count, m = b.count;
    var c = [mint](repeating: 0, count: n + m - 1);
//    for (int i = 0; i < n; i++) {
    for i in 0..<n {
//        for (int j = 0; j < m; j++) {
        for j in 0..<m {
            c[i + j] += a[i] * b[j];
        }
    }
    return c;
}


final class convolutionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEmpty() throws {
        /*
        XCTAssertEqual([] as [CInt],
                  convolution([] as [CInt], [] as [CInt]));
        XCTAssertEqual([] as [CInt],
                  convolution([] as [CInt], [1, 2]));
        XCTAssertEqual([] as [CInt],
                  convolution([1, 2], [] as [CInt]));
        XCTAssertEqual([] as [CInt],
                  convolution([1], [] as [CInt]));
        XCTAssertEqual([] as [ll],
                  convolution([] as [ll], [] as [ll]));
        XCTAssertEqual([] as [ll],
                  convolution([] as [ll], [1, 2]));
         */

        XCTAssertEqual([] as [dynamic_modint],
                  convolution([] as [dynamic_modint],
                              [] as [dynamic_modint]));
        XCTAssertEqual([] as [dynamic_modint],
                  convolution([] as [dynamic_modint],
                              [1, 2]));
    }
    
    func testMid() throws {
        // std::mt19937 mt;
        let n = 1234, m = 2345;
        typealias mint = dynamic_modint
        mint.set_mod(998244353)
        var a = [mint](repeating: 0, count: n); var b = [mint](repeating: 0, count: m);
        
//        for (int i = 0; i < n; i++) {
        for i in 0..<n {
            a[i] = mint(CInt.random(in: 0...CInt.max));
        }
//        for (int i = 0; i < m; i++) {
        for i in 0..<m {
            b[i] = mint(CInt.random(in: 0...CInt.max));
        }
        XCTAssertEqual(conv_naive(a, b), convolution(a, b));
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
