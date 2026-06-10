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

  struct maxflowDeathTests {

    @Test func testInvalid() async {
      //  EXPECT_DEATH(g.flow(0, 0), ".*");
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        var g = mf_graph<Int>(count: 2);
        _ = g.flow(0,0)
      }
      //  EXPECT_DEATH(g.flow(0, 0, 0), ".*");
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        var g = mf_graph<Int>(count: 2);
        _ = g.flow(0,0,0)
      }
    }
  }
#endif
