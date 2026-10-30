import Testing

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

extension LibraryTests {
  final class stringTests {

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

    #if DEBUG
      @Test(.tags(.aclPort))
      func testEmpty() throws {

        #expect([] == suffix_array(""))
        #expect([] == suffix_array("".map { $0 }))
        #expect([] == suffix_array("".utf8.map { $0 }))
        #expect([] == suffix_array([Int]()))

        #expect([] == z_algorithm(""))
        #expect([] == z_algorithm("".map { $0 }))
        #expect([] == z_algorithm("".utf8.map { $0 }))
        #expect([] == z_algorithm([Int]()))
      }

      @Test(.tags(.aclPort))
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
            #expect(sa == suffix_array(s))
            #expect(sa == suffix_array(s, max_c))
            #expect(lcp_naive(s, sa) == lcp_array(s, sa))
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
            #expect(sa == suffix_array(s))
            #expect(sa == suffix_array(s, max_c))
            #expect(lcp_naive(s, sa) == lcp_array(s, sa))
          }
        }
      }

      @Test(.tags(.aclPort))
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
            #expect(sa_naive(s) == sa)
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
            #expect(sa_naive(s) == sa)
          }
        }
      }

      @Test(.tags(.aclPort))
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
            #expect(sa_naive(s) == sa)
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
            #expect(sa_naive(s) == sa)
          }
        }
      }

      @Test(.tags(.aclPort))
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

            let sa = _Internal.sa_is(.init(start: s, count: s.count), max_c, -1, -1)
            #expect(sa_naive(s) == sa)
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

            let sa = _Internal.sa_is(.init(start: s, count: s.count), max_c, -1, -1)
            #expect(sa_naive(s) == sa)
          }
        }
      }

      @Test(.tags(.aclPort))
      func testSAAllATest() throws {
        for n in 1 ..<= 100 {
          let s = [Int](repeating: 10, count: n)
          #expect(sa_naive(s) == suffix_array(s))
          #expect(sa_naive(s) == suffix_array(s, 10))
          #expect(sa_naive(s) == suffix_array(s, 12))
        }
      }

      @Test(.tags(.aclPort))
      func testSAAllABTest() throws {
        for n in 1 ..<= 100 {
          var s = [Int](repeating: 0, count: n)
          for i in 0..<n { s[i] = (i % 2) }
          #expect(sa_naive(s) == suffix_array(s))
          #expect(sa_naive(s) == suffix_array(s, 3))
        }
        for n in 1 ..<= 100 {
          var s = [Int](repeating: 0, count: n)
          for i in 0..<n { s[i] = 1 - (i % 2) }
          #expect(sa_naive(s) == suffix_array(s))
          #expect(sa_naive(s) == suffix_array(s, 3))
        }
      }
    #endif

    @Test(.tags(.aclPort))
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

      #expect(answer.count == sa.count)

      for i in 0..<sa.count {
        #expect(answer[i] == String(s.map { $0 }.suffix(from: sa[i])))
      }
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

    @Test(.tags(.aclPort))
    func testSASingle() throws {
      #expect([0] == suffix_array([0]))
      #expect([0] == suffix_array([-1]))
      #expect([0] == suffix_array([1]))
      #expect([0] == suffix_array([Int32.min]))
      #expect([0] == suffix_array([Int32.max]))
    }

    @Test(.tags(.aclPort))
    func testLCP() throws {
      let s = "aab"
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

    @Test(.tags(.aclPort))
    func testZAlgo() throws {
      let s = "abab"
      let z = z_algorithm(s)
      #expect([4, 0, 2, 0] == z)
      #expect([4, 0, 2, 0] == z_algorithm([1, 10, 1, 10]))
      #expect(z_naive([0, 0, 0, 0, 0, 0, 0]) == z_algorithm([0, 0, 0, 0, 0, 0, 0]))
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

    @Test(.tags(.aclPort))
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
          #expect(z_naive(s) == z_algorithm(s))
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
          #expect(z_naive(s) == z_algorithm(s))
        }
      }
    }
  }

}
