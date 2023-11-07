//
//  maxFlowTests.swift
//  
//
//  Created by narumij on 2023/11/07.
//

import XCTest
@testable import atcoder

final class maxFlowTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test0() throws {
        _ = mf_graph<Int>()
        _ = mf_graph<Int>(0)
    }
    
    func testAssign() throws {
        // TODO: implement this
    }
    
    func edge_eq<T: Equatable>(_ expect: mf_graph<T>.edge,_ actual: mf_graph<T>.edge) {
        XCTAssertEqual(expect.from, actual.from);
        XCTAssertEqual(expect.to, actual.to);
        XCTAssertEqual(expect.cap, actual.cap);
        XCTAssertEqual(expect.flow, actual.flow);
    }
    
    func testSimple() throws {
        throw XCTSkip()
        var g = mf_graph<Int>(4);
        XCTAssertEqual(0, g.add_edge(0, 1, 1));
        XCTAssertEqual(1, g.add_edge(0, 2, 1));
        XCTAssertEqual(2, g.add_edge(1, 3, 1));
        XCTAssertEqual(3, g.add_edge(2, 3, 1));
        XCTAssertEqual(4, g.add_edge(1, 2, 1));
        XCTAssertEqual(2, g.flow(0, 3));

        var e = mf_graph<Int>.edge();
        e = [0, 1, 1, 1];
        edge_eq(e, g.get_edge(0));
        e = [0, 2, 1, 1];
        edge_eq(e, g.get_edge(1));
        e = [1, 3, 1, 1];
        edge_eq(e, g.get_edge(2));
        e = [2, 3, 1, 1];
        edge_eq(e, g.get_edge(3));
        e = [1, 2, 1, 0];
        edge_eq(e, g.get_edge(4));

        XCTAssertEqual([true, false, false, false], g.min_cut(0));
    }
    
    func testNotSimple() throws {
        throw XCTSkip()
        var g = mf_graph<Int>(2);
        XCTAssertEqual(0, g.add_edge(0, 1, 1));
        XCTAssertEqual(1, g.add_edge(0, 1, 2));
        XCTAssertEqual(2, g.add_edge(0, 1, 3));
        XCTAssertEqual(3, g.add_edge(0, 1, 4));
        XCTAssertEqual(4, g.add_edge(0, 1, 5));
        XCTAssertEqual(5, g.add_edge(0, 0, 6));
        XCTAssertEqual(6, g.add_edge(1, 1, 7));
        XCTAssertEqual(15, g.flow(0, 1));

        var e = mf_graph<Int>.edge();
        e = [0, 1, 1, 1];
        edge_eq(e, g.get_edge(0));
        e = [0, 1, 2, 2];
        edge_eq(e, g.get_edge(1));
        e = [0, 1, 3, 3];
        edge_eq(e, g.get_edge(2));
        e = [0, 1, 4, 4];
        edge_eq(e, g.get_edge(3));
        e = [0, 1, 5, 5];
        edge_eq(e, g.get_edge(4));

        XCTAssertEqual([true, false], g.min_cut(0));
    }
    
    func testCut() throws {
        throw XCTSkip()
        var g = mf_graph<Int>(3);
        XCTAssertEqual(0, g.add_edge(0, 1, 2));
        XCTAssertEqual(1, g.add_edge(1, 2, 1));
        XCTAssertEqual(1, g.flow(0, 2));

        var e = mf_graph<Int>.edge();
        e = [0, 1, 2, 1];
        edge_eq(e, g.get_edge(0));
        e = [1, 2, 1, 1];
        edge_eq(e, g.get_edge(1));

        XCTAssertEqual([true, true, false], g.min_cut(0));
    }
    
    func testTwice() throws {
        var e = mf_graph<Int>.edge();

        var g = mf_graph<Int>(3);
        XCTAssertEqual(0, g.add_edge(0, 1, 1));
        XCTAssertEqual(1, g.add_edge(0, 2, 1));
        XCTAssertEqual(2, g.add_edge(1, 2, 1));
        
        XCTAssertEqual(2, g.flow(0, 2));

        e = [0, 1, 1, 1];
        edge_eq(e, g.get_edge(0));
        e = [0, 2, 1, 1];
        edge_eq(e, g.get_edge(1));
        e = [1, 2, 1, 1];
        edge_eq(e, g.get_edge(2));

        g.change_edge(0, 100, 10);
        e = [0, 1, 100, 10];
        edge_eq(e, g.get_edge(0));

        XCTAssertEqual(0, g.flow(0, 2));
        XCTAssertEqual(90, g.flow(0, 1));

        e = [0, 1, 100, 100];
        edge_eq(e, g.get_edge(0));
        e = [0, 2, 1, 1];
        edge_eq(e, g.get_edge(1));
        e = [1, 2, 1, 1];
        edge_eq(e, g.get_edge(2));

        XCTAssertEqual(2, g.flow(2, 0));

        e = [0, 1, 100, 99];
        edge_eq(e, g.get_edge(0));
        e = [0, 2, 1, 0];
        edge_eq(e, g.get_edge(1));
        e = [1, 2, 1, 0];
        edge_eq(e, g.get_edge(2));
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
