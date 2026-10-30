// TODO: TSanのコンパイラ停止解消後に除外を解除する（OPS-011）。
// Linux Swift 6.4.2 Debug+TSanでmincostflow.swift.oの検証が
// Invalid bitcastにより停止するため、実装と対応テストを一時除外。
// 通常・ASanでは有効。TSAN_TESTではMCFGraph API自体が存在しない。
#if !TSAN_TEST
import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

typealias mcf_graph = MCFGraph

extension mcf_graph.Edge: ExpressibleByArrayLiteral where Cap == Int, Cost == Int {
  public init(arrayLiteral elements: Int...) {
    if elements.isEmpty {
      self.init(from: 0, to: 0, cap: 0, flow: 0, cost: 0)
      return
    }
    self.init(
      from: elements[0], to: elements[1], cap: elements[2], flow: elements[3], cost: elements[4])
  }
  var values: (Int, Int, Cap, Cap, Cost) { (from, to, cap, flow, cost) }
}

extension LibraryTests {
  final class mincostflowTests {

    @Test(.tags(.aclPort))
    func test0() throws {
      _ = mcf_graph<Int, Int>()
      _ = mcf_graph<Int, Int>(count: 0)
    }

    func edge_eq(_ expect: mcf_graph<Int, Int>.Edge, _ actual: mcf_graph<Int, Int>.Edge) {
      #expect(expect.from == actual.from, "expect \(expect.values) but \(actual.values)")
      #expect(expect.to == actual.to, "expect \(expect.values) but \(actual.values)")
      #expect(expect.cap == actual.cap, "expect \(expect.values) but \(actual.values)")
      #expect(expect.flow == actual.flow, "expect \(expect.values) but \(actual.values)")
      #expect(expect.cost == actual.cost, "expect \(expect.values) but \(actual.values)")
    }

    func tupleEqual<A: Equatable, B: Equatable>(_ a: (A, B), _ b: (A, B)) {
      #expect(a.0 == b.0)
      #expect(a.1 == b.1)
    }

    func tuplesEqual<A: Equatable, B: Equatable>(_ a: [(A, B)], _ b: [(A, B)]) {
      zip(a, b).forEach(tupleEqual)
    }

