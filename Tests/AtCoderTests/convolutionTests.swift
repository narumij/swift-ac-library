import XCTest

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif
// TODO: [issue #8] C++のメルセンヌツイスターの挙動の確認

extension static_mod_protocol {
  public static func value<T: FixedWidthInteger>() -> T { T(umod) }
}

@usableFromInline
typealias int = CInt
@usableFromInline
typealias uint = CUnsignedInt
@usableFromInline
typealias ll = CLongLong
@usableFromInline
typealias ull = CUnsignedLongLong

@usableFromInline
func conv_ll_naive(_ a: [ll], _ b: [ll]) -> [ll] {
  let n = a.count
  let m = b.count
  var c = [ll](repeating: 0, count: n + m - 1)
  for i in 0..<n {
    for j in 0..<m {
      c[i + j] += a[i] * b[j]
    }
  }
  return c
}

@inlinable
func conv_naive<mint: modint_base>(_ a: [mint], _ b: [mint]) -> [mint] {
  let n = a.count
  let m = b.count
  var c = [mint](repeating: 0, count: n + m - 1)
  for i in 0..<n {
    for j in 0..<m {
      c[i + j] += a[i] * b[j]
    }
  }
  return c
}

@inlinable
func conv_naive<T: FixedWidthInteger>(_ MOD: T, _ a: [T], _ b: [T]) -> [T] {
  let (n, m) = (a.count, b.count)
  var c = [T](repeating: 0, count: n + m - 1)
  for i in 0..<n {
    for j in 0..<m {
      c[i + j] &+= (T)(ll(a[i]) * ll(b[j]) % ll(MOD))
      if c[i + j] >= MOD { c[i + j] -= MOD }
    }
  }
  return c
}

@inlinable
func conv_naive<MOD: static_mod_protocol, T: FixedWidthInteger>(_ t: MOD.Type, _ a: [T], _ b: [T])
  -> [T]
{
  conv_naive(t.value(), a, b)
}

final class convolutionTests: XCTestCase {

  func testEmpty() throws {
    XCTAssertEqual([int](), convolution([int](), [int]()))
    XCTAssertEqual([int](), convolution([int](), [1, 2]))
    XCTAssertEqual([int](), convolution([1, 2], [int]()))
    XCTAssertEqual([int](), convolution([1], [int]()))
    XCTAssertEqual([ll](), convolution([ll](), [ll]()))
    XCTAssertEqual([ll](), convolution([ll](), [1, 2]))
    XCTAssertEqual([modint998244353](), convolution([modint998244353](), [modint998244353]()))
    XCTAssertEqual([modint998244353](), convolution([modint998244353](), [1, 2]))
  }

  func testMid() throws {
    typealias mint = modint998244353

    // std::mt19937 mt;
    let mt = { mint(CInt.random(in: 0...CInt.max)) }
    let n = 1234
    let m = 2345
    var a = [mint](repeating: 0, count: n)
    var b = [mint](repeating: 0, count: m)

    for i in 0..<n {
      a[i] = mt()
    }
    for i in 0..<m {
      b[i] = mt()
    }

    XCTAssertEqual(conv_naive(a, b), convolution(a, b))
  }

  func testSimpleSMod() throws {

    typealias s_mint1 = static_modint<static_mod<998_244_353, IsPrime>>
    typealias s_mint2 = static_modint<static_mod<924_844_033, IsPrime>>

    // std::mt19937 mt;
    let mt = { int.random(in: 0...int.max) }

    for n in 1..<20 {
      for m in 1..<20 {
        var a = [s_mint1](repeating: 0, count: n)
        var b = [s_mint1](repeating: 0, count: m)
        for i in 0..<n {
          a[i] = s_mint1(mt())
        }
        for i in 0..<m {
          b[i] = s_mint1(mt())
        }
        XCTAssertEqual(conv_naive(a, b), (convolution(a, b)))
      }
    }

    for n in 1..<20 {
      for m in 1..<20 {
        var a = [s_mint2](repeating: 0, count: n)
        var b = [s_mint2](repeating: 0, count: m)
        for i in 0..<n {
          a[i] = s_mint2(mt())
        }
        for i in 0..<m {
          b[i] = s_mint2(mt())
        }
        XCTAssertEqual(conv_naive(a, b), (convolution(a, b)))
      }
    }
  }

