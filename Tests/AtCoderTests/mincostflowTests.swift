import XCTest
import AtCoder

typealias mcf_graph = MCFGraph

extension mcf_graph.Edge: ExpressibleByArrayLiteral where Value == Int {
    public init(arrayLiteral elements: Int...) {
        if elements.isEmpty {
            self.init(from: 0, to: 0, cap: 0, flow: 0, cost: 0)
            return
        }
        self.init(from: elements[0], to: elements[1], cap: elements[2], flow: elements[3], cost: elements[4])
    }
    var values: (Int,Int,MCFGraph.Cap,MCFGraph.Cap,MCFGraph.Cost) { (from,to,cap,flow,cost) }
}

final class mincostflowTests: XCTestCase {

    func test0() throws {
        _ = mcf_graph<Int>()
        _ = mcf_graph<Int>(count: 0)
    }
    
    func edge_eq(_ expect: mcf_graph<Int>.Edge,_ actual: mcf_graph<Int>.Edge) {
        XCTAssertEqual(expect.from, actual.from, "expect \(expect.values) but \(actual.values)")
        XCTAssertEqual(expect.to, actual.to, "expect \(expect.values) but \(actual.values)")
        XCTAssertEqual(expect.cap, actual.cap, "expect \(expect.values) but \(actual.values)")
        XCTAssertEqual(expect.flow, actual.flow, "expect \(expect.values) but \(actual.values)")
        XCTAssertEqual(expect.cost, actual.cost, "expect \(expect.values) but \(actual.values)")
    }
    
    func tupleEqual<A: Equatable, B: Equatable>(_ a:(A,B),_ b:(A,B)) {
        XCTAssertEqual(a.0, b.0)
        XCTAssertEqual(a.1, b.1)
    }
    
    func tuplesEqual<A: Equatable, B: Equatable>(_ a:[(A,B)],_ b:[(A,B)]) {
        zip(a,b).forEach(tupleEqual)
    }
    
    func testSimple() throws {
        
        var g = mcf_graph<Int>(count: 4)
        g.add_edge(0, 1, 1, 1)
        g.add_edge(0, 2, 1, 1)
        g.add_edge(1, 3, 1, 1)
        g.add_edge(2, 3, 1, 1)
        g.add_edge(1, 2, 1, 1)
        
        let expect = [(0, 0), (2, 4)]
        tuplesEqual(expect, g.slope(0, 3, 10))
                
        var e = mcf_graph<Int>.Edge()
        e = [0, 1, 1, 1, 1]
        edge_eq(e, g.get_edge(0))
        e = [0, 2, 1, 1, 1]
        edge_eq(e, g.get_edge(1))
        e = [1, 3, 1, 1, 1]
        edge_eq(e, g.get_edge(2))
        e = [2, 3, 1, 1, 1]
        edge_eq(e, g.get_edge(3))
        e = [1, 2, 1, 0, 1]
        edge_eq(e, g.get_edge(4))
    }
    
    func testUsage() throws {
        do {
            var g = mcf_graph<Int>(count: 2)
            g.add_edge(0, 1, 1, 2)
            tupleEqual((1, 2), g.flow(0, 1))
        }
        do {
            var g = mcf_graph<Int>(count: 2)
            g.add_edge(0, 1, 1, 2)
            let expect = [(0, 0), (1, 2)]
            tuplesEqual(expect, g.slope(0, 1))
        }
    }
    
#if false
    func testAssign() throws {
        throw XCTSkip("代入のオーバーロードはSwiftにはない。")
//        TEST(MincostflowTest, Assign) {
//            mcf_graph<int, int> g;
//            g = mcf_graph<int, int>(10);
//        }
    }
#endif
    
#if false
    func testOutrange() throws {
        throw XCTSkip("Swift Packageでは実施不可")
        var g = mcf_graph<Int>(count: 10)
        XCTAssertThrowsError(g.slope(-1, 3), ".*")
        XCTAssertThrowsError(g.slope(3, 3), ".*")
    }
#endif
    
