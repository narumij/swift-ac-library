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

  struct modintDeathTests {

    @usableFromInline
    enum mod_11: static_mod_value { static let mod: mod_value = 11 }

    @Test(.tags(.aclPort)) func testStaticUsage() async {
      //  EXPECT_DEATH(mint(3).pow(-1), ".*");
      await #expect(processExitsWith: .failure) {
        typealias mint = static_modint<mod_11>
        _ = mint(3).pow(-1)
      }
    }

    @Test(.tags(.aclPort)) func testDynamicUsage() async {
      // EXPECT_DEATH(mint(3).pow(-1), ".*");
      await #expect(processExitsWith: .failure) {
        typealias mint = modint
        _ = mint(3).pow(-1)
      }
    }
  }
#endif
