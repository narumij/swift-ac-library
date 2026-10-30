import Testing

@Suite(.tags(.swiftSpecific))
final class extraFenwickTreeTests {

  @Test
  func testEmpty() throws {
    let tree = FenwickTree<Int>()

    #expect(tree.sum(0, 0) == 0)
  }

  @Test
  func testRangeSums() throws {
    var tree = FenwickTree<Int>(8)
    var values = [Int](repeating: 0, count: 8)

    for (index, value) in [3, -1, 4, 1, -5, 9, 2, 6].enumerated() {
      values[index] = value
      tree.add(index, value)
    }

    for l in 0...values.count {
      for r in l...values.count {
        #expect(tree.sum(l, r) == values[l..<r].reduce(0, +))
      }
    }
  }

  @Test
  func testUnsignedWrapping() throws {
    var tree = FenwickTree<UInt8>(4)

    tree.add(0, 250)
    tree.add(1, 10)
    tree.add(2, 20)

    #expect(tree.sum(0, 1) == 250)
    #expect(tree.sum(0, 2) == 4)
    #expect(tree.sum(0, 3) == 24)
    #expect(tree.sum(1, 3) == 30)
  }

  @Test
  func testSignedWrapping() throws {
    var tree = FenwickTree<Int8>(3)

    tree.add(0, 120)
    tree.add(1, 20)
    tree.add(2, -5)

    #expect(tree.sum(0, 1) == 120)
    #expect(tree.sum(0, 2) == -116)
    #expect(tree.sum(1, 3) == 15)
  }

  @Test
  func testRepeatedPointUpdatesMatchNaiveRangeSums() throws {
    var tree = FenwickTree<Int>(6)
    var values = [Int](repeating: 0, count: 6)
    let updates = [
      (0, 5),
      (3, -2),
      (0, 7),
      (5, 11),
      (3, 4),
      (2, -6),
    ]

    for (index, value) in updates {
      values[index] += value
      tree.add(index, value)

      for l in 0...values.count {
        for r in l...values.count {
          #expect(tree.sum(l, r) == values[l..<r].reduce(0, +))
        }
      }
    }
  }

  @Test
  func testCloneIsIndependent() throws {
    var original = FenwickTree<Int>(4)
    original.add(0, 2)
    original.add(1, 3)

    var cloned = original.clone()
    original.add(2, 5)
    cloned.add(3, 7)
    cloned.add(1, -10)

    #expect(original.sum(0, 4) == 10)
    #expect(cloned.sum(0, 4) == 2)
    #expect(original.sum(1, 2) == 3)
    #expect(cloned.sum(1, 2) == -7)
    #expect(original.sum(3, 4) == 0)
    #expect(cloned.sum(2, 3) == 0)
  }
}
