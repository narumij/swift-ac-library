//
//  stringTests.swift
//  
//
//  Created by narumij on 2023/11/11.
//

import XCTest
@testable import atcoder

#if false
// TESTコードの挙動が再現できない。
func sa_naive(_ s: [Int]) -> [Int] {
    let n = s.count;
    var sa = [Int](repeating: 0, count: n);
    sa = (0..<n).map{$0}
    sa.sort { l, r in
        return zip(s[(s.startIndex + l)..<s.endIndex],s[(s.startIndex + r)..<s.endIndex]).allSatisfy{ $0 < $1 }
        || s[(s.startIndex + l)..<s.endIndex].count == s[(s.startIndex + r)..<s.endIndex].count
    };
    return sa;
}
#else
func sa_naive(_ s: [Int]) -> [Int] {
    let n = s.count;
    var sa = [Int](repeating: 0, count: n);
    sa = (0..<n).map{ $0 }
    sa.sort(by: { l, r in
        var l = l, r = r
        if (l == r) { return false; }
        while (l < n && r < n) {
            if (s[l] != s[r]) { return s[l] < s[r]; }
            l += 1;
            r += 1;
        }
        return l == n;
    });
    return sa;
}
#endif

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

func z_naive(_ s: [Int]) -> [Int] {
    let n = s.count;
    var z = [Int](repeating: 0, count: n);
//    for (int i = 0; i < n; i++) {
    for i in 0..<n {
        while (i + z[i] < n && s[z[i]] == s[i + z[i]]) { z[i] += 1; }
    }
    return z;
}

final class stringTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSaNaive() throws {
        let s = [0,0,0,0,0]
        let saResult: [Int] = [4, 3, 2, 1, 0]
        let lcpResult: [Int] = [1, 2, 3, 4]
        XCTAssertEqual(saResult, sa_naive(s))
        XCTAssertEqual(lcpResult, lcp_naive(s, saResult))
    }

    func testSaNaive2() throws {
        let s = [1, 2, 3, 4, 5]
        let saResult: [Int] = [0, 1, 2, 3, 4]
        let lcpResult: [Int] = [0, 0, 0, 0]
        XCTAssertEqual(saResult, sa_naive(s))
        XCTAssertEqual(lcpResult, lcp_naive(s, saResult))
    }
    
    func testSaNaive3() throws {
        let s = [3, 3, 2, 1, 0]
        let saResult: [Int] = [4, 3, 2, 1, 0]
        let lcpResult: [Int] = [0, 0, 0, 1]
        XCTAssertEqual(saResult, sa_naive(s))
        XCTAssertEqual(lcpResult, lcp_naive(s, saResult))
    }


    func testEmpty() throws {
        
        // throw XCTSkip()

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
    
    func testInternalSANaiveNaive() throws {
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

                let sa = `internal`.sa_naive(s);
                XCTAssertEqual(sa_naive(s), sa);
            }
        }
//        for (int n = 1; n <= 10; n++) {
        for n in 1..<=10 {
            var m = 1;
//            for (int i = 0; i < n; i++) m *= 2;
            for i in 0..<n { m *= 2 }
//            for (int f = 0; f < m; f++) {
            for f in 0..<m {
                var s = [Int](repeating: 0, count: n);
                var g = f;
//                for (int i = 0; i < n; i++) {
                for i in 0..<n {
                    s[i] = g % 2;
                    g /= 2;
                }

                let sa = `internal`.sa_naive(s);
                XCTAssertEqual(sa_naive(s), sa);
            }
        }
    }
    
    func testInternalSADoublingNaive() throws {
//        for (int n = 1; n <= 5; n++) {
        for n in 1..<=5 {
            var m = 1;
//            for (int i = 0; i < n; i++) m *= 4;
            for i in 0..<n { m *= 4 }
//            for (int f = 0; f < m; f++) {
            for f in 0..<m {
                var s = [Int](repeating: 0, count: n);
                var g = f;
//                for (int i = 0; i < n; i++) {
                for i in 0..<n {
                    s[i] = g % 4;
                    g /= 4;
                }

                let sa = `internal`.sa_doubling(s);
                XCTAssertEqual(sa_naive(s), sa);
            }
        }
//        for (int n = 1; n <= 10; n++) {
        for n in 1..<=10 {
            var m = 1;
//            for (int i = 0; i < n; i++) m *= 2;
            for i in 0..<n { m *= 2 }
//            for (int f = 0; f < m; f++) {
            for f in 0..<m {
                var s = [Int](repeating: 0, count: n);
                var g = f;
                for i in 0..<n {
                    s[i] = g % 2;
                    g /= 2;
                }

                let sa = `internal`.sa_doubling(s);
                XCTAssertEqual(sa_naive(s), sa);
            }
        }
    }
    
    func testInternalSAISNaive() throws {
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
                
                let sa = `internal`.sa_is(s, max_c, -1, -1);
                XCTAssertEqual(sa_naive(s), sa);
            }
        }
