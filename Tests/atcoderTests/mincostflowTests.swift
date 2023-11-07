//
//  mincostflowTests.swift
//  
//
//  Created by narumij on 2023/11/07.
//

import XCTest
@testable import atcoder

extension mcf_graph.edge: ExpressibleByArrayLiteral where Cost == Int, Cap == Int {
    public init(arrayLiteral elements: Int...) {
        self.init(elements[0], elements[1], elements[2], elements[3], elements[4])
    }
}

final class mincostflowTests: XCTestCase {

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
    
    func test0() throws {
        var g1 = mcf_graph<Int, Int>();
        var g2 = mcf_graph<Int, Int>(0);
    }
    
    func edge_eq(_ expect: mcf_graph<Int, Int>.edge,_ actual: mcf_graph<Int, Int>.edge) {
        XCTAssertEqual(expect.from, actual.from);
        XCTAssertEqual(expect.to, actual.to);
        XCTAssertEqual(expect.cap, actual.cap);
        XCTAssertEqual(expect.flow, actual.flow);
        XCTAssertEqual(expect.cost, actual.cost);
    }
    
    func tupleEqual<A: Equatable, B: Equatable>(_ a:(A,B),_ b:(A,B)) {
        XCTAssertEqual(a.0, b.0)
        XCTAssertEqual(a.1, b.1)
    }
    
    func tuplesEqual<A: Equatable, B: Equatable>(_ a:[(A,B)],_ b:[(A,B)]) {
        zip(a,b).forEach(tupleEqual)
    }
    
    func testSimple() throws {
        
        var g = mcf_graph<Int, Int>(4);
        g.add_edge(0, 1, 1, 1);
        g.add_edge(0, 2, 1, 1);
        g.add_edge(1, 3, 1, 1);
        g.add_edge(2, 3, 1, 1);
        g.add_edge(1, 2, 1, 1);
        let expect = [(0, 0), (2, 4)];
        tuplesEqual(expect, g.slope(0, 3, 10));
        var e = mcf_graph<Int, Int>.edge();

        e = [0, 1, 1, 1, 1];
        edge_eq(e, g.get_edge(0));
        e = [0, 2, 1, 1, 1];
        edge_eq(e, g.get_edge(1));
        e = [1, 3, 1, 1, 1];
        edge_eq(e, g.get_edge(2));
        e = [2, 3, 1, 1, 1];
        edge_eq(e, g.get_edge(3));
        e = [1, 2, 1, 0, 1];
        edge_eq(e, g.get_edge(4));
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
