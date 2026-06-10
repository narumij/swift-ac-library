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

  struct fenwickTreeDeathTests {

    @Test func testInvalid() async {
      //  EXPECT_THROW(auto s = fenwick_tree<int>(-1), std::exception);
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        _ = FenwickTree<Int>(-1)
      }
      //  EXPECT_DEATH(s.add(-1, 0), ".*");
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        var s = FenwickTree<Int>(10)
        s.add(-1, 0)
      }
      //  EXPECT_DEATH(s.add(10, 0), ".*");
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        var s = FenwickTree<Int>(10)
        s.add(10, 0)
      }
      //  EXPECT_DEATH(s.sum(-1, 3), ".*");
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        let s = FenwickTree<Int>(10)
        _ = s.sum(-1, 3)
      }
      //  EXPECT_DEATH(s.sum(3, 11), ".*");
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        let s = FenwickTree<Int>(10)
        _ = s.sum(3, 11)
      }
      //  EXPECT_DEATH(s.sum(5, 3), ".*");
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        let s = FenwickTree<Int>(10)
        _ = s.sum(5, 3)
      }
    }
  }
#endif
