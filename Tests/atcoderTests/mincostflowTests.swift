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
    var values: (Int,Int,Cap,Cap,Cost) { (from,to,cap,flow,cost) }
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
        XCTAssertEqual(expect.from, actual.from, "expect \(expect.values) but \(actual.values)");
        XCTAssertEqual(expect.to, actual.to, "expect \(expect.values) but \(actual.values)");
        XCTAssertEqual(expect.cap, actual.cap, "expect \(expect.values) but \(actual.values)");
        XCTAssertEqual(expect.flow, actual.flow, "expect \(expect.values) but \(actual.values)");
        XCTAssertEqual(expect.cost, actual.cost, "expect \(expect.values) but \(actual.values)");
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
    
    func testUsage() throws {
        do {
            var g = mcf_graph<Int, Int>(2);
            g.add_edge(0, 1, 1, 2);
            tupleEqual((1, 2), g.flow(0, 1));
        }
        do {
            var g = mcf_graph<Int, Int>(2);
            g.add_edge(0, 1, 1, 2);
            let expect = [(0, 0), (1, 2)];
            tuplesEqual(expect, g.slope(0, 1));
        }
    }
    
    func testAssign() throws {
        // TODO: implement this
//        TEST(MincostflowTest, Assign) {
//            mcf_graph<int, int> g;
//            g = mcf_graph<int, int>(10);
//        }
    }
    
    func testOutrange() throws {
        
        var g = mcf_graph<Int, Int>(10);

//        XCTAssertThrowsError(g.slope(-1, 3), ".*");
//        XCTAssertThrowsError(g.slope(3, 3), ".*");
    }
    
    func testSelfLoop() throws {
        
        var g = mcf_graph<Int, Int>(3);
        XCTAssertEqual(0, g.add_edge(0, 0, 100, 123));

        let e: mcf_graph<Int, Int>.edge = [0, 0, 100, 0, 123];
        edge_eq(e, g.get_edge(0));
    }
    
    func testSameCostPath() throws {
        var g = mcf_graph<Int, Int>(3);
        XCTAssertEqual(0, g.add_edge(0, 1, 1, 1));
        XCTAssertEqual(1, g.add_edge(1, 2, 1, 0));
        XCTAssertEqual(2, g.add_edge(0, 2, 2, 1));
        let expected = [(0, 0), (3, 3)];
        tuplesEqual(expected, g.slope(0, 2));
    }
    
    func testInvalid() throws {
        
        var g = mcf_graph<Int, Int>(2);
        // https://github.com/atcoder/ac-library/issues/51
//        XCTAssertThrowsError(g.add_edge(0, 0, -1, 0), ".*");
//        XCTAssertThrowsError(g.add_edge(0, 0, 0, -1), ".*");
    }
    
    func testStress() throws {
        try runStress(1000)
    }
    
    func runStress(_ phases:Int) throws {
//        for (int phase = 0; phase < 1000; phase++) {
        for phase in 0..<phases {
            let n = randint(2, 20);
            let m = randint(1, 100);
            var s, t: Int;
            (s, t) = randpair(0, n - 1);
            if (randbool()) { swap(&s, &t); }

            var g_mf = mf_graph<Int>(n);
            var g = mcf_graph<Int, Int>(n);
//            for (int i = 0; i < m; i++) {
            var data: [(Int,Int,Int,Int)] = []
            for i in 0..<m {
                let u = randint(0, n - 1);
                let v = randint(0, n - 1);
                let cap = randint(0, 10);
                let cost = randint(0, 10000);
                data.append((u,v,cap,cost))
                g.add_edge(u, v, cap, cost);
                g_mf.add_edge(u, v, cap);
            }
            var flow, cost: Int;
            (flow, cost) = g.flow(s, t);
            XCTAssertEqual(g_mf.flow(s, t), flow, "when phase = \(phase)\nn = \(n)\n(s,t) = (\(s),\(t)\n[(u,v,cap,cost)] = \(data)");

            var cost2 = 0;
            var v_cap = [Int](repeating:0, count: n);
//            for (auto e : g.edges()) {
            for e in g.edges() {
                v_cap[e.from] -= e.flow;
                v_cap[e.to] += e.flow;
                cost2 += e.flow * e.cost;
            }
            XCTAssertEqual(cost, cost2, "when phase = \(phase)");

//            for (int i = 0; i < n; i++) {
            for i in 0..<n {
                if (i == s) {
                    XCTAssertEqual(-flow, v_cap[i]);
                } else if (i == t) {
                    XCTAssertEqual(flow, v_cap[i]);
                } else {
                    XCTAssertEqual(0, v_cap[i]);
                }
            }

#if false
            // check: there is no negative-cycle
            var dist = [Int](repeating: 0, count: n);
            while (true) {
                var update = false;
//                for (auto e : g.edges()) {
                for e in g.edges() {
                    if (e.flow < e.cap) {
                        let ndist = dist[e.from] + e.cost;
                        if (ndist < dist[e.to]) {
                            update = true;
                            dist[e.to] = ndist;
                        }
                    }
                    if ((e.flow) != 0) {
                        let ndist = dist[e.to] - e.cost;
                        if (ndist < dist[e.from]) {
                            update = true;
                            dist[e.from] = ndist;
                        }
                    }
                }
                if (!update) { break; }
            }
#endif
        }
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
