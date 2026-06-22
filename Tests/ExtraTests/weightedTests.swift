import XCTest

final class weightedDSUTests: XCTestCase {

  func testWeightedDifference() throws {
    var dsu = DSU(4)

    _ = dsu.merge(0, 1, 3)
    _ = dsu.merge(1, 2, 4)

    XCTAssertEqual(dsu.same(0, 1).0, true)
    XCTAssertEqual(dsu.same(0, 1).1, 3)
    XCTAssertEqual(dsu.same(1, 2).1, 4)
    XCTAssertEqual(dsu.same(0, 2).1, 7)
    XCTAssertEqual(dsu.same(2, 0).1, -7)
    XCTAssertEqual(dsu.same(0, 3).0, false)
  }

  func testMergeKeepsDifferenceWhenRootIsSwapped() throws {
    var dsu = DSU(3)

    _ = dsu.merge(1, 2, 10)
    _ = dsu.merge(0, 2, 5)

    XCTAssertEqual(dsu.same(0, 2).0, true)
    XCTAssertEqual(dsu.same(0, 2).1, 5)
    XCTAssertEqual(dsu.same(0, 1).1, -5)
    XCTAssertEqual(dsu.same(1, 2).1, 10)
    XCTAssertEqual(dsu.size(0), 3)
  }

  func testMergeAlreadyConnectedKeepsExistingDifferences() throws {
    var dsu = DSU(4)

    _ = dsu.merge(0, 1, 2)
    _ = dsu.merge(1, 2, 3)
    let root = dsu.merge(0, 2, 5)

    XCTAssertEqual(root, dsu.leader(0).0)
    XCTAssertEqual(dsu.same(0, 2).0, true)
    XCTAssertEqual(dsu.same(0, 2).1, 5)
    XCTAssertEqual(dsu.same(2, 0).0, true)
    XCTAssertEqual(dsu.same(2, 0).1, -5)
    XCTAssertEqual(dsu.same(0, 3).0, false)
  }

  func testPathCompressionPreservesWeights() throws {
    var dsu = DSU(6)

    _ = dsu.merge(0, 1, 1)
    _ = dsu.merge(1, 2, 2)
    _ = dsu.merge(2, 3, 3)
    _ = dsu.merge(3, 4, 4)
    _ = dsu.merge(4, 5, 5)

    XCTAssertEqual(dsu.leader(5).1, 15)
    XCTAssertEqual(dsu.same(0, 5).0, true)
    XCTAssertEqual(dsu.same(0, 5).1, 15)
    XCTAssertEqual(dsu.same(5, 1).0, true)
    XCTAssertEqual(dsu.same(5, 1).1, -14)
    XCTAssertEqual(dsu.same(2, 4).0, true)
    XCTAssertEqual(dsu.same(2, 4).1, 7)
  }

  func testGroups() throws {
    var dsu = DSU(5)

    _ = dsu.merge(0, 1, 2)
    _ = dsu.merge(3, 4, -1)
    _ = dsu.leader(1)
    _ = dsu.leader(4)

    let groups = dsu.groups().map { $0.sorted() }.sorted { $0.first! < $1.first! }
    XCTAssertEqual(groups, [[0, 1], [2], [3, 4]])
  }

  func testCloneIsIndependent() throws {
    var original = DSU(3)
    _ = original.merge(0, 1, 8)

    var cloned = original.clone()
    _ = original.merge(1, 2, 6)

    XCTAssertEqual(cloned.same(0, 1).0, true)
    XCTAssertEqual(cloned.same(0, 1).1, 8)
    XCTAssertEqual(cloned.same(0, 2).0, false)

    _ = cloned.merge(1, 2, -4)
    XCTAssertEqual(original.same(0, 2).1, 14)
    XCTAssertEqual(cloned.same(0, 2).1, 4)
  }
}
