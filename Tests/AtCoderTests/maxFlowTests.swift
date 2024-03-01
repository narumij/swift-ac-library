//
//  maxFlowTests.swift
//  
//
//  Created by narumij on 2023/11/07.
//

import XCTest
@testable import AtCoder

typealias mf_graph = MFGraph

extension mf_graph.Edge {
    init() { self.init(from: 0,to: 0,cap: 0,flow: 0) }
}

extension mf_graph.Edge: ExpressibleByArrayLiteral where Cap == Int {
    public init(arrayLiteral elements: Int...) {
        self.init(from: elements[0], to: elements[1], cap: elements[2], flow: elements[3])
    }
}

extension mf_graph._Edge: ExpressibleByArrayLiteral where Cap == Int {
    public init(arrayLiteral elements: Int...) {
        self.init(to: elements[0],rev: elements[1],cap: elements[2])
    }
}



final class maxFlowTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test0() throws {
        _ = mf_graph<Int>()
        _ = mf_graph<Int>(count: 0)
    }
    
    func testAssign() throws {
        throw XCTSkip("C++固有のオーバーロードに関するテストなので、実施しない")
    }
    
    func edge_eq<T: Equatable>(_ expect: mf_graph<T>.Edge,_ actual: mf_graph<T>.Edge) {
        XCTAssertEqual(expect.from, actual.from);
        XCTAssertEqual(expect.to, actual.to);
        XCTAssertEqual(expect.cap, actual.cap);
        XCTAssertEqual(expect.flow, actual.flow);
    }
    
    func testSimple() throws {
//        throw XCTSkip()
        var g = mf_graph<Int>(count: 4);
        XCTAssertEqual(0, g.add_edge(0, 1, 1));
        XCTAssertEqual(1, g.add_edge(0, 2, 1));
        XCTAssertEqual(2, g.add_edge(1, 3, 1));
        XCTAssertEqual(3, g.add_edge(2, 3, 1));
        XCTAssertEqual(4, g.add_edge(1, 2, 1));
        XCTAssertEqual(2, g.flow(0, 3));

        var e = mf_graph<Int>.Edge();
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
        var g = mf_graph<Int>(count: 2);
        XCTAssertEqual(0, g.add_edge(0, 1, 1));
        XCTAssertEqual(1, g.add_edge(0, 1, 2));
        XCTAssertEqual(2, g.add_edge(0, 1, 3));
        XCTAssertEqual(3, g.add_edge(0, 1, 4));
        XCTAssertEqual(4, g.add_edge(0, 1, 5));
        XCTAssertEqual(5, g.add_edge(0, 0, 6));
        XCTAssertEqual(6, g.add_edge(1, 1, 7));
        XCTAssertEqual(15, g.flow(0, 1));

        var e = mf_graph<Int>.Edge();
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
        var g = mf_graph<Int>(count: 3);
        XCTAssertEqual(0, g.add_edge(0, 1, 2));
        XCTAssertEqual(1, g.add_edge(1, 2, 1));
        XCTAssertEqual(1, g.flow(0, 2));

        var e = mf_graph<Int>.Edge();
        e = [0, 1, 2, 1];
        edge_eq(e, g.get_edge(0));
        e = [1, 2, 1, 1];
        edge_eq(e, g.get_edge(1));

        XCTAssertEqual([true, true, false], g.min_cut(0));
    }
    
    func testTwice() throws {

        var e = mf_graph<Int>.Edge();

        var g = mf_graph<Int>(count: 3);
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
    
    func testBound() throws {
        var e = mf_graph<Int>.Edge();

        let INF = Int.max;
        var g = mf_graph<Int>(count: 3);
        XCTAssertEqual(0, g.add_edge(0, 1, INF));
        XCTAssertEqual(1, g.add_edge(1, 0, INF));
        XCTAssertEqual(2, g.add_edge(0, 2, INF));

        XCTAssertEqual(INF, g.flow(0, 2));

        e = [0, 1, INF, 0];
        edge_eq(e, g.get_edge(0));
        e = [1, 0, INF, 0];
        edge_eq(e, g.get_edge(1));
        e = [0, 2, INF, INF];
        edge_eq(e, g.get_edge(2));
    }
    
    func testBoundUnit() throws {
        var e = mf_graph<Int>.Edge();

        let INF = Int.max;
        var g = mf_graph<Int>(count: 3);
        XCTAssertEqual(0, g.add_edge(0, 1, INF));
        XCTAssertEqual(1, g.add_edge(1, 0, INF));
        XCTAssertEqual(2, g.add_edge(0, 2, INF));

        XCTAssertEqual(INF, g.flow(0, 2));

        e = [0, 1, INF, 0];
        edge_eq(e, g.get_edge(0));
        e = [1, 0, INF, 0];
        edge_eq(e, g.get_edge(1));
        e = [0, 2, INF, INF];
        edge_eq(e, g.get_edge(2));
    }
    
    func testSelfLoop() throws {
        var g = mf_graph<Int>(count: 3);
        XCTAssertEqual(0, g.add_edge(0, 0, 100));

        let e: mf_graph<Int>.Edge = [0, 0, 100, 0];
        edge_eq(e, g.get_edge(0));
    }
    
    func testInvalid() throws {
        throw XCTSkip("テスト自体がクラッシュするのでスキップ")
        var g = mf_graph<Int>(count: 2);
        XCTAssertThrowsError(g.flow(0, 0), ".*");
        XCTAssertThrowsError(g.flow(0, 0, 0), ".*");
    }
    
    func testStress() throws {
//        for (int phase = 0; phase < 10000; phase++) {
        for phase in 0..<10000 {
            let n = randint(2, 20);
            let m = randint(1, 100);
            var s, t: Int;
            (s, t) = randpair(0, n - 1);
            if (randbool()) { swap(&s, &t); }

            var g = mf_graph<Int>(count: n);
//            for (int i = 0; i < m; i++) {
            for i in 0..<m {
                let u = randint(0, n - 1);
                let v = randint(0, n - 1);
                let c = randint(0, 10000);
                g.add_edge(u, v, c);
            }
            let flow = g.flow(s, t);
            var dual = 0;
            let cut = g.min_cut(s);
            var v_flow = [Int](repeating:0, count: n);
//            for (auto e: g.edges()) {
            for e in g.edges() {
                v_flow[e.from] -= e.flow;
                v_flow[e.to] += e.flow;
                if (cut[e.from] && !cut[e.to]) { dual += e.cap; }
            }
            XCTAssertEqual(flow, dual);
            XCTAssertEqual(-flow, v_flow[s]);
            XCTAssertEqual(flow, v_flow[t]);
//            for (int i = 0; i < n; i++) {
            for i in 0..<n {
                if (i == s || i == t) { continue; }
                XCTAssertEqual(0, v_flow[i]);
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
