import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

//private typealias int = CInt
//private typealias uint = CUnsignedInt
//private typealias ll = CLongLong
//private typealias ull = CUnsignedLongLong

extension LibraryTests {
  final class fenwickTreeTests {

    typealias fenwick_tree = FenwickTree

    @Test(.tags(.aclPort))
    func testEmpty() throws {
      var fw_ll = fenwick_tree<ll>()
      #expect(0 == fw_ll.sum(0, 0))

      var fw_modint = fenwick_tree<modint>()
      #expect(0 == fw_modint.sum(0, 0))
    }

    #if false
      @Test(.tags(.aclPort))
      func testAssign() throws {
        return  // Previously skipped: "代入のオーバーロードはSwiftにはない。"
        /*
           fenwick_tree<ll> fw;
           fw = fenwick_tree<ll>(10);
           */
      }
    #endif

    @Test(.tags(.aclPort))
    func testZero() throws {
      var fw_ll = fenwick_tree<ll>(0)
      #expect(0 == fw_ll.sum(0, 0))

      var fw_modint = fenwick_tree<modint>(0)
      #expect(0 == fw_modint.sum(0, 0))
    }

    @Test(.tags(.aclPort))
    func testOverFlowULL() throws {
      var fw = fenwick_tree<ull>(10)
      for i in 0..<10 {
        fw.add(i, ull(bitPattern: 1 << 63) + ull(i))
      }
      for i in 0 ..<= 10 {
        for j in 0 ..<= 10 {
          var sum: ull = 0
          for k in stride(from: i, to: j, by: 1) {
            sum += ull(k)
          }
          if i <= j {
            #expect((((j - i) % 2) != 0 ? ull(bitPattern: 1 << 63) + sum : sum) == fw.sum(i, j))
          }
        }
      }
    }

    @Test(.tags(.aclPort))
    func testNaiveTest() throws {
      for n in 0 ..<= 50 {
        var fw = fenwick_tree<ll>(n)
        for i in 0..<n {
          fw.add(i, ll(i * i))
        }
        for l in 0 ..<= n {
          for r in l ..<= n {
            var sum: ll = 0
            for i in l..<r {
              sum += ll(i * i)
            }
            #expect(sum == fw.sum(l, r))
          }
        }
      }
    }

    @Test(.tags(.aclPort))
    func testSMintTest() throws {
      enum mod_11: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 11 }
      typealias mint = static_modint<mod_11>
      for n in 0 ..<= 5 {
        var fw = fenwick_tree<mint>(n)
        for i in 0..<n {
          fw.add(i, mint(i * i))
        }
        for l in 0 ..<= n {
          for r in l ..<= n {
            var sum = 0
            for i in l..<r {
              sum += i * i
            }
            #expect(mint(sum) == fw.sum(l, r))
          }
        }
      }
    }

    @Test(.tags(.aclPort))
    func testMintTest() throws {
      typealias mint = modint
      for n in 0 ..<= 50 {
        var fw = fenwick_tree<mint>(n)
        for i in 0..<n {
          fw.add(i, mint(i * i))
        }
        for l in 0 ..<= n {
          for r in l ..<= n {
            var sum = 0
            for i in l..<r {
              sum += i * i
            }
            #expect(mint(sum) == fw.sum(l, r))
          }
        }
      }
    }

    #if false
      @Test(.tags(.aclPort))
      func testInvalid() throws {
        return  // Previously skipped: "Swift Testingで実施"
        /*
          EXPECT_THROW(auto s = fenwick_tree<int>(-1), std::exception);
          fenwick_tree<int> s(10);

          EXPECT_DEATH(s.add(-1, 0), ".*");
          EXPECT_DEATH(s.add(10, 0), ".*");

          EXPECT_DEATH(s.sum(-1, 3), ".*");
          EXPECT_DEATH(s.sum(3, 11), ".*");
          EXPECT_DEATH(s.sum(5, 3), ".*");
           */
      }
    #endif

    @Test(.tags(.aclPort))
    func testBound() throws {
      var fw = fenwick_tree<int>(10)
      fw.add(3, int.max)
      fw.add(5, int.min)
      #expect(-1 == fw.sum(0, 10))
      #expect(-1 == fw.sum(3, 6))
      #expect(int.max == fw.sum(3, 4))
      #expect(int.min == fw.sum(4, 10))
    }

    @Test(.tags(.aclPort))
    func testBoundll() throws {
      var fw = fenwick_tree<ll>(10)
      fw.add(3, ll.max)
      fw.add(5, ll.min)
      #expect(-1 == fw.sum(0, 10))
      #expect(-1 == fw.sum(3, 6))
      #expect(ll.max == fw.sum(3, 4))
      #expect(ll.min == fw.sum(4, 10))
    }

    @Test(.tags(.aclPort))
    func testOverFlow() throws {
      var fw = fenwick_tree<int>(20)
      var a = [ll](repeating: 0, count: 20)
      for i in 0..<10 {
        let x = int.max
        a[i] += ll(x)
        fw.add(i, x)
      }
      for i in 10..<20 {
        let x = int.min
        a[i] += ll(x)
        fw.add(i, x)
      }
      a[5] += 11111
      fw.add(5, 11111)

      for l in 0 ..<= 20 {
        for r in l ..<= 20 {
          var sum: ll = 0
          for i in l..<r {
            sum &+= ll(a[i])
          }
          let dif = sum - ll(fw.sum(l, r))
          if dif != 0 {
            #expect(0 == dif % ll(bitPattern: 1 << 32))
          }
        }
      }
    }

    @Test(.tags(.aclPort))
    @available(macOS 15.0, *)
    func testInt128() throws {
      if #available(macOS 15.0, *) {
        var fw = FenwickTree<Int128>(20)
        for i in 0..<20 {
          fw.add(i, Int128(i))
        }

        for l in 0..<20 {
          for r in l...20 {
            var sum: Int128 = 0
            for i in l..<r {
              sum += Int128(i)
            }
            #expect(sum == fw.sum(l, r))
          }
        }
      } else {
        return  // Previously skipped: "Int128が利用できない"
      }
    }

  }

}

// Invalid-input exit tests.
#if DEATH_TEST && DEBUG

  @Suite(.tags(.exitTest))
  struct fenwickTreeDeathTests {

    @Test(.tags(.aclPort)) func testInvalid() async {
      //  EXPECT_THROW(auto s = fenwick_tree<int>(-1), std::exception);
      await #expect(processExitsWith: .failure) {
        _ = FenwickTree<Int>(-1)
      }
      //  EXPECT_DEATH(s.add(-1, 0), ".*");
      await #expect(processExitsWith: .failure) {
        var s = FenwickTree<Int>(10)
        s.add(-1, 0)
      }
      //  EXPECT_DEATH(s.add(10, 0), ".*");
      await #expect(processExitsWith: .failure) {
        var s = FenwickTree<Int>(10)
        s.add(10, 0)
      }
      //  EXPECT_DEATH(s.sum(-1, 3), ".*");
      await #expect(processExitsWith: .failure) {
        let s = FenwickTree<Int>(10)
        _ = s.sum(-1, 3)
      }
      //  EXPECT_DEATH(s.sum(3, 11), ".*");
      await #expect(processExitsWith: .failure) {
        let s = FenwickTree<Int>(10)
        _ = s.sum(3, 11)
      }
      //  EXPECT_DEATH(s.sum(5, 3), ".*");
      await #expect(processExitsWith: .failure) {
        let s = FenwickTree<Int>(10)
        _ = s.sum(5, 3)
      }
    }
  }
#endif
