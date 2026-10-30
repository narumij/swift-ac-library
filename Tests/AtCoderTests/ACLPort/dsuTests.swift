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

  }

}
