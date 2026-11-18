import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

extension LibraryTests.mincostflowTests {
  @Test(.tags(.swiftSpecific))
  func testSameCostPath() throws {
    var g = mcf_graph<Int, Int>(count: 3)
    #expect(0 == g.add_edge(0, 1, 1, 1))
    #expect(1 == g.add_edge(1, 2, 1, 0))
    #expect(2 == g.add_edge(0, 2, 2, 1))
    let expected = [(0, 0), (3, 3)]
    tuplesEqual(expected, g.slope(0, 2))
  }
  @Test(.tags(.swiftSpecific))
  func testMisc() throws {
    let _ = MCFGraph<Int, Float>()
    let _ = MCFGraph<Float, Int>()
    let _ = MCFGraph<Int, Int>()
    let _ = MCFGraph<UInt, Int>()
    let _ = MCFGraph<Float, Float>()
    let _ = MCFGraph<Float, Double>()
  }
}
