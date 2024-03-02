import XCTest
@testable import AtCoder
import Algorithms

// time manager
fileprivate struct time_manager {
    var v: [Int]
    init(_ n: Int) {
        v = [Int](repeating: -1, count: n)
    }
    mutating func action(_ l: Int,_ r: Int,_ time: Int) {
        for i in l..<r {
            v[i] = time
        }
    }
    func prod(_ l: Int,_ r: Int) -> Int {
        var res = -1
        for i in l..<r {
            res = max(res, v[i])
        }
        return res
    }
}

fileprivate struct S {
    internal init(_ l: Int,_ r: Int,_ time: Int) {
        self.l = l
        self.r = r
        self.time = time
    }
    var l, r, time: Int;
};
fileprivate struct T {
    internal init(_ new_time: Int) {
        self.new_time = new_time
    }
    var new_time: Int;
};
fileprivate func op_ss(_ l: S,_ r: S) -> S {
    if (l.l == -1) { return r; }
    if (r.l == -1) { return l; }
    assert(l.r == r.l);
    return S(l.l, r.r, max(l.time, r.time));
}
fileprivate func op_ts(_ l: T,_ r: S) -> S {
    if (l.new_time == -1) { return r; }
    assert(r.time < l.new_time);
    return S(r.l, r.r, l.new_time);
}
fileprivate func op_tt(_ l: T,_ r: T) -> T {
    if (l.new_time == -1) { return r; }
    if (r.new_time == -1) { return l; }
    assert(l.new_time > r.new_time);
    return l;
}
fileprivate func e_s() -> S { return S(-1, -1, -1); }
fileprivate func e_t() -> T { return T(-1); }

fileprivate extension LazySegTree where S == AtCoderTests.S, F == AtCoderTests.T {
    init() {
        self.init(op: op_ss,
                  e: e_s(),
                  mapping: op_ts,
                  composition: op_tt,
                  id: e_t())
    }
    init(_ n: Int) {
        self.init(op: op_ss,
                  e: e_s(),
                  mapping: op_ts,
                  composition: op_tt,
                  id: e_t(),
                  count: n )
    }
    init(_ v: [S]) {
        self.init(op: op_ss,
                  e: e_s(),
                  mapping: op_ts,
                  composition: op_tt,
                  id: e_t(),
                  v )
    }
}

fileprivate typealias seg = LazySegTree<S,T>


final class lazySegtreeStressTests: XCTestCase {
    
#if false
    let (naive,right,left) = (3000,1000,1000)
#else
    let (naive,right,left) = (300,100,100)
#endif

    func testNaive() throws {
        self.measure {
            for n in 1..<=30 {
                for _ in 0..<10 {
                    var seg0 = seg(n)
                    var tm = time_manager(n)
                    for i in 0..<n {
                        seg0.set(i, S(i, i + 1, -1))
                    }
                    var now = 0;
                    for _ in 0..<naive {
                        let ty = randint(0, 3)
                        var l, r: Int
                        (l, r) = randpair(0, n)
                        if (ty == 0) {
                            let res = seg0.prod(l, r)
                            XCTAssertEqual(l, res.l, "test 0")
                            XCTAssertEqual(r, res.r, "test 1")
                            XCTAssertEqual(tm.prod(l, r), res.time, "test 2")
                        } else if (ty == 1) {
                            let res = seg0.get(l)
                            XCTAssertEqual(l, res.l, "test 3")
                            XCTAssertEqual(l + 1, res.r, "test 4")
                            XCTAssertEqual(tm.prod(l, l + 1), res.time, "test 5")
                        } else if (ty == 2) {
                            now += 1
                            seg0.apply(l, r, T(now))
                            tm.action(l, r, now)
                        } else if (ty == 3) {
                            now += 1
                            seg0.apply(l, T(now))
                            tm.action(l, l + 1, now)
                        } else {
                            assert(false)
                        }
                    }
                }
            }
        }
    }

    func testMaxRight() throws {
        self.measure {
            for n in 1..<=30 {
                for _ in 0..<10 {
                    var seg0 = seg(n)
                    var tm = time_manager(n)
                    for i in 0..<n {
                        seg0.set(i, S(i, i + 1, -1))
                    }
                    var now = 0
                    for _ in 0..<right {
                        let ty = randint(0, 2)
                        var l, r: Int
                        (l, r) = randpair(0, n)
                        if (ty == 0) {
                            XCTAssertEqual(r, seg0.max_right(l) { s in
                                if (s.l == -1) { return true }
                                assert(s.l == l)
                                assert(s.time == tm.prod(l, s.r))
                                return s.r <= r
                            });
                        } else {
                            now += 1
                            seg0.apply(l, r, T(now))
                            tm.action(l, r, now)
                        }
                    }
                }
            }
        }
    }

    func testMinLeft() throws {
        self.measure {
            for n in 1..<=30 {
                for _ in 0..<10 {
                    var seg0 = seg(n)
                    var tm = time_manager(n)
                    for i in 0..<n {
                        seg0.set(i, S(i, i + 1, -1))
                    }
                    var now = 0
                    for _ in 0..<left {
                        let ty = randint(0, 2)
                        var l, r: Int
                        (l, r) = randpair(0, n)
                        if (ty == 0) {
                            XCTAssertEqual(l, seg0.min_left(r) { s in
                                if (s.l == -1) { return true }
                                assert(s.r == r)
                                assert(s.time == tm.prod(s.l, r))
                                return l <= s.l
                            });
                        } else {
                            now += 1
                            seg0.apply(l, r, T(now))
                            tm.action(l, r, now)
                        }
                    }
                }
            }
        }
    }
}
