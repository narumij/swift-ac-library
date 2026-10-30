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

typealias segtree = SegTree<Operator>

extension segtree_naive where S == String {
  init(_ n: Int) {
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

  }

}

// Invalid-input exit tests.
#if DEATH_TEST && DEBUG

  @Suite(.tags(.exitTest))
  struct segTreeDeathTests {

    typealias seg = SegTree<Operator>

    // A sanitizer runtime startup failure must not count as an expected trap.
    @Test(.tags(.swiftSpecific)) func testChildProcessStartup() async {
      await #expect(processExitsWith: .success) {
        let s = seg(10)
        _ = s.get(0)
      }
    }

    @Test(.tags(.aclPort)) func testInvalid() async {
      //  EXPECT_THROW(auto s = seg(-1), std::exception);
      await #expect(processExitsWith: .failure) {
        _ = seg(-1)
      }
      //  EXPECT_DEATH(s.get(-1), ".*");
      await #expect(processExitsWith: .failure) {
        let s = seg(10)
        _ = s.get(-1)
      }
      //  EXPECT_DEATH(s.get(10), ".*");
      await #expect(processExitsWith: .failure) {
        let s = seg(10)
        _ = s.get(10)
      }
      //  EXPECT_DEATH(s.prod(-1, -1), ".*");
      await #expect(processExitsWith: .failure) {
        let s = seg(10)
        _ = s.prod(-1, -1)
      }
      //  EXPECT_DEATH(s.prod(3, 2), ".*");
      await #expect(processExitsWith: .failure) {
        let s = seg(10)
        _ = s.prod(3, 2)
      }
      //  EXPECT_DEATH(s.prod(0, 11), ".*");
      await #expect(processExitsWith: .failure) {
        let s = seg(10)
        _ = s.prod(0, 11)
      }
      //  EXPECT_DEATH(s.prod(-1, 11), ".*");
      await #expect(processExitsWith: .failure) {
        let s = seg(10)
        _ = s.prod(-1, 11)
      }
      //  EXPECT_DEATH(s.max_right(11, [](std::string) { return true; }), ".*");
      await #expect(processExitsWith: .failure) {
        let s = seg(10)
        _ = s.max_right(11) { _ in true }
      }
      //  EXPECT_DEATH(s.min_left(-1, [](std::string) { return true; }), ".*");
      await #expect(processExitsWith: .failure) {
        let s = seg(10)
        _ = s.min_left(-1) { _ in true }
      }
      //  EXPECT_DEATH(s.max_right(0, [](std::string) { return false; }), ".*");
      await #expect(processExitsWith: .failure) {
        let s = seg(10)
        _ = s.max_right(0) { _ in false }
      }
    }
  }
#endif
