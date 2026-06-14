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

  struct sccDeathTests {

    @Test func testInvalid() async {
      // EXPECT_DEATH(graph.add_edge(0, 10), ".*");
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        var graph = SCCGraph(2)
        _ = graph.add_edge(0, 10)
      }
    }
  }
#endif
