import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

extension LibraryTests.dsuTests {
  @Test(.tags(.swiftSpecific))
  func testPerformance() throws {
    let n = 100000
    let pairs = (0..<n).map { _ in ((0..<n).randomElement()!, (0..<n).randomElement()!) }
    // This is an example of a performance test case.
    measureRepeated {
      // Put the code you want to measure the time of here.
      var dsu = DSU(n)
      for (i, j) in pairs {
        _ = dsu.merge(i, j)
      }
    }
  }
  @Test(.tags(.swiftSpecific))
  func testClone() throws {
    var seg0 = DSU(5)
    var seg00 = seg0.clone()
    #expect(seg00.leader(0) == 0)
    _ = seg0.merge(1, 0)
    #expect(seg00.leader(0) == 0)
    #expect(seg0.leader(0) == 1)
    _ = seg00.merge(2, 0)
    #expect(seg00.leader(0) == 2)
    #expect(seg0.leader(0) == 1)
  }
}
