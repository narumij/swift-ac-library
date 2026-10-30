import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

extension LibraryTests.sccTests {
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
  @Test(.tags(.swiftSpecific))
  func testPractice2Performanc() throws {
    measureRepeated {
      try! testPractice2()
    }
  }
}
