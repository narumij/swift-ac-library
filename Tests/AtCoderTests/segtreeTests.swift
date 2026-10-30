import AtCoder
import Testing

private func op(a: String, b: String) -> String {
  assert(a == "$" || b == "$" || a <= b)
  if a == "$" { return b }
  if b == "$" { return a }
  return a + b
}

private let e: String = "$"

enum Operator: SegTreeOperation {
  static let op: Op = AtCoderTests.op
  static let e: String = AtCoderTests.e
}

private typealias segtree = SegTree<Operator>

extension segtree_naive where S == String {
  fileprivate init(_ n: Int) {
    self.init(op: AtCoderTests.op, e: AtCoderTests.e, n)
  }
}

extension LibraryTests {
  final class segtreeTests {

    @Test(.tags(.aclPort))
    func test0() {
      #expect("$" == SegTree<Operator>(0).all_prod())
      #expect("$" == SegTree<Operator>().all_prod())
    }

    // Assertions trap rather than throw; segTreeDeathTests executes these cases.
    @Test(.disabled("Covered by segTreeDeathTests"), .tags(.aclPort))
    func testInvalid() throws {
      #if false
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
      #endif
    }

    @Test(.tags(.aclPort))
    func testOne() throws {
      var s = segtree(1)
      #expect("$" == s.all_prod())
      #expect("$" == s.get(0))
      #expect("$" == s.prod(0, 1))
      s.set(0, "dummy")
      #expect("dummy" == s.get(0))
      #expect("$" == s.prod(0, 0))
      #expect("dummy" == s.prod(0, 1))
      #expect("$" == s.prod(1, 1))
    }

    @Test(.tags(.aclPort))
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
            #expect(seg0.prod(l, r) == seg1.prod(l, r))
          }
        }

        for l in 0 ..<= n {
          for r in l ..<= n {
            y = seg1.prod(l, r)
            #expect(seg0.max_right(l, leq_y) == seg1.max_right(l, leq_y))
            #expect(
              seg0.max_right(l, leq_y)
                == seg1.max_right(
                  l,
                  { x in
                    return x.count <= y.count
                  }))
          }
        }

        for r in 0 ..<= n {
          for l in 0 ..<= r {
            y = seg1.prod(l, r)
            #expect(seg0.min_left(r, leq_y) == seg1.min_left(r, leq_y))
            #expect(
              seg0.min_left(r, leq_y)
                == seg1.min_left(
                  r,
                  { x in
                    return x.count <= y.count
                  }))
          }
        }
      }
    }

    @Test(.tags(.swiftSpecific))
    func testClone() throws {
      var seg0 = SegTree<Operator>(10)
      var seg00 = seg0.clone()
      #expect(seg00.all_prod() == "$")
      seg0.set(0, "a")
      #expect(seg00.all_prod() == "$")
      #expect(seg0.all_prod() == "a")
      seg00.set(0, "b")
      #expect(seg00.all_prod() == "b")
      #expect(seg0.all_prod() == "a")
    }

    @Test(.tags(.swiftSpecific))
    func test0_0() {
      #expect("$" == SegTree<Operator>(0) { Operator.e }.all_prod())
    }

    @Test(.tags(.swiftSpecific))
    func testOne_0() throws {
      var s = segtree(1) { Operator.e }
      #expect("$" == s.all_prod())
      #expect("$" == s.get(0))
      #expect("$" == s.prod(0, 1))
      s.set(0, "dummy")
      #expect("dummy" == s.get(0))
      #expect("$" == s.prod(0, 0))
      #expect("dummy" == s.prod(0, 1))
      #expect("$" == s.prod(1, 1))
    }

    @Test(.tags(.swiftSpecific))
    func testCompareNaive_0() throws {
      var y: String = ""
      func leq_y(_ x: String) -> Bool { x.count <= y.count }

      for n in 0..<30 {
        var seg0 = segtree_naive(n)
        var seg1 = segtree(n) { _ in Operator.e }
        for i in 0..<n {
          var s = ""
          s.append(String(["a", Character(UnicodeScalar(i)!)]))
          seg0.set(i, s)
          seg1.set(i, s)
        }

        for l in 0 ..<= n {
          for r in l ..<= n {
            #expect(seg0.prod(l, r) == seg1.prod(l, r))
          }
        }

        for l in 0 ..<= n {
          for r in l ..<= n {
            y = seg1.prod(l, r)
            #expect(seg0.max_right(l, leq_y) == seg1.max_right(l, leq_y))
            #expect(
              seg0.max_right(l, leq_y)
                == seg1.max_right(
                  l,
                  { x in
                    return x.count <= y.count
                  }))
          }
        }

        for r in 0 ..<= n {
          for l in 0 ..<= r {
            y = seg1.prod(l, r)
            #expect(seg0.min_left(r, leq_y) == seg1.min_left(r, leq_y))
            #expect(
              seg0.min_left(r, leq_y)
                == seg1.min_left(
                  r,
                  { x in
                    return x.count <= y.count
                  }))
          }
        }
      }
    }
  }

}
