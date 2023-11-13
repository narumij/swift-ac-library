import XCTest
@testable import atcoder

final class sccTests: XCTestCase {

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
    
    func testEmpty() throws {
        let graph0: scc_graph = .init();
        XCTAssertEqual([], graph0.scc());
        let graph1: scc_graph = .init(0);
        XCTAssertEqual([], graph1.scc());
    }
    
    func testAssign() throws {
        throw XCTSkip("C++固有のオーバーロードに関するテストなので、実施しない")
    }
    
    func testSimple() throws {
        var graph: scc_graph = .init(2);
        graph.add_edge(0, 1);
        graph.add_edge(1, 0);
        let scc = graph.scc();
        XCTAssertEqual(1, scc.count);
    }
    
    func testSelfLoop() throws {
        var graph: scc_graph = .init(2);
        graph.add_edge(0, 0);
        graph.add_edge(0, 0);
        graph.add_edge(1, 1);
        let scc = graph.scc();
        XCTAssertEqual(2, scc.count);
    }
    
    func testInvalid() throws {
        throw XCTSkip()
        var graph: scc_graph = .init(2);
        XCTAssertThrowsError(graph.add_edge(0, 10), ".*");
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}