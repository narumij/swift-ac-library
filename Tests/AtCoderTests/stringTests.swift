import XCTest

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

extension Collection where Element: Comparable {
  fileprivate static func < (lhs: Self, rhs: Self) -> Bool {
    zip(lhs, rhs).first { $0 != $1 }.map { $0 < $1 } ?? (lhs.count < rhs.count)
  }
}

func sa_naive(_ s: [Int]) -> [Int] {
  s.indices.sorted { s[$0..<s.endIndex] < s[$1..<s.endIndex] }
}

func lcp_naive(_ s: [Int], _ sa: [Int]) -> [Int] {
  let n = s.count
  assert((n != 0))
  var lcp = [Int](repeating: 0, count: n - 1)
  for i in 0..<(n - 1) {
    let (l, r) = (sa[i], sa[i + 1])
    while l + lcp[i] < n, r + lcp[i] < n, s[l + lcp[i]] == s[r + lcp[i]] { lcp[i] += 1 }
  }
  return lcp
}

func z_naive(_ s: [Int]) -> [Int] {
  let n = s.count
  var z = [Int](repeating: 0, count: n)
  for i in 0..<n {
    while i + z[i] < n, s[z[i]] == s[i + z[i]] { z[i] += 1 }
  }
  return z
}

final class stringTests: XCTestCase {

  func testSaNaive() throws {
    let s = [0, 0, 0, 0, 0]
    let saResult: [Int] = [4, 3, 2, 1, 0]
    let lcpResult: [Int] = [1, 2, 3, 4]
    XCTAssertEqual(saResult, sa_naive(s))
    XCTAssertEqual(lcpResult, lcp_naive(s, saResult))
  }

  func testSaNaive2() throws {
    let s = [1, 2, 3, 4, 5]
    let saResult: [Int] = [0, 1, 2, 3, 4]
    let lcpResult: [Int] = [0, 0, 0, 0]
    XCTAssertEqual(saResult, sa_naive(s))
    XCTAssertEqual(lcpResult, lcp_naive(s, saResult))
  }

  func testSaNaive3() throws {
    let s = [3, 3, 2, 1, 0]
    let saResult: [Int] = [4, 3, 2, 1, 0]
    let lcpResult: [Int] = [0, 0, 0, 1]
    XCTAssertEqual(saResult, sa_naive(s))
    XCTAssertEqual(lcpResult, lcp_naive(s, saResult))
  }

  #if DEBUG
    func testEmpty() throws {

      XCTAssertEqual([], suffix_array(""))
      XCTAssertEqual([], suffix_array("".map { $0 }))
      XCTAssertEqual([], suffix_array("".utf8.map { $0 }))
      XCTAssertEqual([], suffix_array([Int]()))

      XCTAssertEqual([], z_algorithm(""))
      XCTAssertEqual([], z_algorithm("".map { $0 }))
      XCTAssertEqual([], z_algorithm("".utf8.map { $0 }))
      XCTAssertEqual([], z_algorithm([Int]()))
    }

    func testSALCPNaive() throws {

      for n in 1 ..<= 5 {
        var m = 1
        for _ in 0..<n { m *= 4 }
        for f in 0..<m {
          var s = [Int](repeating: 0, count: n)
          var g = f
          var max_c = 0
          for i in 0..<n {
            s[i] = g % 4
            max_c = max(max_c, s[i])
            g /= 4
          }
          let sa = sa_naive(s)
          XCTAssertEqual(sa, suffix_array(s))
          XCTAssertEqual(sa, suffix_array(s, max_c))
          XCTAssertEqual(lcp_naive(s, sa), lcp_array(s, sa))
        }
      }

      for n in 1 ..<= 10 {
        var m = 1
        for _ in 0..<n { m *= 2 }
        for f in 0..<m {
          var s = [Int](repeating: 0, count: n)
          var g = f
          var max_c = 0
          for i in 0..<n {
            s[i] = g % 2
            max_c = max(max_c, s[i])
            g /= 2
          }
          let sa = sa_naive(s)
          XCTAssertEqual(sa, suffix_array(s))
          XCTAssertEqual(sa, suffix_array(s, max_c))
          XCTAssertEqual(lcp_naive(s, sa), lcp_array(s, sa))
        }
      }
    }

    func testInternalSANaiveNaive() throws {
      for n in 1 ..<= 5 {
        var m = 1
        for _ in 0..<n { m *= 4 }
        for f in 0..<m {
          var s = [Int](repeating: 0, count: n)
          var g = f
          var max_c = 0
          for i in 0..<n {
            s[i] = g % 4
            max_c = max(max_c, s[i])
            g /= 4
          }

          let sa = _Internal.sa_naive(s)
          XCTAssertEqual(sa_naive(s), sa)
        }
      }
      for n in 1 ..<= 10 {
        var m = 1
        for _ in 0..<n { m *= 2 }
        for f in 0..<m {
          var s = [Int](repeating: 0, count: n)
          var g = f
          for i in 0..<n {
            s[i] = g % 2
            g /= 2
          }

          let sa = _Internal.sa_naive(s)
          XCTAssertEqual(sa_naive(s), sa)
        }
      }
    }

