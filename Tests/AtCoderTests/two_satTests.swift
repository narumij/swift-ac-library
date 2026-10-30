import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

//private typealias ll = CLongLong
//private typealias ull = CUnsignedLongLong

extension LibraryTests {
  final class two_satTests {

    typealias two_sat = TwoSAT

    @Test(.tags(.aclPort))
    func testEmpty() throws {
      var ts0 = two_sat()
      do {
        let result = ts0.satisfiable()
        #expect(result)
      }
      #expect([] == ts0.answer())
      var ts1 = two_sat(0)
      do {
        let result = ts1.satisfiable()
        #expect(result)
      }
      #expect([] == ts1.answer())
    }

    @Test(.tags(.aclPort))
    func testOne() throws {
      do {
        var ts = two_sat(1)
        ts.add_clause(0, true, 0, true)
        ts.add_clause(0, false, 0, false)
        do {
          let result = !ts.satisfiable()
          #expect(result)
        }
      }
      do {
        var ts = two_sat(1)
        ts.add_clause(0, true, 0, true)
        do {
          let result = ts.satisfiable()
          #expect(result)
        }
        #expect([true] == ts.answer())
      }
      do {
        var ts = two_sat(1)
        ts.add_clause(0, false, 0, false)
        do {
          let result = ts.satisfiable()
          #expect(result)
        }
        #expect([false] == ts.answer())
      }
    }

    #if false
      @Test(.tags(.aclPort))
      func testAssign() throws {
        return  // Previously skipped: "代入のオーバーロードはSwiftにはない。"
        /*
           two_sat ts;
           ts = two_sat(10);
           */
      }
    #endif

    @Test(.tags(.aclPort))
    func testStress() throws {
      // This is an example of a performance test case.
      #if DEBUG
        let phases = 1000
      #else
        let phases = 10000
      #endif
      measureRepeated {
        for _ /* phase */ in 0..<phases {
          let n = randint(1, 20)
          let m = randint(1, 100)
          var expect = [Bool](repeating: false, count: n)
          for i in 0..<n {
            expect[i] = randbool()
          }
          var ts = two_sat(n)
          var xs = [Int](repeating: 0, count: m)
          var ys = [Int](repeating: 0, count: m)
          var types = [Int](repeating: 0, count: m)
          for i in 0..<m {
            let x = randint(0, n - 1)
            let y = randint(0, n - 1)
            let type = randint(0, 2)
            xs[i] = x
            ys[i] = y
            types[i] = type
            if type == 0 {
              ts.add_clause(x, expect[x], y, expect[y])
            } else if type == 1 {
              ts.add_clause(x, !expect[x], y, expect[y])
            } else {
              ts.add_clause(x, expect[x], y, !expect[y])
            }
          }
          do {
            let result = ts.satisfiable()
            #expect(result)
          }
          let actual = ts.answer()
          for i in 0..<m {
            let x = xs[i]
            let y = ys[i]
            let type = types[i]
            if type == 0 {
              #expect(actual[x] == expect[x] || actual[y] == expect[y])
            } else if type == 1 {
              #expect(actual[x] != expect[x] || actual[y] == expect[y])
            } else {
              #expect(actual[x] == expect[x] || actual[y] != expect[y])
            }
          }
        }
      }
    }
  }

}
