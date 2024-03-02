import XCTest
import AtCoder

fileprivate let op_ss: LazySegTree<Int,Int>.Op = max
fileprivate let op_ts: LazySegTree<Int,Int>.Mapping = (+)
fileprivate let op_tt: LazySegTree<Int,Int>.Composition = (+)
fileprivate let e_s: LazySegTree<Int,Int>.S = -1_000_000_000
fileprivate let e_t: LazySegTree<Int,Int>.F = 0
fileprivate typealias S = Int
fileprivate typealias F = Int

protocol LazySegtreeMonoid {
    associatedtype S
    static var op: (S,S) -> S { get }
    static var e: S { get }
    associatedtype F
    static var mapping: (F,S) -> S { get }
    static var composition: (F,F) -> F { get }
    static var id: F { get }
}

extension LazySegTree {
    init<T>(_ monoid: T) where T: LazySegtreeMonoid, S == T.S, F == T.F {
        self.init(op: T.op, e: T.e, mapping: T.mapping, composition: T.composition, id: T.id)
    }
    init<T>(_ monoid: T,_ n: Int) where T: LazySegtreeMonoid, S == T.S, F == T.F {
        self.init(op: T.op, e: T.e, mapping: T.mapping, composition: T.composition, id: T.id, count: n)
    }
    init<T>(_ monoid: T,_ v: [S]) where T: LazySegtreeMonoid, S == T.S, F == T.F {
        self.init(op: T.op, e: T.e, mapping: T.mapping, composition: T.composition, id: T.id, v)
    }
}

fileprivate extension LazySegTree where S == AtCoderTests.S, F == AtCoderTests.F {
    init() {
        self.init(op: max,
                  e: -1_000_000_000,
                  mapping: +,
                  composition: +,
                  id: 0)
    }
    init(_ n: Int) {
        self.init(op: max,
                  e: -1_000_000_000,
                  mapping: +,
                  composition: +,
                  id: 0,
                  count: n )
    }
    init(_ v: [S]) {
        self.init(op: max,
                  e: -1_000_000_000,
                  mapping: +,
                  composition: +,
                  id: 0,
                  v )
    }
}

fileprivate typealias starry_seg = LazySegTree<S,F>

final class lazySegtreeTests: XCTestCase {

    func test0() throws {
        do {
            var s = starry_seg(0);
            XCTAssertEqual(-1_000_000_000, s.all_prod());
        }
        do {
            var s = starry_seg();
            XCTAssertEqual(-1_000_000_000, s.all_prod());
        }
        do {
            var s = starry_seg(10);
            XCTAssertEqual(-1_000_000_000, s.all_prod());
        }
    }
    
#if false
    func testAssign() throws {
        throw XCTSkip("代入のオーバーロードはSwiftにはない。")
        var seg0 = starry_seg();
        XCTAssertNoThrow(seg0 = starry_seg(10));
    }
#endif

#if false
    func testInvalid() throws {
        
        throw XCTSkip("Swift Packageでは実施不可")
        XCTAssertThrowsError(starry_seg(-1))
        
        var s = starry_seg(10)
        
        XCTAssertThrowsError(s.get(-1))
        XCTAssertThrowsError(s.get(10))
        
        XCTAssertThrowsError(s.prod(-1,-1))
        
        XCTAssertThrowsError(s.prod(3,2))
        XCTAssertThrowsError(s.prod(0,11))
        XCTAssertThrowsError(s.prod(-1,11))
    }
#endif

    func testNaiveProd() throws {
        for n in 0...50 {
            var seg = starry_seg(n);
            var p = [Int](repeating: 0, count: n)
            for i in 0..<n {
                p[i] = (i * i + 100) % 31;
                seg.set(i, p[i]);
            }
            for l in 0..<=n {
                for r in l..<=n {
                    var e = -1_000_000_000;
                    for i in l..<r {
                        e = max(e, p[i]);
                    }
                    XCTAssertEqual(e, seg.prod(l, r));
                }
            }
        }
    }
    
    func testUsage() throws {
        
        var seg = starry_seg([Int](repeating: 0, count: 10));
        
        XCTAssertEqual(0, seg.all_prod());
        seg.apply(0, 3, 5);
        XCTAssertEqual(5, seg.all_prod());
        seg.apply(2, -10);
        XCTAssertEqual(-5, seg.prod(2, 3));
        XCTAssertEqual(0, seg.prod(2, 4));
    }
    
    // Actionsのtestを通過できない。
    func testString() throws {
        
        do {
            _ = LazySegTree(op: +, e: "$", mapping: +, composition: +, id: "")
        }
        do {
            _ = LazySegTree(op: +, e: "$", mapping: +, composition: +, id: "", count: 12)
        }
    }

}
