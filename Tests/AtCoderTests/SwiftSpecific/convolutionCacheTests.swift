import AtCoder
import Testing

private enum KnownAlias: static_mod { static let umod: UInt = 998_244_353 }
private enum OtherAliasA: static_mod { static let umod: UInt = 1_004_535_809 }
private enum OtherAliasB: static_mod { static let umod: UInt = 1_004_535_809 }

extension LibraryTests {
  final class convolutionCacheTests {
    @Test(.tags(.swiftSpecific))
    func testDistinctTypesWithEqualModulus() {
      let input = [Int](repeating: 1, count: 61)
      let expected = (0..<121).map { min($0 + 1, 121 - $0) }
      // 既定の法と同値の別型、および汎用キャッシュで同値の別型を順に使う。
      #expect(convolution(KnownAlias.self, input, input) == expected)
      #expect(convolution(OtherAliasA.self, input, input) == expected)
      #expect(convolution(OtherAliasB.self, input, input) == expected)
      #expect(convolution(OtherAliasA.self, input, input) == expected)
      #expect(convolution_ll(input, input) == expected)
    }
  }

}
