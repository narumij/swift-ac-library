import XCTest
@testable import atcoder
import Algorithms

// time manager
struct time_manager {
    var v: [Int]
    init(_ n: Int) {
        v = [Int](repeating: -1, count: n)
    }
    mutating func action(_ l: Int,_ r: Int,_ time: Int) {
        // for (int i = l; i < r; i++) {
        for i in l..<r {
            v[i] = time;
        }
    }
    func prod(_ l: Int,_ r: Int) -> Int {
        var res = -1;
        // for (int i = l; i < r; i++) {
        for i in l..<r {
            res = max(res, v[i]);
        }
        return res;
    }
};

enum stress_fixture {
    struct S {
        internal init(_ l: Int,_ r: Int,_ time: Int) {
            self.l = l
            self.r = r
            self.time = time
        }
        var l, r, time: Int;
    };
    struct T {
        internal init(_ new_time: Int) {
            self.new_time = new_time
        }
        var new_time: Int;
    };
    static func op_ss(_ l: S,_ r: S) -> S {
        if (l.l == -1) { return r; }
        if (r.l == -1) { return l; }
        assert(l.r == r.l);
        return S(l.l, r.r, max(l.time, r.time));
    }
    static func op_ts(_ l: T,_ r: S) -> S {
        if (l.new_time == -1) { return r; }
        assert(r.time < l.new_time);
        return S(r.l, r.r, l.new_time);
    }
    
    static func op_tt(_ l: T,_ r: T) -> T {
        if (l.new_time == -1) { return r; }
        if (r.new_time == -1) { return l; }
        assert(l.new_time > r.new_time);
        return l;
    }
    
    static func e_s() -> S { return S(-1, -1, -1); }
    
    static func e_t() -> T { return T(-1); }
}

extension stress_fixture: LazySegtreeParameter, SegtreeParameter {
    typealias F = T
    static let op: (S,S) -> S = op_ss
    static let e: S = e_s()
    static let mapping: (F,S) -> S = op_ts
    static let composition: (F,F) -> F = op_tt
    static let `id`: F = e_t()
}

final class LazySegtreeStressTests: XCTestCase {

    typealias seg = lazy_segtree<stress_fixture>;
    typealias S = stress_fixture.S
    typealias T = stress_fixture.T

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNaive() throws {
        // for (int n = 1; n <= 30; n++) {
        for n in 1..<=30 {
            // for (int ph = 0; ph < 10; ph++) {
            for ph in 0..<10 {
                var seg0 = seg(n);
                var tm = time_manager(n);
                // for (int i = 0; i < n; i++) {
                for i in 0..<n {
                    seg0.set(i, S(i, i + 1, -1));
                }
                var now = 0;
                // for (int q = 0; q < 3000; q++) {
                for q in 0..<3000 {
//                    int ty = randint(0, 3);
                    let ty = randint(0, 3);
                    var l, r: Int;
//                    std::tie(l, r) = randpair(0, n);
                    (l, r) = randpair(0, n);
                    if (ty == 0) {
                        let res = seg0.prod(l, r);
//                        XCTAssertEqual(l, res.l, "test 0");
//                        XCTAssertEqual(r, res.r, "test 1");
                        XCTAssertEqual(tm.prod(l, r), res.time, "test 2");
                    } else if (ty == 1) {
                        let res = seg0.get(l);
                        XCTAssertEqual(l, res.l, "test 3");
                        XCTAssertEqual(l + 1, res.r, "test 4");
                        XCTAssertEqual(tm.prod(l, l + 1), res.time, "test 5");
                    } else if (ty == 2) {
                        now += 1;
                        seg0.apply(l, r, T(now));
                        tm.action(l, r, now);
                    } else if (ty == 3) {
                        now += 1;
                        seg0.apply(l, T(now));
                        tm.action(l, l + 1, now);
                    } else {
                        assert(false);
                    }
                }
            }
        }
    }
    
    func testMaxRightTest() throws {
        // for (int n = 1; n <= 30; n++) {
        for n in 1..<=30 {
            // for (int ph = 0; ph < 10; ph++) {
            for ph in 0..<10 {
                var seg0 = seg(n);
                var tm = time_manager(n);
                // for (int i = 0; i < n; i++) {
                for i in 0..<n {
                    seg0.set(i, S(i, i + 1, -1));
                }
                var now = 0;
                // for (int q = 0; q < 1000; q++) {
                for q in 0..<1000 {
                    let ty = randint(0, 2);
                    var l, r: Int;
                    (l, r) = randpair(0, n);
                    if (ty == 0) {
                        XCTAssertEqual(r, seg0.max_right(l) { s in
                            if (s.l == -1) { return true; }
                            assert(s.l == l);
                            assert(s.time == tm.prod(l, s.r));
                            return s.r <= r;
                        });
                    } else {
                        now += 1;
                        seg0.apply(l, r, T(now));
                        tm.action(l, r, now);
                    }
                }
            }
        }
    }
    
    func testMinLeftTest() throws {
        // for (int n = 1; n <= 30; n++) {
        for n in 1..<=30 {
            // for (int ph = 0; ph < 10; ph++) {
            for ph in 0..<10 {
                var seg0 = seg(n);
                var tm = time_manager(n);
                // for (int i = 0; i < n; i++) {
                for i in 0..<n {
                    seg0.set(i, S(i, i + 1, -1));
                }
                var now = 0;
                // for (int q = 0; q < 1000; q++) {
                for q in 0..<1000 {
                    var ty = randint(0, 2);
                    var l, r: Int;
                    (l, r) = randpair(0, n);
                    if (ty == 0) {
                        XCTAssertEqual(l, seg0.min_left(r) { s in
                            if (s.l == -1) { return true; }
                            assert(s.r == r);
                            assert(s.time == tm.prod(s.l, r));
                            return l <= s.l;
                        });
                    } else {
                        now += 1;
                        seg0.apply(l, r, T(now));
                        tm.action(l, r, now);
                    }
                }
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
