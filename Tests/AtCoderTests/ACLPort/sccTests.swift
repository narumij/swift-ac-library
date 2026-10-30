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

    #if false
      @Test(.tags(.aclPort))
      func testInvalid() throws {
        return  // Previously skipped: "Swift Packageでは実施不可"
        var graph: scc_graph = .init(2)
        XCTAssertThrowsError(graph.add_edge(0, 10), ".*")
      }
    #endif

  }

}

// Invalid-input exit tests.
#if DEATH_TEST && DEBUG

  @Suite(.tags(.exitTest))
  struct sccDeathTests {

    @Test(.tags(.aclPort)) func testInvalid() async {
      // EXPECT_DEATH(graph.add_edge(0, 10), ".*");
      await #expect(processExitsWith: .failure) {
        var graph = SCCGraph(2)
        _ = graph.add_edge(0, 10)
      }
    }
  }
#endif
