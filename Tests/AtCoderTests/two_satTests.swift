import XCTest
@testable import AtCoder

fileprivate typealias ll = CLongLong;
fileprivate typealias ull = CUnsignedLongLong;

final class two_satTests: XCTestCase {

    typealias two_sat = TwoSAT

    func testEmpty() throws {
        var ts0 = two_sat();
        XCTAssertTrue(ts0.satisfiable());
        XCTAssertEqual([], ts0.answer());
        var ts1 = two_sat(0);
        XCTAssertTrue(ts1.satisfiable());
        XCTAssertEqual([], ts1.answer());
    }
    
    func testOne() throws {
        do {
            var ts = two_sat(1);
            ts.add_clause(0, true, 0, true);
            ts.add_clause(0, false, 0, false);
            XCTAssertFalse(ts.satisfiable());
        }
        do {
            var ts = two_sat(1);
            ts.add_clause(0, true, 0, true);
            XCTAssertTrue(ts.satisfiable());
            XCTAssertEqual([true], ts.answer());
        }
        do {
            var ts = two_sat(1);
            ts.add_clause(0, false, 0, false);
            XCTAssertTrue(ts.satisfiable());
            XCTAssertEqual([false], ts.answer());
        }
    }
    
#if false
    func testAssign() throws {
        throw XCTSkip("代入のオーバーロードはSwiftにはない。")
        /*
         two_sat ts;
         ts = two_sat(10);
         */
    }
#endif
    
    func testPerformanceStressOK() throws {
        // This is an example of a performance test case.
        self.measure {
            for _ /* phase */ in 0..<10000 {
                let n = randint(1, 20);
                let m = randint(1, 100);
                var expect = [Bool](repeating: false, count: n);
                for i in 0..<n {
                    expect[i] = randbool();
                }
                var ts = two_sat(n);
                var xs = [Int](repeating: 0, count: m), ys = [Int](repeating: 0, count: m), types = [Int](repeating: 0, count: m);
                for i in 0..<m {
                    let x = randint(0, n - 1);
                    let y = randint(0, n - 1);
                    let type = randint(0, 2);
                    xs[i] = x;
                    ys[i] = y;
                    types[i] = type;
                    if (type == 0) {
                        ts.add_clause(x, expect[x], y, expect[y]);
                    } else if (type == 1) {
                        ts.add_clause(x, !expect[x], y, expect[y]);
                    } else {
                        ts.add_clause(x, expect[x], y, !expect[y]);
                    }
                }
                XCTAssertTrue(ts.satisfiable());
                let actual = ts.answer();
                for i in 0..<m {
                    let x = xs[i], y = ys[i], type = types[i];
                    if (type == 0) {
                        XCTAssertTrue(actual[x] == expect[x] || actual[y] == expect[y]);
                    } else if (type == 1) {
                        XCTAssertTrue(actual[x] != expect[x] || actual[y] == expect[y]);
                    } else {
                        XCTAssertTrue(actual[x] == expect[x] || actual[y] != expect[y]);
                    }
                }
            }
        }
    }

}
