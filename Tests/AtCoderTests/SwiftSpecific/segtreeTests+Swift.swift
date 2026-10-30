import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

extension LibraryTests.segtreeTests {
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
