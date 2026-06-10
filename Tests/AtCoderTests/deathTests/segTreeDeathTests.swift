//
//  fenwickTreeDethTests.swift
//  swift-ac-library
//
//  Created by narumij on 2026/06/10.
//

#if DEATH_TEST
  import Testing
  import AtCoder
  import Foundation

  struct segTreeDeathTests {

    /*
     TEST(SegtreeTest, Invalid) {
         EXPECT_THROW(auto s = seg(-1), std::exception);
         seg s(10);

         EXPECT_DEATH(s.get(-1), ".*");
         EXPECT_DEATH(s.get(10), ".*");

         EXPECT_DEATH(s.prod(-1, -1), ".*");
         EXPECT_DEATH(s.prod(3, 2), ".*");
         EXPECT_DEATH(s.prod(0, 11), ".*");
         EXPECT_DEATH(s.prod(-1, 11), ".*");

         EXPECT_DEATH(s.max_right(11, [](std::string) { return true; }), ".*");
         EXPECT_DEATH(s.min_left(-1, [](std::string) { return true; }), ".*");
         EXPECT_DEATH(s.max_right(0, [](std::string) { return false; }), ".*");
     }
     */
    
    typealias seg = SegTree<Operator>
    
    @Test func testInvalid() async {
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        _ = seg(-1)
      }
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        let s = seg(10)
        _ = s.get(-1)
      }
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        let s = seg(10)
        _ = s.get(10)
      }
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        let s = seg(10)
        _ = s.prod(-1, -1)
      }
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        let s = seg(10)
        _ = s.prod(3, 2)
      }
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        let s = seg(10)
        _ = s.prod(0, 11)
      }
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        let s = seg(10)
        _ = s.prod(-1, 11)
      }
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        let s = seg(10)
        _ = s.max_right(11) { _ in true }
      }
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        let s = seg(10)
        _ = s.min_left(-1) { _ in true }
      }
      await #expect(processExitsWith: .signal(SIGTRAP)) {
        let s = seg(10)
        _ = s.max_right(0) { _ in false }
      }
    }
  }
#endif
