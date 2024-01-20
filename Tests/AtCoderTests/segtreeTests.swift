import XCTest
@testable import AtCoder

fileprivate func op(a: String,b: String) -> String {
    assert(a == "$" || b == "$" || a <= b);
    if (a == "$") { return b; }
    if (b == "$") { return a; }
    return a + b;
}

fileprivate let e: String = "$"

protocol SegtreeMonoid {
    associatedtype S
    static var op: (S,S) -> S { get }
    static var e: S { get }
}

extension segtree {
    init<T>(_ monoid: T) where T: SegtreeMonoid, S == T.S {
        self.init(op: T.op, e: T.e)
    }
    init<T>(_ monoid: T,_ n: Int) where T: SegtreeMonoid, S == T.S {
        self.init(op: T.op, e: T.e, n)
    }
    init<T>(_ monoid: T,_ v: [S]) where T: SegtreeMonoid, S == T.S {
        self.init(op: T.op, e: T.e, v)
    }
}

fileprivate extension segtree where S == String {
    init() {
        self.init(op: AtCoderTests.op, e: AtCoderTests.e)
    }
    init(_ n: Int) {
        self.init(op: AtCoderTests.op, e: AtCoderTests.e, n )
    }
}

fileprivate extension segtree_naive where S == String {
    init(_ n: Int) {
        self.init(op: AtCoderTests.op, e: AtCoderTests.e, n )
    }
}

final class segtreeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    enum fixture: SegtreeParameter {
//        static let op: (String,String) -> String = { a, b in
//            assert(a == "$" || b == "$" || a <= b);
//            if (a == "$") { return b; }
//            if (b == "$") { return a; }
//            return a + b;
//        }
//        static let e: String = "$"
//        typealias S = String
//    }
    
    func test0() {
        XCTAssertEqual("$", segtree(0).all_prod())
        XCTAssertEqual("$", segtree().all_prod())
    }
    
    func testInvalid() throws {
        
        throw XCTSkip("配列のfatalをSwiftのみでハンドリングする方法が、まだない。SE-0403以後に、テストするように切り替えます。")
        
        XCTAssertThrowsError(segtree_naive(-1))
        
        let s = segtree(10)
        
        XCTAssertThrowsError(s.get(-1))
        XCTAssertThrowsError(s.get(10))
        
        XCTAssertThrowsError(s.prod(-1,-1))
        
        XCTAssertThrowsError(s.prod(3,2))
        XCTAssertThrowsError(s.prod(0,11))
        XCTAssertThrowsError(s.prod(-1,11))

        XCTAssertThrowsError(s.max_right(11, { _ in true }))
        XCTAssertThrowsError(s.min_left(-1, { _ in true }))
        XCTAssertThrowsError(s.max_right(0, { _ in false }))
    }
    
    func testOne() throws {
        var s = segtree(1)
        XCTAssertEqual("$", s.all_prod());
        XCTAssertEqual("$", s.get(0));
        XCTAssertEqual("$", s.prod(0, 1));
        s.set(0, "dummy");
        XCTAssertEqual("dummy", s.get(0));
        XCTAssertEqual("$", s.prod(0, 0));
        XCTAssertEqual("dummy", s.prod(0, 1));
        XCTAssertEqual("$", s.prod(1, 1));
    }
    
    func testCompareNaive() throws {
        var y: String = ""
        func leq_y(_ x: String) -> Bool { x.count <= y.count }

//        for (int n = 0; n < 30; n++) {
        for n in 0..<30 {
            var seg0 = segtree_naive(n);
            var seg1 = segtree(n);
//            for (int i = 0; i < n; i++) {
            for i in 0..<n {
                var s = ""
                s.append(String(cString:["a" + CChar(i),0]))
                seg0.set(i, s);
                seg1.set(i, s);
            }

//            for (int l = 0; l <= n; l++) {
            for l in 0..<=n {
//                for (int r = l; r <= n; r++) {
                for r in l..<=n {
                    XCTAssertEqual(seg0.prod(l, r), seg1.prod(l, r));
                }
            }

//            for (int l = 0; l <= n; l++) {
            for l in 0..<=n {
//                for (int r = l; r <= n; r++) {
                for r in l..<=n {
                    y = seg1.prod(l, r);
                    XCTAssertEqual(seg0.max_right(l, leq_y), seg1.max_right(l,leq_y));
                    XCTAssertEqual(seg0.max_right(l, leq_y),
                              seg1.max_right(l, { x in
                                  return x.count <= y.count;
                              }));
                }
            }

//            for (int r = 0; r <= n; r++) {
            for r in 0..<=n {
//                for (int l = 0; l <= r; l++) {
                for l in 0..<=r {
                    y = seg1.prod(l, r);
                    XCTAssertEqual(seg0.min_left(r,leq_y), seg1.min_left(r,leq_y));
                    XCTAssertEqual(seg0.min_left(r,leq_y),
                              seg1.min_left(r, { x in
                                  return x.count <= y.count;
                              }));
                }
            }
        }
    }
    
    func testAssign() throws {
        var seg0 = segtree();
        XCTAssertNoThrow(seg0 = segtree(10));
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