  func testSimpleInt() throws {
    typealias MOD1 = static_mod<998_244_353, IsPrime>
    typealias MOD2 = static_mod<924_844_033, IsPrime>

    // std::mt19937 mt;
    let mt = { int.random(in: 0...int.max) }

    for n in 1..<20 as Range<int> {
      for m in 1..<20 as Range<int> {
        var a = [int](repeating: 0, count: Int(n))
        var b = [int](repeating: 0, count: Int(m))
        for i in 0..<n as Range<int> {
          a[Int(i)] = mt() % MOD1.value()
        }
        for i in 0..<m as Range<int> {
          b[Int(i)] = mt() % MOD1.value()
        }
        XCTAssertEqual(conv_naive(MOD1.value(), a, b), convolution(a, b))
        // コンパイラのバグが治ったためコメントアウト
        // XCTAssertEqual(conv_naive(MOD1.value(), a, b), convolution<MOD1>(a, b))
        XCTAssertEqual(conv_naive(MOD1.value(), a, b), (convolution(MOD1.self, a, b)))
      }
    }

    for n in 1..<10 {
      for m in 1..<10 {
        var a = [int](repeating: 0, count: n)
        var b = [int](repeating: 0, count: m)
        for i in 0..<n {
          a[i] = mt() % MOD2.value()
        }
        for i in 0..<m {
          b[i] = mt() % MOD2.value()
        }
        XCTAssertEqual(conv_naive(MOD2.value(), a, b), (convolution(MOD2.self, a, b)))
      }
    }
  }

  func testSimpleUint() throws {
    typealias MOD1 = static_mod<998_244_353, IsPrime>
    typealias MOD2 = static_mod<924_844_033, IsPrime>

    // std::mt19937 mt;
    let mt = { uint.random(in: uint.min...uint.max) }

    for n in 1..<20 {
      for m in 1..<20 {
        var a = [uint](repeating: 0, count: n)
        var b = [uint](repeating: 0, count: m)
        for i in 0..<n {
          a[i] = mt() % MOD1.value()
        }
        for i in 0..<m {
          b[i] = mt() % MOD1.value()
        }
        XCTAssertEqual(conv_naive(MOD1.self, a, b), convolution(a, b))
        XCTAssertEqual(conv_naive(MOD1.self, a, b), (convolution(MOD1.self, a, b)))
      }
    }

    for n in 1..<20 {
      for m in 1..<20 {
        var a = [uint](repeating: 0, count: n)
        var b = [uint](repeating: 0, count: m)
        for i in 0..<n {
          a[i] = mt() % MOD2.value()
        }
        for i in 0..<m {
          b[i] = mt() % MOD2.value()
        }
        XCTAssertEqual(conv_naive(MOD2.self, a, b), (convolution(MOD2.self, a, b)))
      }
    }
  }

  func testSimpleULL() throws {
    typealias MOD1 = static_mod<998_244_353, IsPrime>
    typealias MOD2 = static_mod<924_844_033, IsPrime>

    // std::mt19937 mt;
    let mt = { ull.random(in: ull.min...ull.max) }

    for n in 1..<20 {
      for m in 1..<20 {
        var a = [ull](repeating: 0, count: n)
        var b = [ull](repeating: 0, count: m)
        for i in 0..<n {
          a[i] = mt() % MOD1.value()
        }
        for i in 0..<m {
          b[i] = mt() % MOD1.value()
        }
        XCTAssertEqual(conv_naive(MOD1.self, a, b), convolution(a, b))
        XCTAssertEqual(conv_naive(MOD1.self, a, b), (convolution(MOD1.self, a, b)))
      }
    }

    for n in 1..<20 {
      for m in 1..<20 {
        var a = [ull](repeating: 0, count: n)
        var b = [ull](repeating: 0, count: m)
        for i in 0..<n {
          a[i] = mt() % MOD2.value()
        }
        for i in 0..<m {
          b[i] = mt() % MOD2.value()
        }
        XCTAssertEqual(conv_naive(MOD2.self, a, b), (convolution(MOD2.self, a, b)))
      }
    }
  }

