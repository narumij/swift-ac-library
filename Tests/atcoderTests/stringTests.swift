//
//  stringTests.swift
//  
//
//  Created by narumij on 2023/11/11.
//

import XCTest
@testable import atcoder

func sa_naive(_ s: [Int]) -> [Int] {
    let n = s.count;
    var sa = [Int](repeating: 0, count: n);
    sa = (0..<n).map{$0}
    sa.sort { l, r in
        return zip(s[(s.startIndex + l)..<s.endIndex],
                   s[(s.startIndex + r)..<s.endIndex]).allSatisfy{ $0 < $1 };
    };
    return sa;
}

func lcp_naive(_ s: [Int],_ sa: [Int]) -> [Int] {
    let n = s.count;
    assert((n != 0));
    var lcp = [Int](repeating: 0, count: n - 1);
//    for (int i = 0; i < n - 1; i++) {
    for i in 0..<(n - 1) {
        let l = sa[i], r = sa[i + 1];
        while (l + lcp[i] < n && r + lcp[i] < n && s[l + lcp[i]] == s[r + lcp[i]]) { lcp[i] += 1; }
    }
    return lcp;
}

final class stringTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEmpty() throws {
        XCTAssertEqual([], suffix_array(""));
        XCTAssertEqual([], suffix_array([Int]()));

        XCTAssertEqual([], z_algorithm(""));
        XCTAssertEqual([], z_algorithm([Int]()));
    }
    
    func testSALCPNaive() throws {
//        for (int n = 1; n <= 5; n++) {
        for n in 1..<=5 {
            var m = 1;
//            for (int i = 0; i < n; i++) m *= 4;
            for i in 0..<n { m *= 4 }
//            for (int f = 0; f < m; f++) {
            for f in 0..<m {
                var s = [Int](repeating: 0, count: n);
                var g = f;
                var max_c = 0;
//                for (int i = 0; i < n; i++) {
                for i in 0..<n {
                    s[i] = g % 4;
                    max_c = max(max_c, s[i]);
                    g /= 4;
                }
                let sa = sa_naive(s);
                XCTAssertEqual(sa, suffix_array(s));
                XCTAssertEqual(sa, suffix_array(s, max_c));
                XCTAssertEqual(lcp_naive(s, sa), lcp_array(s, sa));
            }
        }
//        for (int n = 1; n <= 10; n++) {
        for n in 1..<=10 {
            var m = 1;
//            for (int i = 0; i < n; i++) m *= 2;
            for _ in 0..<n { m *= 2 }
//            for (int f = 0; f < m; f++) {
            for f in 0..<m {
                var s = [Int](repeating: 0, count: n);
                var g = f;
                var max_c = 0;
//                for (int i = 0; i < n; i++) {
                for i in 0..<n {
                    s[i] = g % 2;
                    max_c = max(max_c, s[i]);
                    g /= 2;
                }
                let sa = sa_naive(s);
                XCTAssertEqual(sa, suffix_array(s));
                XCTAssertEqual(sa, suffix_array(s, max_c));
                XCTAssertEqual(lcp_naive(s, sa), lcp_array(s, sa));
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
