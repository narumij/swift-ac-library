import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

extension LibraryTests.lazySegtreeTests {
  @Test(.tags(.swiftSpecific))
  func test0_0() throws {
    do {
      let s = starry_seg(0) { lazySegtreeTests_param.e }
      #expect(-1_000_000_000 == s.all_prod())
    }
    do {
      let s = starry_seg()
      #expect(-1_000_000_000 == s.all_prod())
    }
    do {
      let s = starry_seg(10) { lazySegtreeTests_param.e }
      #expect(-1_000_000_000 == s.all_prod())
    }
  }
  @Test(.tags(.swiftSpecific))
  func testNaiveProd_0() throws {
    for n in 0...50 {
      var seg = starry_seg(n) { lazySegtreeTests_param.e }
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
  @Test(.tags(.swiftSpecific))
  func testUsage_0() throws {

    var seg = starry_seg(10) { _ in 0 }

    #expect(0 == seg.all_prod())
    seg.apply(0, 3, 5)
    #expect(5 == seg.all_prod())
    seg.apply(2, -10)
    #expect(-5 == seg.prod(2, 3))
    #expect(0 == seg.prod(2, 4))
  }
}
