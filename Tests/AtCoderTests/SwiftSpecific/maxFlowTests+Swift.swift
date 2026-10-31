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

extension LibraryTests.maxFlowTests {
  @Test(.tags(.swiftSpecific))
  func testReservationPreservesEdgesAndResidualFlow() {
    var graph = MFGraph<Int>(count: 4)
    // Self-loop counts twice; parallel edges retain their registration order.
    graph.reserveCapacity(edgeCounts: [4, 4, 2, 0])
    #expect(graph.add_edge(0, 0, 7) == 0)
    #expect(graph.add_edge(0, 1, 3) == 1)
    #expect(graph.add_edge(0, 1, 4) == 2)
    #expect(graph.add_edge(1, 2, 5) == 3)
    #expect(graph.flow(0, 2, 2) == 2)
    let before = graph.edges()
    graph.reserveCapacity(edgeCounts: [16, 16, 16, 0])
    let after = graph.edges()
    #expect(before.count == after.count)
    for (a, b) in zip(before, after) {
      #expect(a.from == b.from && a.to == b.to && a.cap == b.cap && a.flow == b.flow)
    }
    // Additional edges can still be registered after reservation and partial flow.
    #expect(graph.add_edge(1, 2, 2) == 4)
    #expect(graph.flow(0, 2) == 5)
    graph.reserveCapacity(edgeCounts: [0, 0, 0, 0])
    #expect(graph.flow(0, 2) == 0)
  }
}
