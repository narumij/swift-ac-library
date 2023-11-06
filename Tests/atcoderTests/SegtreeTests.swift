import XCTest
@testable import atcoder

extension CChar: ExpressibleByStringLiteral {
    public init(stringLiteral s: String) {
        self = Character(s).asciiValue.map{ Int8($0) }!
    }
}

final class SegtreeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    enum propery: SegtreeProperty {
        static var op: (String, String) -> String {
            { a, b in
                assert(a == "$" || b == "$" || a <= b);
                if (a == "$") { return b; }
                if (b == "$") { return a; }
                return a + b;
            }
        }
        static var e: () -> String {
            { return "$"; }
        }
        typealias S = String
    }
    
    func test0() {
        XCTAssertEqual("$", segtree<propery>(0).all_prod())
        XCTAssertEqual("$", segtree<propery>().all_prod())
    }
    
    func testInvalid() {
//        XCTAssertThrowsError(segtree_naive<Config>(-1))
        var s = segtree<propery>(10)
        
//        XCTAssertThrowsError(s.get(-1))
//        XCTAssertThrowsError(s.get(10))
        
//        XCTAssertThrowsError(s.prod(-1,-1))
        
//        XCTAssertThrowsError(s.prod(3,2))
//        XCTAssertThrowsError(s.prod(0,11))
//        XCTAssertThrowsError(s.prod(-1,11))

//        XCTAssertThrowsError(s.max_right(11, { _ in true }))
//        XCTAssertThrowsError(s.min_left(-1, { _ in true }))
//        XCTAssertThrowsError(s.max_right(0, { _ in false }))
    }
    
    func testOne() throws {
        var s = segtree<propery>(1)
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
            var seg0 = segtree_naive<propery>(n);
            var seg1 = segtree<propery>(n);
//            for (int i = 0; i < n; i++) {
            for i in 0..<n {
//                std::string s = "";
                var s = ""
                s.append(String(cString:["a" + CChar(i),0]))
                seg0.set(i, s);
                seg1.set(i, s);
            }

//            for (int l = 0; l <= n; l++) {
            for l in 0...n {
//                for (int r = l; r <= n; r++) {
                for r in l...n {
                    XCTAssertEqual(seg0.prod(l, r), seg1.prod(l, r));
                }
            }

//            for (int l = 0; l <= n; l++) {
            for l in 0...n {
//                for (int r = l; r <= n; r++) {
                for r in l...n {
                    y = seg1.prod(l, r);
                    XCTAssertEqual(seg0.max_right(l, leq_y), seg1.max_right(l,leq_y));
                    XCTAssertEqual(seg0.max_right(l, leq_y),
                              seg1.max_right(l, { x in
                                  return x.count <= y.count;
                              }));
                }
            }

//            for (int r = 0; r <= n; r++) {
            for r in 0...n {
//                for (int l = 0; l <= r; l++) {
                for l in 0...r {
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
        var seg0 = segtree<propery>();
        XCTAssertNoThrow(seg0 = segtree<propery>(10));
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
