import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

extension LibraryTests.maxFlowTests {
  @Test(.tags(.swiftSpecific))
  func testBoundUnit() throws {
    var e = mf_graph<Int>.Edge()

    let INF = Int.max
    var g = mf_graph<Int>(count: 3)
    #expect(0 == g.add_edge(0, 1, INF))
    #expect(1 == g.add_edge(1, 0, INF))
    #expect(2 == g.add_edge(0, 2, INF))

    #expect(INF == g.flow(0, 2))

    e = [0, 1, INF, 0]
    edge_eq(e, g.get_edge(0))
    e = [1, 0, INF, 0]
    edge_eq(e, g.get_edge(1))
    e = [0, 2, INF, INF]
    edge_eq(e, g.get_edge(2))
  }
}
