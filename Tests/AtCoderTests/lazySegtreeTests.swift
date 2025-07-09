import XCTest

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

private enum param: ___LazySegTreeOperation {
  typealias S = Int
  typealias F = Int
  nonisolated(unsafe) static let op: Op = max
  static let e: S = -1_000_000_000
  nonisolated(unsafe) static let mapping: Mapping = (+)
  nonisolated(unsafe) static let composition: Composition = (+)
  static let id: F = 0
}

enum DummyOperator: LazySegTreeOperator & SegTreeOperator {
  static func op(_ x: S,_ y: S) -> S { min(x,y) }
  static var e: S { 1 << 60 }
  static func mapping(_ x: F,_ y: S) -> S { x ?? y }
  static func composition(_ x: F,_ y: F) -> F { x ?? y }
  static var id: F { nil }
  typealias F = Int?
  typealias S = Int
}

enum DummyOperation: ___LazySegTreeOperation & ___SegTreeOperation {
  nonisolated(unsafe) static let mapping: (F, S) -> S = { $0 ?? $1 }
  nonisolated(unsafe) static let composition: (F, F) -> F = { $0 ?? $1 }
  static var id: F { nil }
  nonisolated(unsafe) static let op: (S, S) -> S = min
  static var e: S { 1 << 60 }
  typealias F = Int?
  typealias S = Int
}

private typealias starry_seg = LazySegTree<param>

final class lazySegtreeTests: XCTestCase {

  func test0() throws {
    do {
      let s = starry_seg(0)
      XCTAssertEqual(-1_000_000_000, s.all_prod())
    }
    do {
      let s = starry_seg()
      XCTAssertEqual(-1_000_000_000, s.all_prod())
    }
    do {
      let s = starry_seg(10)
      XCTAssertEqual(-1_000_000_000, s.all_prod())
    }
  }

  #if false
    func testAssign() throws {
      throw XCTSkip("代入のオーバーロードはSwiftにはない。")
      var seg0 = starry_seg()
      XCTAssertNoThrow(seg0 = starry_seg(10))
    }
  #endif

  #if false
    func testInvalid() throws {

      throw XCTSkip("Swift Packageでは実施不可")
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
          XCTAssertEqual(e, seg.prod(l, r))
        }
      }
    }
  }

  func testUsage() throws {

    var seg = starry_seg([Int](repeating: 0, count: 10))

    XCTAssertEqual(0, seg.all_prod())
    seg.apply(0, 3, 5)
    XCTAssertEqual(5, seg.all_prod())
    seg.apply(2, -10)
    XCTAssertEqual(-5, seg.prod(2, 3))
    XCTAssertEqual(0, seg.prod(2, 4))
  }
}
