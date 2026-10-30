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

#endif
