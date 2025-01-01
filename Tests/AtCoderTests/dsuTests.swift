import XCTest

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

final class dsuTests: XCTestCase {

  typealias dsu = DSU

  #if DEBUG
    func test0() {
//      XCTAssertEqual([], dsu().parent_or_size)
    }
  #endif

  func testSimple() throws {
    var uf = dsu(2)
    XCTAssertFalse(uf.same(0, 1))
    let x = uf.merge(0, 1)
    XCTAssertEqual(x, uf.leader(0))
    XCTAssertEqual(x, uf.leader(1))
    XCTAssertTrue(uf.same(0, 1))
    XCTAssertEqual(2, uf.size(0))
  }

  func testLine() throws {
    let n = 500000
    var uf = dsu(n)
    for i in 0..<(n - 1) {
      _ = uf.merge(i, i + 1)
    }
    XCTAssertEqual(n, uf.size(0))
    XCTAssertEqual(1, uf.groups().count)
  }

  func testLineReverse() throws {
    let n = 500000
    var uf = dsu(n)
    for i in (n - 2) ..>= 0 {
      _ = uf.merge(i, i + 1)
    }
    XCTAssertEqual(n, uf.size(0))
    XCTAssertEqual(1, uf.groups().count)
  }

  func testPerformance() throws {
    let n = 100000
    let pairs = (0..<n).map { _ in ((0..<n).randomElement()!, (0..<n).randomElement()!) }
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
      var dsu = DSU(n)
      for (i, j) in pairs {
        dsu.merge(i, j)
      }
    }
  }
}
