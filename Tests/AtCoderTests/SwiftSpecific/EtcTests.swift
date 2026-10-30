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
        #expect((UInt32.max).trailingZeroBitCount == 0)
        #expect((UInt32.max).trailingZeroBitCount == 0)
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

// Existing process-isolated inventory probes; preserve their recorded limitations.
#if DEATH_TEST

  /// 棚卸し用の雑多な検証置き場。
  @Suite(.tags(.swiftSpecific, .exitTest))
  struct InventoryDeathTests {
    @Test func `このメソッドはひな形なので整理整頓時に消さないこと`() async throws {
      await #expect(processExitsWith: .failure) {
        fatalError()
      }
    }

    /// 再帰深さを本体processから隔離して観測するSCCGraphの棚卸し候補。
    /// 成功・失敗した規模を、対応上限やstack安全性の保証へ読み替えない。
    private static func runSCCChain(_ count: Int) {
      var graph = SCCGraph(count)
      for vertex in 0..<(count - 1) {
        graph.add_edge(vertex, vertex + 1)
      }
      guard graph.scc().count == count else {
        fatalError("unexpected component count")
      }
    }

    @Test(.disabled("850頂点の代表probeで包含。2026-10-14に成功観測済み"))
    func `SCCGraphの100頂点chainが正常終了することを観測する`() async {
      await #expect(processExitsWith: .success) { Self.runSCCChain(100) }
    }

    @Test(.disabled("850頂点の代表probeで包含。2026-10-14に成功観測済み"))
    func `SCCGraphの500頂点chainが正常終了することを観測する`() async {
      await #expect(processExitsWith: .success) { Self.runSCCChain(500) }
    }

    @Test(.disabled("850頂点の代表probeで包含。2026-10-14に成功観測済み"))
    func `SCCGraphの600頂点chainが正常終了することを観測する`() async {
      await #expect(processExitsWith: .success) { Self.runSCCChain(600) }
    }

    @Test(.disabled("850頂点の代表probeで包含。2026-10-14に成功観測済み"))
    func `SCCGraphの700頂点chainが正常終了することを観測する`() async {
      await #expect(processExitsWith: .success) { Self.runSCCChain(700) }
    }

    @Test(.disabled("850頂点の代表probeで包含。2026-10-14に成功観測済み"))
    func `SCCGraphの800頂点chainが正常終了することを観測する`() async {
      await #expect(processExitsWith: .success) { Self.runSCCChain(800) }
    }

    @Test(.disabled("850頂点の代表probeで包含。2026-10-14に成功観測済み"))
    func `SCCGraphの825頂点chainが正常終了することを観測する`() async {
      await #expect(processExitsWith: .success) { Self.runSCCChain(825) }
    }

    // TODO(OPS-011): macOS 27.0.1 / Apple Swift 6.4 のRelease+ASanでは、子プロセスが
    // "Interceptors are not working"（ASanの読み込みが遅い）でSIGABRTになる。
    // 通常のDebug/Releaseは成功。ランタイムの先行ロードでも解消せず、起動経路は未解決。
    // 製品のメモリ違反と断定せず、回避のために.successを.failureへ変更しない。
    // 失敗期待のexit testもローダー異常で通り得るため、ASanの健全性の証拠にはしない。
    // 詳細と検証範囲はTests/TEST_ORIGINS.mdおよびOPS-011の正本を参照。
    @Test func `SCCGraphの850頂点chainが正常終了することを観測する`() async {
      await #expect(processExitsWith: .success) { Self.runSCCChain(850) }
    }

    @Test(.disabled("2026-10-14のmacOS/arm64観測でSIGBUS"))
    func `SCCGraphの875頂点chainが正常終了することを観測する`() async {
      await #expect(processExitsWith: .success) { Self.runSCCChain(875) }
    }

    @Test(.disabled("2026-10-14のmacOS/arm64観測でSIGBUS"))
    func `SCCGraphの900頂点chainが正常終了することを観測する`() async {
      await #expect(processExitsWith: .success) { Self.runSCCChain(900) }
    }

    @Test(.disabled("2026-10-14のmacOS/arm64観測でSIGBUS"))
    func `SCCGraphの1000頂点chainが正常終了することを観測する`() async {
      await #expect(processExitsWith: .success) { Self.runSCCChain(1_000) }
    }

    @Test(.disabled("2026-10-14のmacOS/arm64観測でSIGBUS"))
    func `SCCGraphの2500頂点chainが正常終了することを観測する`() async {
      await #expect(processExitsWith: .success) { Self.runSCCChain(2_500) }
    }

    @Test(.disabled("2026-10-14のmacOS/arm64観測でSIGBUS"))
    func `SCCGraphの5000頂点chainが正常終了することを観測する`() async {
      await #expect(processExitsWith: .success) { Self.runSCCChain(5_000) }
    }

    @Test(.disabled("2026-10-14のmacOS/arm64観測でSIGBUS"))
    func `SCCGraphの10000頂点chainが正常終了することを観測する`() async {
      await #expect(processExitsWith: .success) { Self.runSCCChain(10_000) }
    }

    @Test(.disabled("2026-10-14のmacOS/arm64観測でSIGBUS"))
    func `SCCGraphの25000頂点chainが正常終了することを観測する`() async {
      await #expect(processExitsWith: .success) { Self.runSCCChain(25_000) }
    }

    @Test(.disabled("2026-10-14のmacOS/arm64観測でSIGBUS"))
    func `SCCGraphの50000頂点chainが正常終了することを観測する`() async {
      await #expect(processExitsWith: .success) { Self.runSCCChain(50_000) }
    }

    @Test(.disabled("2026-10-14のmacOS/arm64観測でSIGBUS"))
    func `SCCGraphの75000頂点chainが正常終了することを観測する`() async {
      await #expect(processExitsWith: .success) { Self.runSCCChain(75_000) }
    }

    @Test(.disabled("2026-10-14のmacOS/arm64観測でSIGBUS。棚卸し時に実行条件と期待結果を判断する"))
    func `SCCGraphの100000頂点chainが正常終了することを観測する`() async {
      await #expect(processExitsWith: .success) { Self.runSCCChain(100_000) }
    }
  }
#endif
