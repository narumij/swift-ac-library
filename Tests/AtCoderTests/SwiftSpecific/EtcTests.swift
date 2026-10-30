// このファイル自体は整理整頓時に消さないこと
import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

/// 棚卸し用の雑多な検証置き場。
extension LibraryTests {
  final class EtcTests {

    #if DEBUG
      /// 本家bit testのunsigned int最大値に対し、現行移植testがInt32最大値を使う差異の棚卸し候補。
      /// deprecated wrapper自体の移植境界を観測するため、このtestもdeprecated contextに置く。
      @available(*, deprecated, message: "Inventory probe for deprecated ACL-compatible wrappers")
      @Test(.tags(.swiftSpecific))
      func testInventoryBitCountrZeroAtUInt32Maximum() {
        #expect(_Internal.countr_zero(UInt32.max) == 0)
        #expect(_Internal.countr_zero_constexpr(UInt32.max) == 0)
      }
    #endif

    /// FenwickTreeのstorage初期化で使われる非自明なgeneric integer literalの棚卸し候補。
    /// 製品契約の確定後、この言語挙動を実装不変条件として残すか判断する。
    @Test(.tags(.swiftSpecific))
    func testInventoryFenwickGenericNegativeOneInitializesUnsignedStorageToZero() {
      func value<U: FixedWidthInteger & UnsignedInteger>(_: U.Type) -> U { -1 }

      #expect(value(UInt32.self) == .zero)
      #expect(value(UInt64.self) == .zero)
      #expect(value(UInt.self) == .zero)

      if #available(macOS 15.0, *) {
        #expect(value(UInt128.self) == .zero)
      }
    }

    /// SCCGraphが呼出しごとに構築するCSRと、呼出し後の再利用可否の棚卸し候補。
    /// 返却順や再利用を公開契約に含めるかは、この観測とは別に判断する。
    @Test(.tags(.swiftSpecific))
    func testInventorySCCRepeatedEvaluationAndMutationAfterEvaluation() {
      var graph = SCCGraph(4)
      graph.add_edge(0, 1)
      graph.add_edge(1, 0)
      graph.add_edge(2, 3)

      let first = graph.scc()
      #expect(graph.scc() == first)

      graph.add_edge(3, 2)
      let afterMutation = graph.scc()
      #expect(afterMutation.count == 2)
      #expect(afterMutation.contains([0, 1]))
      #expect(afterMutation.contains([2, 3]))
    }

    /// Dynamic ModIntのmodulus変更前に生成した値が、変更後の演算でどう扱われるかの棚卸し候補。
    /// 現在の挙動を望ましい公開契約として採用するtestではない。
    @Test(.tags(.swiftSpecific))
    func testInventoryDynamicModIntValueAcrossModulusChange() {
      defer { mod_dynamic.reset() }

      modint.set_mod(7)
      let value = modint(6)

      modint.set_mod(5)
      #expect(value.val == 6)
      #expect((value + modint(0)).val == 1)
    }
  }

}
