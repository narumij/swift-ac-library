import XCTest
@testable import AtCoder

fileprivate struct lazy_segtree_starry {
    static func op_ss(_ a: Int,_ b: Int) -> Int { return max(a, b); }
    static func op_ts(_ a: Int,_ b: Int) -> Int { return a + b; }
    static func op_tt(_ a: Int,_ b: Int) -> Int { return a + b; }
    static func e_s() -> Int { return -1_000_000_000; }
    static func e_t() -> Int { return 0; }
    typealias S = Int
    typealias F = Int
};

fileprivate extension lazy_segtree where S == lazy_segtree_starry.S, F == lazy_segtree_starry.F {
    init() {
        self.init(op: max,
                  e: -1_000_000_000,
                  mapping: (+),
                  composition: (+),
                  id: 0)
    }
    init(_ n: Int) {
        self.init(op: lazy_segtree_starry.op_ss,
                  e: lazy_segtree_starry.e_s(),
                  mapping: lazy_segtree_starry.op_ts,
                  composition: lazy_segtree_starry.op_tt,
                  id: lazy_segtree_starry.e_t(),
                  n )
    }
    init(_ v: [S]) {
        self.init(op: lazy_segtree_starry.op_ss,
                  e: lazy_segtree_starry.e_s(),
                  mapping: lazy_segtree_starry.op_ts,
                  composition: lazy_segtree_starry.op_tt,
                  id: lazy_segtree_starry.e_t(),
                  v )
    }
}

fileprivate struct lazy_segtree_starry2: LazySegtreeProtocol {
    static let op: (Int,Int) -> Int = max
    static let e: Int = Int.min
    static var mapping: (Int,Int) -> Int = (+)
    static var composition: (Int,Int) -> Int = (+)
    static let id: Int = 0
    var storage: Storage
}

fileprivate typealias starry_seg = lazy_segtree<lazy_segtree_starry.S,lazy_segtree_starry.F>

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
