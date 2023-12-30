import XCTest
@testable import AtCoder

final class dsuTests_v1: XCTestCase {

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
    
    typealias dsu = dsu_v1
    
    func test0() throws {
        var uf = dsu(0);
        XCTAssertEqual([], uf.groups());
    }
    
    func testEmpty() throws {
        var uf = dsu();
        XCTAssertEqual([], uf.groups());
    }
    
    func testAssign() throws {
        var uf: dsu = .init();
        uf = dsu(10);
    }
    
    func testSimple() throws {
        var uf = dsu(2);
        XCTAssertFalse(uf.same(0, 1));
        let x = uf.merge(0, 1);
        XCTAssertEqual(x, uf.leader(0));
        XCTAssertEqual(x, uf.leader(1));
        XCTAssertTrue(uf.same(0, 1));
        XCTAssertEqual(2, uf.size(0));
    }
    
    func testLine() throws {
        let n = 500000;
        var uf = dsu(n);
//        for (int i = 0; i < n - 1; i++) {
        for i in 0..<(n - 1) {
            _ = uf.merge(i, i + 1);
        }
        XCTAssertEqual(n, uf.size(0));
        XCTAssertEqual(1, uf.groups().count);
    }
    
    func testLineReverse() throws {
        let n = 500000;
        var uf = dsu(n);
//        for (int i = n - 2; i >= 0; i--) {
        for i in (n - 2)..>=0 {
            _ = uf.merge(i, i + 1);
        }
        XCTAssertEqual(n, uf.size(0));
        XCTAssertEqual(1, uf.groups().count);
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
