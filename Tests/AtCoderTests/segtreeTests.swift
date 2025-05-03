import AtCoder
import XCTest

private func op(a: String, b: String) -> String {
  assert(a == "$" || b == "$" || a <= b)
  if a == "$" { return b }
  if b == "$" { return a }
  return a + b
}

private let e: String = "$"

private enum Operator: SegTreeOperation {
  typealias S = String
  nonisolated(unsafe) static let op: Op = AtCoderTests.op
  static let e: S = AtCoderTests.e
}

private typealias segtree = SegTree<Operator>

extension segtree_naive where S == String {
  fileprivate init(_ n: Int) {
    self.init(op: AtCoderTests.op, e: AtCoderTests.e, n)
  }
}

final class segtreeTests: XCTestCase {

  func test0() {
    XCTAssertEqual("$", SegTree<Operator>(0).all_prod())
    XCTAssertEqual("$", SegTree<Operator>().all_prod())
  }

  func testInvalid() throws {
    throw XCTSkip("Swift Packageでは実施不可")
    XCTAssertThrowsError(segtree_naive(-1))
    var s = SegTree<Operator>(10)
    XCTAssertThrowsError(s.get(-1))
    XCTAssertThrowsError(s.get(10))
    XCTAssertThrowsError(s.prod(-1, -1))
    XCTAssertThrowsError(s.prod(3, 2))
    XCTAssertThrowsError(s.prod(0, 11))
    XCTAssertThrowsError(s.prod(-1, 11))
    XCTAssertThrowsError(s.max_right(11, { _ in true }))
    XCTAssertThrowsError(s.min_left(-1, { _ in true }))
    XCTAssertThrowsError(s.max_right(0, { _ in false }))
  }

  func testOne() throws {
    var s = segtree(1)
    XCTAssertEqual("$", s.all_prod())
    XCTAssertEqual("$", s.get(0))
    XCTAssertEqual("$", s.prod(0, 1))
    s.set(0, "dummy")
    XCTAssertEqual("dummy", s.get(0))
    XCTAssertEqual("$", s.prod(0, 0))
    XCTAssertEqual("dummy", s.prod(0, 1))
    XCTAssertEqual("$", s.prod(1, 1))
  }

  func testCompareNaive() throws {
    var y: String = ""
    func leq_y(_ x: String) -> Bool { x.count <= y.count }

    for n in 0..<30 {
      var seg0 = segtree_naive(n)
      var seg1 = segtree(n)
      for i in 0..<n {
        var s = ""
        s.append(String(["a", Character(UnicodeScalar(i)!)]))
        seg0.set(i, s)
        seg1.set(i, s)
      }

      for l in 0 ..<= n {
        for r in l ..<= n {
          XCTAssertEqual(seg0.prod(l, r), seg1.prod(l, r))
        }
      }

      for l in 0 ..<= n {
        for r in l ..<= n {
          y = seg1.prod(l, r)
          XCTAssertEqual(seg0.max_right(l, leq_y), seg1.max_right(l, leq_y))
          XCTAssertEqual(
            seg0.max_right(l, leq_y),
            seg1.max_right(
              l,
              { x in
                return x.count <= y.count
              }))
        }
      }

      for r in 0 ..<= n {
        for l in 0 ..<= r {
          y = seg1.prod(l, r)
          XCTAssertEqual(seg0.min_left(r, leq_y), seg1.min_left(r, leq_y))
          XCTAssertEqual(
            seg0.min_left(r, leq_y),
            seg1.min_left(
              r,
              { x in
                return x.count <= y.count
              }))
        }
      }
    }
  }

  func testCopyOnWrite() throws {
    #if DISABLE_COPY_ON_WRITE
      throw XCTSkip("コピーオンライト不活性のため")
    #endif
    var seg0 = SegTree<Operator>(10)
    var seg00 = seg0
    XCTAssertEqual(seg00.all_prod(), "$")
    seg0.set(0, "a")
    XCTAssertEqual(seg00.all_prod(), "$")
    XCTAssertEqual(seg0.all_prod(), "a")
    seg00.set(0, "b")
    XCTAssertEqual(seg00.all_prod(), "b")
    XCTAssertEqual(seg0.all_prod(), "a")
  }
}
