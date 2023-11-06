import XCTest
@testable import atcoder

struct starry {
    static func op_ss(_ a: Int,_ b: Int) -> Int { return Swift.max(a, b); }
    static func op_ts(_ a: Int,_ b: Int) -> Int { return a + b; }
    static func op_tt(_ a: Int,_ b: Int) -> Int { return a + b; }
    static func e_s() -> Int { return -1_000_000_000; }
    static func e_t() -> Int { return 0; }
};

extension starry: LazySegtreeProperty, SegtreeProperty {
    typealias S = Int
    static let op: (S,S) -> S = starry.op_ss
    static let e: () -> S = starry.e_s
    typealias F = Int
    static var mapping: (F,S) -> S = starry.op_ts
    static var composition: (F,F) -> F = starry.op_tt
    static var `id`: () -> F = starry.e_t
}

final class LazySegtreeTests: XCTestCase {

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
    
    func testZero() throws {
        do {
            let s = lazy_segtree<starry>(0);
            XCTAssertEqual(-1_000_000_000, s.all_prod());
        }
        do {
            let s = lazy_segtree<starry>();
            XCTAssertEqual(-1_000_000_000, s.all_prod());
        }
        do {
            let s = lazy_segtree<starry>(10);
            XCTAssertEqual(-1_000_000_000, s.all_prod());
        }
    }
    
    func testUsage() throws {
        
        var seg = lazy_segtree<starry>([Int](repeating: 0, count: 10));
        
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