    func testInternalSADoublingNaive() throws {
      for n in 1 ..<= 5 {
        var m = 1
        for _ in 0..<n { m *= 4 }
        for f in 0..<m {
          var s = [Int](repeating: 0, count: n)
          var g = f
          for i in 0..<n {
            s[i] = g % 4
            g /= 4
          }

          let sa = _Internal.sa_doubling(s)
          XCTAssertEqual(sa_naive(s), sa)
        }
      }
      for n in 1 ..<= 10 {
        var m = 1
        for _ in 0..<n { m *= 2 }
        for f in 0..<m {
          var s = [Int](repeating: 0, count: n)
          var g = f
          for i in 0..<n {
            s[i] = g % 2
            g /= 2
          }

          let sa = _Internal.sa_doubling(s)
          XCTAssertEqual(sa_naive(s), sa)
        }
      }
    }

    func testInternalSAISNaive() throws {
      for n in 1 ..<= 5 {
        var m = 1
        for _ in 0..<n { m *= 4 }
        for f in 0..<m {
          var s = [Int](repeating: 0, count: n)
          var g = f
          var max_c = 0
          for i in 0..<n {
            s[i] = g % 4
            max_c = max(max_c, s[i])
            g /= 4
          }

          let sa = _Internal.sa_is(s, count: s.count, max_c, -1, -1)
          XCTAssertEqual(sa_naive(s), sa)
        }
      }
      for n in 1 ..<= 10 {
        var m = 1
        for _ in 0..<n { m *= 2 }
        for f in 0..<m {
          var s = [Int](repeating: 0, count: n)
          var g = f
          var max_c = 0
          for i in 0..<n {
            s[i] = g % 2
            max_c = max(max_c, s[i])
            g /= 2
          }

          let sa = _Internal.sa_is(s, count: s.count, max_c, -1, -1)
          XCTAssertEqual(sa_naive(s), sa)
        }
      }
    }

    func testSAAllATest() throws {
      for n in 1 ..<= 100 {
        let s = [Int](repeating: 10, count: n)
        XCTAssertEqual(sa_naive(s), suffix_array(s))
        XCTAssertEqual(sa_naive(s), suffix_array(s, 10))
        XCTAssertEqual(sa_naive(s), suffix_array(s, 12))
      }
    }

    func testSAAllABTest() throws {
      for n in 1 ..<= 100 {
        var s = [Int](repeating: 0, count: n)
        for i in 0..<n { s[i] = (i % 2) }
        XCTAssertEqual(sa_naive(s), suffix_array(s))
        XCTAssertEqual(sa_naive(s), suffix_array(s, 3))
      }
      for n in 1 ..<= 100 {
        var s = [Int](repeating: 0, count: n)
        for i in 0..<n { s[i] = 1 - (i % 2) }
        XCTAssertEqual(sa_naive(s), suffix_array(s))
        XCTAssertEqual(sa_naive(s), suffix_array(s, 3))
      }
    }
  #endif

  func testSA() throws {
    let s = "missisippi"

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

    XCTAssertEqual(answer.count, sa.count)

    for i in 0..<sa.count {
      XCTAssertEqual(answer[i], String(s.map { $0 }.suffix(from: sa[i])))
    }
  }

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

    XCTAssertEqual(answer.count, sa.count)