    func testSelfLoop() throws {
        
        var g = mcf_graph<Int>(count: 3)
        XCTAssertEqual(0, g.add_edge(0, 0, 100, 123))

        let e: mcf_graph<Int>.Edge = [0, 0, 100, 0, 123]
        edge_eq(e, g.get_edge(0))
    }
    
    func testSameCostPath() throws {
        var g = mcf_graph<Int>(count: 3)
        XCTAssertEqual(0, g.add_edge(0, 1, 1, 1))
        XCTAssertEqual(1, g.add_edge(1, 2, 1, 0))
        XCTAssertEqual(2, g.add_edge(0, 2, 2, 1))
        let expected = [(0, 0), (3, 3)]
        tuplesEqual(expected, g.slope(0, 2))
    }
    
#if false
    func testInvalid() throws {
        throw XCTSkip("Swift Packageでは実施不可")
        var g = mcf_graph<Int>(count: 2)
        // https://github.com/atcoder/ac-library/issues/51
        XCTAssertThrowsError(g.add_edge(0, 0, -1, 0), ".*")
        XCTAssertThrowsError(g.add_edge(0, 0, 0, -1), ".*")
    }
#endif
    
    func testStress() throws {
        
#if DEBUG
        let phases = 100
#else
        let phases = 10000
#endif
        
        self.measure {
            for phase in 0 ..< phases {
                let n = randint(2, 20)
                let m = randint(1, 100)
                if m > 40 { continue }
                var s, t: Int
                (s, t) = randpair(0, n - 1)
                if (randbool()) { swap(&s, &t) }
                
                var g_mf = mf_graph<Int>(count: n)
                var g = mcf_graph<Int>(count: n)
                var data: [(Int,Int,Int,Int,Int)] = []
                for _ in 0..<m {
                    let u = randint(0, n - 1)
                    let v = randint(0, n - 1)
                    let cap = randint(0, 10)
                    let cost = randint(0, 10000)
                    data.append((u,v,cap,0,cost))
                    g.add_edge(u, v, cap, cost)
                    g_mf.add_edge(u, v, cap)
                }
                var flow, cost: Int
                (flow, cost) = g.flow(s, t)
                XCTAssertEqual(g_mf.flow(s, t), flow, "when phase = \(phase)\nint n = \(n);int m = \(m);int s = \(s);int t = \(t);\nstd::vector<mcf_graph<int, int>::edge> ee = {\(data.map{ "{\($0.0),\($0.01),\($0.2),\($0.3),\($0.4)}" }.joined(separator: ", "))};\nlet (n,s,t) = (\(n),\(s),\(t))\nlet data = \(data)")
                
                var cost2 = 0
                var v_cap = [Int](repeating:0, count: n)
                for e in g.edges() {
                    v_cap[e.from] -= e.flow
                    v_cap[e.to] += e.flow
                    cost2 += e.flow * e.cost
                }
                XCTAssertEqual(cost, cost2, "when phase = \(phase)")
                
                for i in 0..<n {
                    if (i == s) {
                        XCTAssertEqual(-flow, v_cap[i])
                    } else if (i == t) {
                        XCTAssertEqual(flow, v_cap[i])
                    } else {
                        XCTAssertEqual(0, v_cap[i])
                    }
                }
                
                // check: there is no negative-cycle
                var dist = [Int](repeating: 0, count: n)
                while (true) {
                    var update = false
                    for e in g.edges() {
                        if (e.flow < e.cap) {
                            let ndist = dist[e.from] + e.cost
                            if (ndist < dist[e.to]) {
                                update = true
                                dist[e.to] = ndist
                            }
                        }
                        if ((e.flow) != 0) {
                            let ndist = dist[e.to] - e.cost
                            if (ndist < dist[e.from]) {
                                update = true
                                dist[e.from] = ndist
                            }
                        }
                    }
                    if (!update) { break }
                }
            }
        }
    }
}