  #warning("FIX ME!!!")
  func testSimpleInt128() throws {
    if #available(macOS 15.0, *) {

      typealias MOD1 = static_mod<998_244_353, IsPrime>
      typealias MOD2 = static_mod<924_844_033, IsPrime>

      // std::mt19937 mt;
      let mt = { ull.random(in: ull.min...ull.max) }

      for n in 1..<20 {
        for m in 1..<20 {
          var a = [Int128](repeating: 0, count: n)
          var b = [Int128](repeating: 0, count: m)
          for i in 0..<n {
            a[i] = Int128(mt() % MOD1.value())
          }
          for i in 0..<m {
            b[i] = Int128(mt() % MOD1.value())
          }
          XCTAssertEqual(conv_naive(MOD1.self, a, b), convolution(a, b))
          // 間違った書き方でコンパイルが通ってしまう問題がある
          // expect "Cannot explicitly specialize a generic function" error.
          // XCTAssertEqual(conv_naive(MOD1.self, a, b), convolution<MOD1>(a, b))
          // 将来直るはずなのでコメントアウト
          XCTAssertEqual(conv_naive(MOD1.self, a, b), convolution(MOD1.self, a, b))
        }
      }
      for n in 1..<20 {
        for m in 1..<20 {
          var a = [Int128](repeating: 0, count: n)
          var b = [Int128](repeating: 0, count: m)
          for i in 0..<n {
            a[i] = Int128(mt() % MOD2.value())
            //            a[i] = Int128(MOD2.value() + i - 10)
          }
          for i in 0..<m {
            b[i] = Int128(mt() % MOD2.value())
            //            b[i] = Int128(MOD2.value() + i - 10)
          }
          // 間違った書き方でコンパイルが通ってしまう問題がある
          // expect "Cannot explicitly specialize a generic function" error.
          // XCTAssertNotEqual(conv_naive(MOD2.self, a, b), convolution<MOD2>(a, b))
          // 将来直るはずなのでコメントアウト
          XCTAssertEqual(conv_naive(MOD2.self, a, b), convolution(MOD2.self, a, b))
        }
      }
    } else {
      // Fallback on earlier versions
      throw XCTSkip("__int128がない")
    }
  }

  func testSimpleUInt128() throws {
    if #available(macOS 15.0, *) {

      typealias MOD1 = static_mod<998_244_353, IsPrime>
      typealias MOD2 = static_mod<924_844_033, IsPrime>

      // std::mt19937 mt;
      let mt = { ull.random(in: ull.min...ull.max) }

      for n in 1..<20 {
        for m in 1..<20 {
          var a = [UInt128](repeating: 0, count: n)
          var b = [UInt128](repeating: 0, count: m)
          for i in 0..<n {
            a[i] = UInt128(mt() % MOD1.value())
          }
          for i in 0..<m {
            b[i] = UInt128(mt() % MOD1.value())
          }
          XCTAssertEqual(conv_naive(MOD1.self, a, b), convolution(a, b))
          // 間違った書き方でコンパイルが通ってしまう問題がある
          // expect "Cannot explicitly specialize a generic function" error.
          // XCTAssertEqual(conv_naive(MOD1.self, a, b), convolution<MOD1>(a, b))
          // 将来直るはずなのでコメントアウト
          XCTAssertEqual(conv_naive(MOD1.self, a, b), convolution(MOD1.self, a, b))
        }
      }
      for n in 1..<20 {
        for m in 1..<20 {
          var a = [UInt128](repeating: 0, count: n)
          var b = [UInt128](repeating: 0, count: m)
          for i in 0..<n {
            a[i] = UInt128(mt() % MOD2.value())
            //            a[i] = Int128(MOD2.value() + i - 10)
          }
          for i in 0..<m {
            b[i] = UInt128(mt() % MOD2.value())
            //            b[i] = Int128(MOD2.value() + i - 10)
          }
          // 間違った書き方でコンパイルが通ってしまう問題がある
          // expect "Cannot explicitly specialize a generic function" error.
          // XCTAssertNotEqual(conv_naive(MOD2.self, a, b), convolution<MOD2>(a, b), "n:\(n), m:\(m)")
          // 将来直るはずなのでコメントアウト
          XCTAssertEqual(
            conv_naive(MOD2.self, a, b), convolution(MOD2.self, a, b), "n:\(n), m:\(m)")
        }
      }
    } else {
      // Fallback on earlier versions
      throw XCTSkip("__int128がない")
    }
  }

  func testConvLL() throws {

    // std::mt19937 mt;
    let mt = { ll.random(in: ll.min...ll.max) }

    for n in 1..<20 {
      for m in 1..<20 {
        var a = [ll](repeating: 0, count: n)
        var b = [ll](repeating: 0, count: m)
        for i in 0..<n {
          a[i] = mt() % 1_000_000 - 500_000
        }
        for i in 0..<m {
          b[i] = mt() % 1_000_000 - 500_000
        }
        XCTAssertEqual(conv_ll_naive(a, b), convolution_ll(a, b))
      }
    }
  }

  func testConvLLBound() throws {
    let MOD1: ll = 469_762_049  // 2^26
    let MOD2: ll = 167_772_161  // 2^25
    let MOD3: ll = 754_974_721  // 2^24
    let M2M3: ll = MOD2 * MOD3
    let M1M3: ll = MOD1 * MOD3
    let M1M2: ll = MOD1 * MOD2
    // for (int i = -1000; i <= 1000; i++) {
    for i in ll(-1000) ..<= 1000 {
      let a: [ll] = [ll(0 - M1M2 - M1M3 - M2M3 + i)]
      let b: [ll] = [1]

      XCTAssertEqual(a, convolution_ll(a, b))
    }
    // for (int i = 0; i < 1000; i++) {
    for i in ll(-1000) ..<= 1000 {
      let a: [ll] = [ll.min &+ i]
      let b: [ll] = [1]

      XCTAssertEqual(a, convolution_ll(a, b))
    }
    // for (int i = 0; i < 1000; i++) {
    for i in ll(-1000) ..<= 1000 {
      let a: [ll] = [ll.max &- i]
      let b: [ll] = [1]

      XCTAssertEqual(a, convolution_ll(a, b))
    }
  }

  // https://github.com/atcoder/ac-library/issues/30
  func testConv641() throws {
    // 641 = 128 * 5 + 1
    typealias MOD = static_mod<641, IsPrime>

    var a = [ll](repeating: 0, count: 64)
    var b = [ll](repeating: 0, count: 65)

    for i in 0..<64 {
      a[i] = ll.random(in: 0...(MOD.value() - 1))
    }
    for i in 0..<65 {
      b[i] = ll.random(in: 0...(MOD.value() - 1))
    }

    XCTAssertEqual(conv_naive(MOD.self, a, b), convolution(MOD.self, a, b))
  }

  // https://github.com/atcoder/ac-library/issues/30
  func testConv18433() throws {

    // 18433 = 2048 * 9 + 1
    typealias MOD = static_mod<18433, IsPrime>

    var a = [ll](repeating: 0, count: 1024)
    var b = [ll](repeating: 0, count: 1025)

    for i in 0..<1024 {
      a[i] = ll.random(in: 0...(MOD.value() - 1))
    }
    for i in 0..<1025 {
      b[i] = ll.random(in: 0...(MOD.value() - 1))
    }

    XCTAssertEqual(conv_naive(MOD.self, a, b), convolution(MOD.self, a, b))
  }

  func testConv2() throws {
    typealias mod_2 = static_mod<2, IsPrime>
    let empty: [ll] = []
    XCTAssertEqual(empty, convolution(mod_2.self, empty, empty))
  }

  func testConv257() throws {
    typealias MOD = static_mod<257, IsPrime>

    var a = [ll](repeating: 0, count: 128)
    var b = [ll](repeating: 0, count: 129)

    for i in 0..<128 {
      a[i] = ll.random(in: 0...(MOD.value() - 1))
    }
    for i in 0..<129 {
      b[i] = ll.random(in: 0...(MOD.value() - 1))
    }

    XCTAssertEqual(conv_naive(MOD.self, a, b), convolution(MOD.self, a, b))
  }

  func testConv2147483647() throws {
    typealias MOD = static_mod<2_147_483_647, IsPrime>

    var a = [ll](repeating: 0, count: 1)
    var b = [ll](repeating: 0, count: 2)

    for i in 0..<1 {
      a[i] = ll.random(in: 0...(MOD.value() - 1))
    }
    for i in 0..<2 {
      b[i] = ll.random(in: 0...(MOD.value() - 1))
    }

    XCTAssertEqual(conv_naive(MOD.self, a, b), convolution(MOD.self, a, b))
  }

  func testConv2130706433() throws {
    typealias MOD = static_mod<2_130_706_433, IsPrime>

    var a = [ll](repeating: 0, count: 1024)
    var b = [ll](repeating: 0, count: 1024)

    for i in 0..<1024 {
      a[i] = ll.random(in: 0...(MOD.value() - 1))
    }
    for i in 0..<1024 {
      b[i] = ll.random(in: 0...(MOD.value() - 1))
    }

    XCTAssertEqual(conv_naive(MOD.self, a, b), convolution(MOD.self, a, b))
  }

  func testStress0() throws {
    self.measure {
      try! testSimpleSMod()
    }
  }
}
