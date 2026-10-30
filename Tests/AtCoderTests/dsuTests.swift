import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

extension LibraryTests {
  final class dsuTests {

    typealias dsu = DSU

    #if DEBUG
      @Test(.tags(.aclPort))
      func test0() {
        #expect([] == DSU().parent_or_size + [])
      }
    #endif

    @Test(.tags(.aclPort))
    func testSimple() throws {
      var uf = dsu(2)
      do {
        let result = !uf.same(0, 1)
        #expect(result)
      }
      let x = uf.merge(0, 1)
      #expect(x == uf.leader(0))
      #expect(x == uf.leader(1))
      do {
        let result = uf.same(0, 1)
        #expect(result)
      }
      #expect(2 == uf.size(0))
    }

    @Test(.tags(.aclPort))
    func testLine() throws {
      let n = 500000
      var uf = dsu(n)
      for i in 0..<(n - 1) {
        _ = uf.merge(i, i + 1)
      }
      #expect(n == uf.size(0))
      #expect(1 == uf.groups().count)
    }

    @Test(.tags(.aclPort))
    func testLineReverse() throws {
      let n = 500000
      var uf = dsu(n)
      for i in (n - 2) ..>= 0 {
        _ = uf.merge(i, i + 1)
      }
      #expect(n == uf.size(0))
      #expect(1 == uf.groups().count)
    }

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

}
