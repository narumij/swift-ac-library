import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

enum lazySegtreeTests_param: LazySegTreeOperation {
  typealias S = Int
  typealias F = Int
  static let op: Op = max
  static let e: S = -1_000_000_000
  static let mapping: Mapping = (+)
  static let composition: Composition = (+)
  static let id: F = 0
}

enum DummyOperator: LazySegTreeOperator & SegTreeOperator {
  static func op(_ x: S, _ y: S) -> S { min(x, y) }
  static var e: S { 1 << 60 }
  static func mapping(_ x: F, _ y: S) -> S { x ?? y }
  static func composition(_ x: F, _ y: F) -> F { x ?? y }
  static var id: F { nil }
  typealias F = Int?
  typealias S = Int
}

enum DummyOperation: LazySegTreeOperation & SegTreeOperation {
  static let mapping: @Sendable (F, S) -> S = { $0 ?? $1 }
  static let composition: @Sendable (F, F) -> F = { $0 ?? $1 }
  static var id: F { nil }
  static let op: @Sendable (S, S) -> S = min
  static var e: S { 1 << 60 }
  typealias F = Int?
  typealias S = Int
}

typealias starry_seg = LazySegTree<lazySegtreeTests_param>

extension LibraryTests {
  final class lazySegtreeTests {

    @Test(.tags(.aclPort))
    func test0() throws {
      do {
        let s = starry_seg(0)
        #expect(-1_000_000_000 == s.all_prod())
      }
      do {
        let s = starry_seg()
        #expect(-1_000_000_000 == s.all_prod())
      }
      do {
        let s = starry_seg(10)
        #expect(-1_000_000_000 == s.all_prod())
      }
    }

    #if false
      @Test(.tags(.aclPort))
      func testAssign() throws {
        return  // Previously skipped: "代入のオーバーロードはSwiftにはない。"
        var seg0 = starry_seg()
        XCTAssertNoThrow(seg0 = starry_seg(10))
      }
    #endif

    #if false
      @Test(.tags(.aclPort))
      func testInvalid() throws {

        return  // Previously skipped: "Swift Testingで実施"
          XCTAssertThrowsError(starry_seg(-1))

        var s = starry_seg(10)

        XCTAssertThrowsError(s.get(-1))
        XCTAssertThrowsError(s.get(10))

        XCTAssertThrowsError(s.prod(-1, -1))

        XCTAssertThrowsError(s.prod(3, 2))
        XCTAssertThrowsError(s.prod(0, 11))
        XCTAssertThrowsError(s.prod(-1, 11))
      }
    #endif

    @Test(.tags(.aclPort))
    func testNaiveProd() throws {
      for n in 0...50 {
        var seg = starry_seg(n)
        var p = [Int](repeating: 0, count: n)
        for i in 0..<n {
          p[i] = (i * i + 100) % 31
          seg.set(i, p[i])
        }
        for l in 0 ..<= n {
          for r in l ..<= n {
            var e = -1_000_000_000
            for i in l..<r {
              e = max(e, p[i])
            }
            #expect(e == seg.prod(l, r))
          }
        }
      }
    }

    @Test(.tags(.aclPort))
    func testUsage() throws {

      var seg = starry_seg([Int](repeating: 0, count: 10))

      #expect(0 == seg.all_prod())
      seg.apply(0, 3, 5)
      #expect(5 == seg.all_prod())
      seg.apply(2, -10)
      #expect(-5 == seg.prod(2, 3))
      #expect(0 == seg.prod(2, 4))
    }

  }

}

// Invalid-input exit tests.
#if DEATH_TEST && DEBUG

  @Suite(.tags(.exitTest))
  struct lazySegTreeDeathTests {

    typealias seg = SegTree<Operator>

    @Test(.tags(.aclPort)) func testInvalid() async {
      //  EXPECT_THROW(auto s = seg(-1), std::exception);
      await #expect(processExitsWith: .failure) {
        _ = starry_seg(-1)
      }
      //  EXPECT_DEATH(s.get(-1), ".*");
      await #expect(processExitsWith: .failure) {
        var s = starry_seg(10)
        _ = s.get(-1)
      }
      //  EXPECT_DEATH(s.get(10), ".*");
      await #expect(processExitsWith: .failure) {
        var s = starry_seg(10)
        _ = s.get(10)
      }
      //  EXPECT_DEATH(s.prod(-1, -1), ".*");
      await #expect(processExitsWith: .failure) {
        var s = starry_seg(10)
        _ = s.prod(-1, -1)
      }
      //  EXPECT_DEATH(s.prod(3, 2), ".*");
      await #expect(processExitsWith: .failure) {
        var s = starry_seg(10)
        _ = s.prod(3, 2)
      }
      //  EXPECT_DEATH(s.prod(0, 11), ".*");
      await #expect(processExitsWith: .failure) {
        var s = starry_seg(10)
        _ = s.prod(0, 11)
      }
      //  EXPECT_DEATH(s.prod(-1, 11), ".*");
      await #expect(processExitsWith: .failure) {
        var s = starry_seg(10)
        _ = s.prod(-1, 11)
      }
    }
  }
#endif