    for i in 0..<sa.count {
      XCTAssertEqual(answer[i], String(s.map { $0 }.suffix(from: sa[i])))
    }
  }

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

    XCTAssertEqual(answer.count, sa.count)

    for i in 0..<sa.count {
      XCTAssertEqual(answer[i].utf8.map { $0 }, s.suffix(from: sa[i]) + [])
    }
  }

  #if DEBUG
    func testSASingle() throws {
      XCTAssertEqual([0], suffix_array([0]))
      XCTAssertEqual([0], suffix_array([-1]))
      XCTAssertEqual([0], suffix_array([1]))
      XCTAssertEqual([0], suffix_array([Int32.min]))
      XCTAssertEqual([0], suffix_array([Int32.max]))
    }
  #endif

  func testLCP() throws {
    let s = "aab"
    let sa = suffix_array(s)
    XCTAssertEqual([0, 1, 2], sa)
    let lcp = lcp_array(s, sa)
    XCTAssertEqual([1, 0], lcp)

    XCTAssertEqual(lcp, lcp_array([0, 0, 1], sa))
    XCTAssertEqual(lcp, lcp_array([-100, -100, 100], sa))
    XCTAssertEqual(
      lcp,
      lcp_array([Int32.min, Int32.min, Int32.max], sa))

    XCTAssertEqual(
      lcp,
      lcp_array([Int64.min, Int64.min, Int64.max], sa))

    XCTAssertEqual(
      lcp,
      lcp_array([UInt32.min, UInt32.min, UInt32.max], sa))

    XCTAssertEqual(
      lcp,
      lcp_array([UInt64.min, UInt64.min, UInt64.max], sa))
  }

  func testLCPCharacter() throws {
    let s = "aab".map { $0 }
    let sa = suffix_array(s)
    XCTAssertEqual([0, 1, 2], sa)
    let lcp = lcp_array(s, sa)
    XCTAssertEqual([1, 0], lcp)

    XCTAssertEqual(lcp, lcp_array([0, 0, 1], sa))
    XCTAssertEqual(lcp, lcp_array([-100, -100, 100], sa))
    XCTAssertEqual(
      lcp,
      lcp_array([Int32.min, Int32.min, Int32.max], sa))

    XCTAssertEqual(
      lcp,
      lcp_array([Int64.min, Int64.min, Int64.max], sa))

    XCTAssertEqual(
      lcp,
      lcp_array([UInt32.min, UInt32.min, UInt32.max], sa))

    XCTAssertEqual(
      lcp,
      lcp_array([UInt64.min, UInt64.min, UInt64.max], sa))
  }

  func testLCPUInt8() throws {
    let s = "aab".utf8.map { $0 }
    let sa = suffix_array(s)
    XCTAssertEqual([0, 1, 2], sa)
    let lcp = lcp_array(s, sa)
    XCTAssertEqual([1, 0], lcp)

    XCTAssertEqual(lcp, lcp_array([0, 0, 1], sa))
    XCTAssertEqual(lcp, lcp_array([-100, -100, 100], sa))
    XCTAssertEqual(
      lcp,
      lcp_array([Int32.min, Int32.min, Int32.max], sa))

    XCTAssertEqual(
      lcp,
      lcp_array([Int64.min, Int64.min, Int64.max], sa))

    XCTAssertEqual(
      lcp,
      lcp_array([UInt32.min, UInt32.min, UInt32.max], sa))

    XCTAssertEqual(
      lcp,
      lcp_array([UInt64.min, UInt64.min, UInt64.max], sa))
  }

  func testZAlgo() throws {
    let s = "abab"
    let z = z_algorithm(s)
    XCTAssertEqual([4, 0, 2, 0], z)
    XCTAssertEqual(
      [4, 0, 2, 0],
      z_algorithm([1, 10, 1, 10]))
    XCTAssertEqual(z_naive([0, 0, 0, 0, 0, 0, 0]), z_algorithm([0, 0, 0, 0, 0, 0, 0]))
  }

  func testZAlgoCharacter() throws {
    let s = "abab".map { $0 }
    let z = z_algorithm(s)
    XCTAssertEqual([4, 0, 2, 0], z)
    XCTAssertEqual(
      [4, 0, 2, 0],
      z_algorithm([1, 10, 1, 10]))
    XCTAssertEqual(z_naive([0, 0, 0, 0, 0, 0, 0]), z_algorithm([0, 0, 0, 0, 0, 0, 0]))
  }

  func testZAlgoUInt8() throws {
    let s = "abab".utf8.map { $0 }
    let z = z_algorithm(s)
    XCTAssertEqual([4, 0, 2, 0], z)
    XCTAssertEqual(
      [4, 0, 2, 0],
      z_algorithm([1, 10, 1, 10]))
    XCTAssertEqual(z_naive([0, 0, 0, 0, 0, 0, 0]), z_algorithm([0, 0, 0, 0, 0, 0, 0]))
  }

  func testZNaive() throws {
    for n in 1 ..<= 6 {
      var m = 1
      for _ in 0..<n { m *= 4 }
      for f in 0..<m {
        var s = [Int](repeating: 0, count: n)
        var g = f
        for i in 0..<n {
          s[i] = g % 4
          g /= 4
        }
        XCTAssertEqual(z_naive(s), z_algorithm(s))
      }
    }
    for n in 1 ..<= 10 {
      var m = 1
      for _ in 0..<n { m *= 2 }
      for f in 0..<m {
        var s = [Int](repeating: 0, count: n)
        var g = f
        for i in 0..<n {
          s[i] = g % 2
          g /= 2
        }
        XCTAssertEqual(z_naive(s), z_algorithm(s))
      }
    }
  }
}
