//
//  fenwickTreeDethTests.swift
//  swift-ac-library
//
//  Created by narumij on 2026/06/10.
//

#if DEATH_TEST && DEBUG
  import Testing
  import AtCoder
  import Foundation

  struct mincostflowDeathTests {

    @Test func testInvalid() async {
      //  EXPECT_DEATH(g.add_edge(0, 0, -1, 0), ".*");
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        var g = mcf_graph<Int, Int>(count: 2)
        _ = g.add_edge(0, 0, -1, 0)
      }
      //  EXPECT_DEATH(g.add_edge(0, 0, 0, -1), ".*");
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        var g = mcf_graph<Int, Int>(count: 2)
        _ = g.add_edge(0, 0, 0, -1)
      }
    }

    @Test func testOutOfRange() async {
      //  EXPECT_DEATH(g.slope(-1, 3), ".*");
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        var g = mcf_graph<Int, Int>(count: 10)
        _ = g.slope(-1, 3)
      }
      //  EXPECT_DEATH(g.slope(3, 3), ".*");
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        var g = mcf_graph<Int, Int>(count: 10)
        _ = g.slope(3, 3)
      }
    }
  }
#endif
