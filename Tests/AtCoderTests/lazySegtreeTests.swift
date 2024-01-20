import XCTest
@testable import AtCoder

fileprivate let op_ss: lazy_segtree<Int,Int>.Op = max
fileprivate let op_ts: lazy_segtree<Int,Int>.Mapping = (+)
fileprivate let op_tt: lazy_segtree<Int,Int>.Composition = (+)
fileprivate let e_s: lazy_segtree<Int,Int>.S = -1_000_000_000
fileprivate let e_t: lazy_segtree<Int,Int>.F = 0
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

extension lazy_segtree {
    init<T>(_ monoid: T) where T: LazySegtreeMonoid, S == T.S, F == T.F {
        self.init(op: T.op, e: T.e, mapping: T.mapping, composition: T.composition, id: T.id)
    }
    init<T>(_ monoid: T,_ n: Int) where T: LazySegtreeMonoid, S == T.S, F == T.F {
        self.init(op: T.op, e: T.e, mapping: T.mapping, composition: T.composition, id: T.id, n)
    }
    init<T>(_ monoid: T,_ v: [S]) where T: LazySegtreeMonoid, S == T.S, F == T.F {
        self.init(op: T.op, e: T.e, mapping: T.mapping, composition: T.composition, id: T.id, v)
    }
}

fileprivate extension lazy_segtree where S == AtCoderTests.S, F == AtCoderTests.F {
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
                  n )
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

fileprivate typealias starry_seg = lazy_segtree<S,F>

final class lazySegtreeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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
    
    func testAssign() throws {
        var seg0 = starry_seg();
        XCTAssertNoThrow(seg0 = starry_seg(10));
    }

    func testInvalid() throws {
        
        throw XCTSkip("配列のfatalをSwiftのみでハンドリングする方法が、まだない。SE-0403以後に、テストするように切り替えます。")
        
        XCTAssertThrowsError(starry_seg(-1))
        
        var s = starry_seg(10)
        
        XCTAssertThrowsError(s.get(-1))
        XCTAssertThrowsError(s.get(10))
        
        XCTAssertThrowsError(s.prod(-1,-1))
        
        XCTAssertThrowsError(s.prod(3,2))
        XCTAssertThrowsError(s.prod(0,11))
        XCTAssertThrowsError(s.prod(-1,11))
    }
    
    func testNaiveProd() throws {
//        for (int n = 0; n <= 50; n++) {
        for n in 0...50 {
            var seg = starry_seg(n);
            var p = [Int](repeating: 0, count: n)
//            for (int i = 0; i < n; i++) {
            for i in 0..<n {
                p[i] = (i * i + 100) % 31;
                seg.set(i, p[i]);
            }
//            for (int l = 0; l <= n; l++) {
            for l in 0..<=n {
//                for (int r = l; r <= n; r++) {
                for r in l..<=n {
                    var e = -1_000_000_000;
//                    for (int i = l; i < r; i++) {
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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
