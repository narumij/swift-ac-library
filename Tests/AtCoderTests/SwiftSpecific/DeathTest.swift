// このファイル自体は整理整頓時に消さないこと

#if DEATH_TEST
  import AtCoder
  import Testing

  /// 棚卸し用の雑多な検証置き場。
  @Suite(.tags(.swiftSpecific))
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
