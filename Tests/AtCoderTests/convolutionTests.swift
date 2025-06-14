import XCTest

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif
// TODO: [issue #8] C++のメルセンヌツイスターの挙動の確認

extension static_mod {
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
func conv_ll_naive(_ a: [Int], _ b: [Int]) -> [Int] {
  let n = a.count
  let m = b.count
  var c = [Int](repeating: 0, count: n + m - 1)
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
func conv_naive<MOD: static_mod, T: FixedWidthInteger>(_ t: MOD.Type, _ a: [T], _ b: [T])
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

    enum MOD1: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 998_244_353 }
    enum MOD2: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 924_844_033 }

    typealias s_mint1 = static_modint<MOD1>
    typealias s_mint2 = static_modint<MOD2>

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
    enum MOD1: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 998_244_353 }
    enum MOD2: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 924_844_033 }

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
    enum MOD1: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 998_244_353 }
    enum MOD2: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 924_844_033 }

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
    enum MOD1: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 998_244_353 }
    enum MOD2: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 924_844_033 }

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

      enum MOD1: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 998_244_353 }
      enum MOD2: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 924_844_033 }

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

      enum MOD1: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 998_244_353 }
      enum MOD2: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 924_844_033 }

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
    let mt = { Int.random(in: Int.min...Int.max) }

    for n in 1..<20 {
      for m in 1..<20 {
        var a = [Int](repeating: 0, count: n)
        var b = [Int](repeating: 0, count: m)
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
    typealias ll = Int
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
    enum MOD: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 641 }

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
    enum MOD: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 18433 }

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
    enum mod_2: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 2 }
    let empty: [ll] = []
    XCTAssertEqual(empty, convolution(mod_2.self, empty, empty))
  }

  func testConv257() throws {
    enum MOD: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 257 }

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
    enum MOD: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 2_147_483_647 }

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
    enum MOD: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 2_130_706_433 }

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

  func testInfo_998_244_353() throws {

    #if DEBUG
      do {
        let a = _Internal.fft_info<mod_998_244_353>()
        let b = _Internal.fft_info_998_244_353
        let c = _Internal.__static_const_fft_info.info(mod_998_244_353.self)
        XCTAssertEqual(a.root, b.root)
        XCTAssertEqual(a.iroot, b.iroot)
        XCTAssertEqual(a.rate2, b.rate2)
        XCTAssertEqual(a.irate2, b.irate2)
        XCTAssertEqual(a.rate3, b.rate3)
        XCTAssertEqual(a.irate3, b.irate3)
        XCTAssertEqual(a.root, c.root)
        XCTAssertEqual(a.iroot, c.iroot)
        XCTAssertEqual(a.rate2, c.rate2)
        XCTAssertEqual(a.irate2, c.irate2)
        XCTAssertEqual(a.rate3, c.rate3)
        XCTAssertEqual(a.irate3, c.irate3)
      }

      do {
        let a = _Internal.fft_info<mod_1_000_000_007>()
        let b = _Internal.fft_info_1_000_000_007
        XCTAssertEqual(a.root, b.root)
        XCTAssertEqual(a.iroot, b.iroot)
        XCTAssertEqual(a.rate2, b.rate2)
        XCTAssertEqual(a.irate2, b.irate2)
        XCTAssertEqual(a.rate3, b.rate3)
        XCTAssertEqual(a.irate3, b.irate3)
      }

      do {
        XCTAssertTrue(mod_754_974_721.isPrime)
        let a = _Internal.fft_info<mod_754_974_721>()
        let b = _Internal.fft_info_754_974_721
        let c = _Internal.__static_const_fft_info.info(mod_754_974_721.self)
        XCTAssertEqual(a.root, b.root)
        XCTAssertEqual(a.iroot, b.iroot)
        XCTAssertEqual(a.rate2, b.rate2)
        XCTAssertEqual(a.irate2, b.irate2)
        XCTAssertEqual(a.rate3, b.rate3)
        XCTAssertEqual(a.irate3, b.irate3)
        XCTAssertEqual(a.root, c.root)
        XCTAssertEqual(a.iroot, c.iroot)
        XCTAssertEqual(a.rate2, c.rate2)
        XCTAssertEqual(a.irate2, c.irate2)
        XCTAssertEqual(a.rate3, c.rate3)
        XCTAssertEqual(a.irate3, c.irate3)
      }

      do {
        XCTAssertTrue(mod_167_772_161.isPrime)
        let a = _Internal.fft_info<mod_167_772_161>()
        let b = _Internal.fft_info_167_772_161
        let c = _Internal.__static_const_fft_info.info(mod_167_772_161.self)
        XCTAssertEqual(a.root, b.root)
        XCTAssertEqual(a.iroot, b.iroot)
        XCTAssertEqual(a.rate2, b.rate2)
        XCTAssertEqual(a.irate2, b.irate2)
        XCTAssertEqual(a.rate3, b.rate3)
        XCTAssertEqual(a.irate3, b.irate3)
        XCTAssertEqual(a.root, c.root)
        XCTAssertEqual(a.iroot, c.iroot)
        XCTAssertEqual(a.rate2, c.rate2)
        XCTAssertEqual(a.irate2, c.irate2)
        XCTAssertEqual(a.rate3, c.rate3)
        XCTAssertEqual(a.irate3, c.irate3)
      }

      do {
        XCTAssertTrue(mod_469_762_049.isPrime)
        let a = _Internal.fft_info<mod_469_762_049>()
        let b = _Internal.fft_info_469_762_049
        let c = _Internal.__static_const_fft_info.info(mod_469_762_049.self)
        XCTAssertEqual(a.root, b.root)
        XCTAssertEqual(a.iroot, b.iroot)
        XCTAssertEqual(a.rate2, b.rate2)
        XCTAssertEqual(a.irate2, b.irate2)
        XCTAssertEqual(a.rate3, b.rate3)
        XCTAssertEqual(a.irate3, b.irate3)
        XCTAssertEqual(a.root, c.root)
        XCTAssertEqual(a.iroot, c.iroot)
        XCTAssertEqual(a.rate2, c.rate2)
        XCTAssertEqual(a.irate2, c.irate2)
        XCTAssertEqual(a.rate3, c.rate3)
        XCTAssertEqual(a.irate3, c.irate3)
      }

    #endif
  }

  func testStress0() throws {
    typealias mint = modint998244353
    // std::mt19937 mt;
    let n = 524288
    let m = 524288
    #if false
      let mt = { mint(CInt.random(in: 0...CInt.max)) }
      var a = [mint](repeating: 0, count: n)
      var b = [mint](repeating: 0, count: m)

      for i in 0..<n {
        a[i] = mt()
      }
      for i in 0..<m {
        b[i] = mt()
      }
    #else
      let a = (0..<n).map { mint($0) }
      let b = (0..<m).map { mint($0) }
    #endif

    self.measure {

      _ = convolution(a, b)
    }
  }
}

#if DEBUG
  extension _Internal {

    @usableFromInline
    nonisolated(unsafe) static var fft_info_1_000_000_007: fft_info<mod_1_000_000_007> =
      fft_info<mod_1_000_000_007>(
        root: [1, 1_000_000_006],
        iroot: [1, 1_000_000_006],
        rate2: [],
        irate2: [],
        rate3: [],
        irate3: []
      )
  }

#endif
