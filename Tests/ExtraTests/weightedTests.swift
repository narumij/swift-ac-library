import Testing

@Suite(.tags(.swiftSpecific))
final class weightedDSUTests {

  @Test
  func testWeightedDifference() throws {
    var dsu = DSU(4)

    _ = dsu.merge(0, 1, 3)
    _ = dsu.merge(1, 2, 4)

    #expect(dsu.same(0, 1).0 == true)
    #expect(dsu.same(0, 1).1 == 3)
    #expect(dsu.same(1, 2).1 == 4)
    #expect(dsu.same(0, 2).1 == 7)
    #expect(dsu.same(2, 0).1 == -7)
    #expect(dsu.same(0, 3).0 == false)
  }

  @Test
  func testMergeKeepsDifferenceWhenRootIsSwapped() throws {
    var dsu = DSU(3)

    _ = dsu.merge(1, 2, 10)
    _ = dsu.merge(0, 2, 5)

    #expect(dsu.same(0, 2).0 == true)
    #expect(dsu.same(0, 2).1 == 5)
    #expect(dsu.same(0, 1).1 == -5)
    #expect(dsu.same(1, 2).1 == 10)
    #expect(dsu.size(0) == 3)
  }

  @Test
  func testMergeAlreadyConnectedKeepsExistingDifferences() throws {
    var dsu = DSU(4)

    _ = dsu.merge(0, 1, 2)
    _ = dsu.merge(1, 2, 3)
    let root = dsu.merge(0, 2, 5)

    #expect(root == dsu.leader(0).0)
    #expect(dsu.same(0, 2).0 == true)
    #expect(dsu.same(0, 2).1 == 5)
    #expect(dsu.same(2, 0).0 == true)
    #expect(dsu.same(2, 0).1 == -5)
    #expect(dsu.same(0, 3).0 == false)
  }

  @Test
  func testPathCompressionPreservesWeights() throws {
    var dsu = DSU(6)

    _ = dsu.merge(0, 1, 1)
    _ = dsu.merge(1, 2, 2)
    _ = dsu.merge(2, 3, 3)
    _ = dsu.merge(3, 4, 4)
    _ = dsu.merge(4, 5, 5)

    #expect(dsu.leader(5).1 == 15)
    #expect(dsu.same(0, 5).0 == true)
    #expect(dsu.same(0, 5).1 == 15)
    #expect(dsu.same(5, 1).0 == true)
    #expect(dsu.same(5, 1).1 == -14)
    #expect(dsu.same(2, 4).0 == true)
    #expect(dsu.same(2, 4).1 == 7)
  }

  @Test
  func testGroups() throws {
    var dsu = DSU(5)

    _ = dsu.merge(0, 1, 2)
    _ = dsu.merge(3, 4, -1)
    _ = dsu.leader(1)
    _ = dsu.leader(4)

    let groups = dsu.groups().map { $0.sorted() }.sorted { $0.first! < $1.first! }
    #expect(groups == [[0, 1], [2], [3, 4]])
  }

  @Test
  func testCloneIsIndependent() throws {
    var original = DSU(3)
    _ = original.merge(0, 1, 8)

    var cloned = original.clone()
    _ = original.merge(1, 2, 6)

    #expect(cloned.same(0, 1).0 == true)
    #expect(cloned.same(0, 1).1 == 8)
    #expect(cloned.same(0, 2).0 == false)

    _ = cloned.merge(1, 2, -4)
    #expect(original.same(0, 2).1 == 14)
    #expect(cloned.same(0, 2).1 == 4)
  }
}
