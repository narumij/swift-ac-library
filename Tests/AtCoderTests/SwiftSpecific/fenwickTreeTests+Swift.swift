import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

extension LibraryTests.fenwickTreeTests {
  @Test(.tags(.swiftSpecific))
  func testInt() throws {
    var fw = fenwick_tree<Int>(20)
    for i in 0..<20 {
      fw.add(i, i)
    }
    for l in 0...20 {
      for r in l...20 {
        var sum = 0
        for i in l..<r {
          sum += i
        }
        #expect(sum == fw.sum(l, r))
      }
    }
  }
  #if DEBUG
    @Test(.tags(.swiftSpecific))
    func testSum() throws {
      var fw = fenwick_tree<Int>(20)
      for i in 0..<20 {
        fw.add(i, i)
      }
      for l in 0...20 {
        var sum = 0
        for i in 0..<l {
          sum += i
        }
        #expect(sum == Int(fw.sum(l)))
      }
    }
  #endif
  @Test(.tags(.swiftSpecific))
  func testHandleUnsigned() throws {
    #expect(4_294_967_295 == CInt(-1).unsigned)
    #expect(18_446_744_073_709_551_615 == CLongLong(-1).unsigned)
    #expect(18_446_744_073_709_551_615 == Int(-1).unsigned)
  }
}