//        for (int n = 1; n <= 10; n++) {
        for n in 1..<=10 {
            var m = 1;
//            for (int i = 0; i < n; i++) m *= 2;
            for i in 0..<n { m *= 2 }
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

                let sa = `internal`.sa_is(s, max_c, -1, -1);
                XCTAssertEqual(sa_naive(s), sa);
            }
        }
    }
    
    func testSAAllATest() throws {
//        for (int n = 1; n <= 100; n++) {
        for n in 1..<=100 {
            let s = [Int](repeating: 10, count: n);
            XCTAssertEqual(sa_naive(s), suffix_array(s));
            XCTAssertEqual(sa_naive(s), suffix_array(s, 10));
            XCTAssertEqual(sa_naive(s), suffix_array(s, 12));
        }
    }
    
    func testSAAllABTest() throws {
//        for (int n = 1; n <= 100; n++) {
        for n in 1..<=100 {
            var s = [Int](repeating: 0, count: n);
//           for (int i = 0; i < n; i++) s[i] = (i % 2);
            for i in 0..<n { s[i] = (i % 2); }
            XCTAssertEqual(sa_naive(s), suffix_array(s));
            XCTAssertEqual(sa_naive(s), suffix_array(s, 3));
        }
//        for (int n = 1; n <= 100; n++) {
        for n in 1..<=100 {
            var s = [Int](repeating: 0, count: n);
//            for (int i = 0; i < n; i++) s[i] = 1 - (i % 2);
            for i in 0..<n { s[i] = 1 - (i % 2); }
            XCTAssertEqual(sa_naive(s), suffix_array(s));
            XCTAssertEqual(sa_naive(s), suffix_array(s, 3));
        }
    }
    
    func testSA() throws {
        let s = "missisippi";

        let sa = suffix_array(s);

        let answer = [
            "i",           // 9
            "ippi",        // 6
            "isippi",      // 4
            "issisippi",   // 1
            "missisippi",  // 0
            "pi",          // 8
            "ppi",         // 7
            "sippi",       // 5
            "sisippi",     // 3
            "ssisippi",    // 2
        ];

        XCTAssertEqual(answer.count, sa.count);

//        for (int i = 0; i < int(sa.size()); i++) {
        for i in 0..<sa.count {
//            ASSERT_EQ(answer[i], s.substr(sa[i]));
            XCTAssertEqual(answer[i], String(s.suffix(from: s.index(s.startIndex, offsetBy: sa[i]))));
        }
    }
    
    func testSASingle() throws {
        XCTAssertEqual([0], suffix_array([0]));
        XCTAssertEqual([0], suffix_array([-1]));
        XCTAssertEqual([0], suffix_array([1]));
        XCTAssertEqual([0], suffix_array([Int32.min]));
        XCTAssertEqual([0], suffix_array([Int32.max]));
    }
    
    func testLCP() throws {
        var s = "aab";
        var sa = suffix_array(s);
        XCTAssertEqual([0, 1, 2], sa);
        var lcp = lcp_array(s, sa);
        XCTAssertEqual([1, 0], lcp);

        XCTAssertEqual(lcp, lcp_array([0, 0, 1], sa));
        XCTAssertEqual(lcp, lcp_array([-100, -100, 100], sa));
        XCTAssertEqual(lcp,
                       lcp_array([Int32.min,Int32.min,Int32.max], sa));

        XCTAssertEqual(lcp,
                       lcp_array([Int64.min,Int64.min,Int64.max], sa));
        
        XCTAssertEqual(lcp,
                       lcp_array([UInt32.min,UInt32.min,UInt32.max], sa));

        XCTAssertEqual(lcp,
                       lcp_array([UInt64.min,UInt64.min,UInt64.max], sa));
    }
    
    func testZAlgo() throws {
        let s = "abab";
        let z = z_algorithm(s);
        XCTAssertEqual([4, 0, 2, 0], z);
        XCTAssertEqual([4, 0, 2, 0],
                  z_algorithm([1, 10, 1, 10]));
        XCTAssertEqual(z_naive([0, 0, 0, 0, 0, 0, 0]), z_algorithm([0, 0, 0, 0, 0, 0, 0]));
    }

    func testZNaive() throws {
//        for (int n = 1; n <= 6; n++) {
        for n in 1..<=6 {
            var m = 1;
//            for (int i = 0; i < n; i++) m *= 4;
            for i in 0..<n { m *= 4 }
//            for (int f = 0; f < m; f++) {
            for f in 0..<m {
                var s = [Int](repeating: 0, count: n)
                var g = f;
//                for (int i = 0; i < n; i++) {
                for i in 0..<n {
                    s[i] = g % 4;
                    g /= 4;
                }
                XCTAssertEqual(z_naive(s), z_algorithm(s));
            }
        }
//        for (int n = 1; n <= 10; n++) {
        for n in 1..<=10 {
            var m = 1;
//            for (int i = 0; i < n; i++) m *= 2;
            for i in 0..<n { m *= 2 }
//            for (int f = 0; f < m; f++) {
            for f in 0..<m {
                var s = [Int](repeating: 0, count: n)
                var g = f;
//                for (int i = 0; i < n; i++) {
                for i in 0..<n {
                    s[i] = g % 2;
                    g /= 2;
                }
                XCTAssertEqual(z_naive(s), z_algorithm(s));
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