    @Test(.tags(.aclPort))
    func testSimple() throws {

      var g = mcf_graph<Int, Int>(count: 4)
      g.add_edge(0, 1, 1, 1)
      g.add_edge(0, 2, 1, 1)
      g.add_edge(1, 3, 1, 1)
      g.add_edge(2, 3, 1, 1)
      g.add_edge(1, 2, 1, 1)

      let expect = [(0, 0), (2, 4)]
      tuplesEqual(expect, g.slope(0, 3, 10))

      var e = mcf_graph<Int, Int>.Edge()
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

    @Test(.tags(.aclPort))
    func testUsage() throws {
      do {
        var g = mcf_graph<Int, Int>(count: 2)
        g.add_edge(0, 1, 1, 2)
        tupleEqual((1, 2), g.flow(0, 1))
      }
      do {
        var g = mcf_graph<Int, Int>(count: 2)
        g.add_edge(0, 1, 1, 2)
        let expect = [(0, 0), (1, 2)]
        tuplesEqual(expect, g.slope(0, 1))
      }
    }

    #if false
      @Test(.tags(.aclPort))
      func testAssign() throws {
        return  // Previously skipped: "代入のオーバーロードはSwiftにはない。"
        //        TEST(MincostflowTest, Assign) {
        //            mcf_graph<int, int> g;
        //            g = mcf_graph<int, int>(10);
        //        }
      }
    #endif

    #if false
      @Test(.tags(.aclPort))
      func testOutrange() throws {
        return  // Previously skipped: "Swift Packageでは実施不可"
        var g = mcf_graph<Int>(count: 10)
        XCTAssertThrowsError(g.slope(-1, 3), ".*")
        XCTAssertThrowsError(g.slope(3, 3), ".*")
      }
    #endif

    @Test(.tags(.aclPort))
    func testSelfLoop() throws {

      var g = mcf_graph<Int, Int>(count: 3)
      #expect(0 == g.add_edge(0, 0, 100, 123))

      let e: mcf_graph<Int, Int>.Edge = [0, 0, 100, 0, 123]
      edge_eq(e, g.get_edge(0))
    }

    #if false
      @Test(.tags(.aclPort))
      func testInvalid() throws {
        return  // Previously skipped: "Swift Packageでは実施不可"
        var g = mcf_graph<Int>(count: 2)
        // https://github.com/atcoder/ac-library/issues/51
        XCTAssertThrowsError(g.add_edge(0, 0, -1, 0), ".*")
        XCTAssertThrowsError(g.add_edge(0, 0, 0, -1), ".*")
      }
    #endif

    @Test(.tags(.aclPort))
    func testStress() throws {

      #if DEBUG
        let phases = 100
      #else
        let phases = 10000
      #endif

      measureRepeated {
        for phase in 0..<phases {
          let n = randint(2, 20)
          let m = randint(1, 100)
          if m > 40 { continue }
          var s: Int
          var t: Int
          (s, t) = randpair(0, n - 1)
          if randbool() { swap(&s, &t) }

          var g_mf = mf_graph<Int>(count: n)
          var g = mcf_graph<Int, Int>(count: n)
          var data: [(Int, Int, Int, Int, Int)] = []
          for _ in 0..<m {
            let u = randint(0, n - 1)
            let v = randint(0, n - 1)
            let cap = randint(0, 10)
            let cost = randint(0, 10000)
            data.append((u, v, cap, 0, cost))
            g.add_edge(u, v, cap, cost)
            g_mf.add_edge(u, v, cap)
          }
          var flow: Int
          var cost: Int
          (flow, cost) = g.flow(s, t)
          #expect(
            g_mf.flow(s, t) == flow,
            "when phase = \(phase)\nint n = \(n);int m = \(m);int s = \(s);int t = \(t);\nstd::vector<mcf_graph<int, int>::edge> ee = {\(data.map{ "{\($0.0),\($0.01),\($0.2),\($0.3),\($0.4)}" }.joined(separator: ", "))};\nlet (n,s,t) = (\(n),\(s),\(t))\nlet data = \(data)"
          )

          var cost2 = 0
          var v_cap = [Int](repeating: 0, count: n)
          for e in g.edges() {
            v_cap[e.from] -= e.flow
            v_cap[e.to] += e.flow
            cost2 += e.flow * e.cost
          }
          #expect(cost == cost2, "when phase = \(phase)")

          for i in 0..<n {
            if i == s {
              #expect(-flow == v_cap[i])
            } else if i == t {
              #expect(flow == v_cap[i])
            } else {
              #expect(0 == v_cap[i])
            }
          }

          // check: there is no negative-cycle
          var dist = [Int](repeating: 0, count: n)
          while true {
            var update = false
            for e in g.edges() {
              if e.flow < e.cap {
                let ndist = dist[e.from] + e.cost
                if ndist < dist[e.to] {
                  update = true
                  dist[e.to] = ndist
                }
              }
              if (e.flow) != 0 {
                let ndist = dist[e.to] - e.cost
                if ndist < dist[e.from] {
                  update = true
                  dist[e.from] = ndist
                }
              }
            }
            if !update { break }
          }
        }
      }
    }

  }

}

// Invalid-input exit tests.
#if DEATH_TEST && DEBUG

  @Suite(.tags(.exitTest))
  struct mincostflowDeathTests {

    @Test(.tags(.aclPort)) func testInvalid() async {
      //  EXPECT_DEATH(g.add_edge(0, 0, -1, 0), ".*");
      await #expect(processExitsWith: .failure) {
        var g = mcf_graph<Int, Int>(count: 2)
        _ = g.add_edge(0, 0, -1, 0)
      }
      //  EXPECT_DEATH(g.add_edge(0, 0, 0, -1), ".*");
      await #expect(processExitsWith: .failure) {
        var g = mcf_graph<Int, Int>(count: 2)
        _ = g.add_edge(0, 0, 0, -1)
      }
    }

    @Test(.tags(.aclPort)) func testOutOfRange() async {
      //  EXPECT_DEATH(g.slope(-1, 3), ".*");
      await #expect(processExitsWith: .failure) {
        var g = mcf_graph<Int, Int>(count: 10)
        _ = g.slope(-1, 3)
      }
      //  EXPECT_DEATH(g.slope(3, 3), ".*");
      await #expect(processExitsWith: .failure) {
        var g = mcf_graph<Int, Int>(count: 10)
        _ = g.slope(3, 3)
      }
    }
  }
#endif

#endif
