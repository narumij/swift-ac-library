import XCTest
@testable import AtCoder

fileprivate typealias uint = CUnsignedInt;
fileprivate typealias ll = CLongLong;
fileprivate typealias ull = CUnsignedLongLong;

final class etcTests: XCTestCase {

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
    
    func testPowerMode1() throws {
        XCTAssertEqual(0, _Internal.pow_mod_constexpr(2, 32, 1))
    }
    
    func some() throws {
        do {
            var segtree = SegTree<Int>(op: max, e: 0)
        }
        do {
            var segtree = SegTree(op: max, e: 0)
        }
        do {
            var segtree = SegTree<Int>(op: +, e: 0)
        }
        do {
            var segtree = SegTree<Int>(op: *, e: 1)
        }
        do {
            var lazy_segtree = LazySegTree<Int,Int>(
                op: max,
                e: 0,
                mapping: +,
                composition: +,
                id: 0)
        }
        do {
            var lazy_segtree = LazySegTree(
                op: max,
                e: 0,
                mapping: +,
                composition: +,
                id: 0)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
