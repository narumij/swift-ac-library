import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

extension LibraryTests {
  final class sccTests {

    typealias scc_graph = SCCGraph

    @Test(.tags(.aclPort))
    func testEmpty() throws {
      let graph0: scc_graph = .init()
      #expect([] == graph0.scc())
      let graph1: scc_graph = .init(0)
      #expect([] == graph1.scc())
    }

    @Test(.tags(.swiftSpecific))
    func testLongChainAndCycle() {
      let n = 100_000
      var graph = SCCGraph(n)
      for v in 0..<(n - 1) { graph.add_edge(v, v + 1) }
      #expect(graph.scc() == (0..<n).map { [$0] })
      graph.add_edge(n - 1, 0)
      #expect(graph.scc() == [Array(0..<n)])
    }

    @Test(.tags(.swiftSpecific))
    func testBranchReturnOrder() {
      var graph = SCCGraph(6)
      // 子からの復帰、探索中の祖先への辺、確定済み成分への辺を含む。
      for (from, to) in [(0, 1), (1, 2), (2, 1), (0, 3), (3, 4), (4, 0), (3, 2)] {
        graph.add_edge(from, to)
      }
      #expect(graph.scc() == [[5], [0, 3, 4], [1, 2]])
    }

    #if false
      @Test(.tags(.aclPort))
      func testAssign() throws {
        return  // Previously skipped: "代入のオーバーロードはSwiftにはない。"
      }
    #endif

    @Test(.tags(.aclPort))
    func testSimple() throws {
      var graph: scc_graph = .init(2)
      graph.add_edge(0, 1)
      graph.add_edge(1, 0)
      let scc = graph.scc()
      #expect(1 == scc.count)
    }

    @Test(.tags(.aclPort))
    func testSelfLoop() throws {
      var graph: scc_graph = .init(2)
      graph.add_edge(0, 0)
      graph.add_edge(0, 0)
      graph.add_edge(1, 1)
      let scc = graph.scc()
      #expect(2 == scc.count)
    }

    @Test(.tags(.swiftSpecific))
    func testPractice2() throws {
      var graph: scc_graph = .init(6)
      graph.add_edge(1, 4)
      graph.add_edge(5, 2)
      graph.add_edge(3, 0)
      graph.add_edge(5, 5)
      graph.add_edge(4, 1)
      graph.add_edge(0, 3)
      graph.add_edge(4, 2)
      let scc = graph.scc()
      #expect(4 == scc.count)
      #expect([[5], [1, 4], [2], [0, 3]] == scc)
    }

    #if false
      @Test(.tags(.aclPort))
      func testInvalid() throws {
        return  // Previously skipped: "Swift Packageでは実施不可"
        var graph: scc_graph = .init(2)
        XCTAssertThrowsError(graph.add_edge(0, 10), ".*")
      }
    #endif

    @Test(.tags(.swiftSpecific))
    func testPractice2Performanc() throws {
      measureRepeated {
        try! testPractice2()
      }
    }
  }

}
