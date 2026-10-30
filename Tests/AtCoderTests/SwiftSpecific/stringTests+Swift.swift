import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

extension LibraryTests.stringTests {
  @Test(.tags(.swiftSpecific))
  func testSaNaive() throws {
    let s = [0, 0, 0, 0, 0]
    let saResult: [Int] = [4, 3, 2, 1, 0]
    let lcpResult: [Int] = [1, 2, 3, 4]
    #expect(saResult == sa_naive(s))
    #expect(lcpResult == lcp_naive(s, saResult))
  }
  @Test(.tags(.swiftSpecific))
  func testSaNaive2() throws {
    let s = [1, 2, 3, 4, 5]
    let saResult: [Int] = [0, 1, 2, 3, 4]
    let lcpResult: [Int] = [0, 0, 0, 0]
    #expect(saResult == sa_naive(s))
    #expect(lcpResult == lcp_naive(s, saResult))
  }
  @Test(.tags(.swiftSpecific))
  func testSaNaive3() throws {
    let s = [3, 3, 2, 1, 0]
    let saResult: [Int] = [4, 3, 2, 1, 0]
    let lcpResult: [Int] = [0, 0, 0, 1]
    #expect(saResult == sa_naive(s))
    #expect(lcpResult == lcp_naive(s, saResult))
  }
  @Test(.tags(.swiftSpecific))
  func testSAFullWidth() throws {
    let s = "ｍｉｓｓｉｓｉｐｐｉ"

    let sa = suffix_array(s)

    let answer = [
      "ｉ",  // 9
      "ｉｐｐｉ",  // 6
      "ｉｓｉｐｐｉ",  // 4
      "ｉｓｓｉｓｉｐｐｉ",  // 1
      "ｍｉｓｓｉｓｉｐｐｉ",  // 0
      "ｐｉ",  // 8
      "ｐｐｉ",  // 7
      "ｓｉｐｐｉ",  // 5
      "ｓｉｓｉｐｐｉ",  // 3
      "ｓｓｉｓｉｐｐｉ",  // 2
    ]

    #expect(answer.count == sa.count)

    for i in 0..<sa.count {
      #expect(answer[i] == String(s.map { $0 }.suffix(from: sa[i])))
    }
  }
  @Test(.tags(.swiftSpecific))
  func testSACharacter() throws {
    let s = "missisippi".map { $0 }

    let sa = suffix_array(s)

    let answer = [
      "i",  // 9
      "ippi",  // 6
      "isippi",  // 4
      "issisippi",  // 1
      "missisippi",  // 0
      "pi",  // 8
      "ppi",  // 7
      "sippi",  // 5
      "sisippi",  // 3
      "ssisippi",  // 2
    ]

    #expect(answer.count == sa.count)

    for i in 0..<sa.count {
      #expect(answer[i] == String(s.map { $0 }.suffix(from: sa[i])))
    }
  }
  @Test(.tags(.swiftSpecific))
  func testSAUInt8() throws {
    let s: [UInt8] = "missisippi".utf8.map { $0 }

    let sa = suffix_array(s)

    let answer = [
      "i",  // 9
      "ippi",  // 6
      "isippi",  // 4
      "issisippi",  // 1
      "missisippi",  // 0
      "pi",  // 8
      "ppi",  // 7
      "sippi",  // 5
      "sisippi",  // 3
      "ssisippi",  // 2
    ]

    #expect(answer.count == sa.count)

    for i in 0..<sa.count {
      #expect(answer[i].utf8.map { $0 } == s.suffix(from: sa[i]) + [])
    }
  }
  @Test(.tags(.swiftSpecific))
  func testLCPFullWidth() throws {
    let s = "ａａｂ"
    let sa = suffix_array(s)
    #expect([0, 1, 2] == sa)

    let lcp = lcp_array(s, sa)
    #expect([1, 0] == lcp)
  }
  @Test(.tags(.swiftSpecific))
  func testLCPCharacter() throws {
    let s = "aab".map { $0 }
    let sa = suffix_array(s)
    #expect([0, 1, 2] == sa)
    let lcp = lcp_array(s, sa)
    #expect([1, 0] == lcp)

    #expect(lcp == lcp_array([0, 0, 1], sa))
    #expect(lcp == lcp_array([-100, -100, 100], sa))
    #expect(lcp == lcp_array([Int32.min, Int32.min, Int32.max], sa))

    #expect(lcp == lcp_array([Int64.min, Int64.min, Int64.max], sa))

    #expect(lcp == lcp_array([UInt32.min, UInt32.min, UInt32.max], sa))

    #expect(lcp == lcp_array([UInt64.min, UInt64.min, UInt64.max], sa))
  }
  @Test(.tags(.swiftSpecific))
  func testLCPUInt8() throws {
    let s = "aab".utf8.map { $0 }
    let sa = suffix_array(s)
    #expect([0, 1, 2] == sa)
    let lcp = lcp_array(s, sa)
    #expect([1, 0] == lcp)

    #expect(lcp == lcp_array([0, 0, 1], sa))
    #expect(lcp == lcp_array([-100, -100, 100], sa))
    #expect(lcp == lcp_array([Int32.min, Int32.min, Int32.max], sa))

    #expect(lcp == lcp_array([Int64.min, Int64.min, Int64.max], sa))

    #expect(lcp == lcp_array([UInt32.min, UInt32.min, UInt32.max], sa))

    #expect(lcp == lcp_array([UInt64.min, UInt64.min, UInt64.max], sa))
  }
  @Test(.tags(.swiftSpecific))
  func testZAlgoFullWidth() throws {
    let s = "ａｂａｂ"
    let z = z_algorithm(s)
    #expect([4, 0, 2, 0] == z)
  }
  @Test(.tags(.swiftSpecific))
  func testZAlgoCharacter() throws {
    let s = "abab".map { $0 }
    let z = z_algorithm(s)
    #expect([4, 0, 2, 0] == z)
    #expect([4, 0, 2, 0] == z_algorithm([1, 10, 1, 10]))
    #expect(z_naive([0, 0, 0, 0, 0, 0, 0]) == z_algorithm([0, 0, 0, 0, 0, 0, 0]))
  }
  @Test(.tags(.swiftSpecific))
  func testZAlgoUInt8() throws {
    let s = "abab".utf8.map { $0 }
    let z = z_algorithm(s)
    #expect([4, 0, 2, 0] == z)
    #expect([4, 0, 2, 0] == z_algorithm([1, 10, 1, 10]))
    #expect(z_naive([0, 0, 0, 0, 0, 0, 0]) == z_algorithm([0, 0, 0, 0, 0, 0, 0]))
  }
}
