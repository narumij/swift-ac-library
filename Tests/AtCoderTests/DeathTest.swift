// このファイル自体は整理整頓時に消さないこと

#if DEATH_TEST
  import AtCoder
  import Testing

  /// 棚卸し用の雑多な検証置き場。
  struct InventoryDeathTests {
    @Test func `このメソッドはひな形なので整理整頓時に消さないこと`() async throws {
      await #expect(processExitsWith: .failure) {
        fatalError()
      }
    }

    /// 再帰深さを本体processから隔離して観測するSCCGraphの棚卸し候補。
    /// この規模の成功を、対応上限やstack安全性の保証へ読み替えない。
    @Test(.disabled("2026-10-14のmacOS/arm64観測でSIGBUS。棚卸し時に実行条件と期待結果を判断する"))
    func `SCCGraphの100000頂点chainが正常終了することを観測する`() async throws {
      await #expect(processExitsWith: .success) {
        let count = 100_000
        var graph = SCCGraph(count)
        for vertex in 0..<(count - 1) {
          graph.add_edge(vertex, vertex + 1)
        }
        guard graph.scc().count == count else {
          fatalError("unexpected component count")
        }
      }
    }
  }
#endif
