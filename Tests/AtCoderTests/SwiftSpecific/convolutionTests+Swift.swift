import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

extension LibraryTests.convolutionTests {
  @Test(.tags(.swiftSpecific))
  func testInfo_998_244_353() throws {

    #if DEBUG
      do {
        let a = _Internal.fft_info<mod_998_244_353>()
        let b = _Internal.fft_info_998_244_353
        let c = _Internal.__static_const_fft_info.info(mod_998_244_353.self)
        #expect(a.root == b.root)
        #expect(a.iroot == b.iroot)
        #expect(a.rate2 == b.rate2)
        #expect(a.irate2 == b.irate2)
        #expect(a.rate3 == b.rate3)
        #expect(a.irate3 == b.irate3)
        #expect(a.root == c.root)
        #expect(a.iroot == c.iroot)
        #expect(a.rate2 == c.rate2)
        #expect(a.irate2 == c.irate2)
        #expect(a.rate3 == c.rate3)
        #expect(a.irate3 == c.irate3)
      }

      do {
        let a = _Internal.fft_info<mod_1_000_000_007>()
        let b = _Internal.fft_info_1_000_000_007
        #expect(a.root == b.root)
        #expect(a.iroot == b.iroot)
        #expect(a.rate2 == b.rate2)
        #expect(a.irate2 == b.irate2)
        #expect(a.rate3 == b.rate3)
        #expect(a.irate3 == b.irate3)
      }

      do {
        #expect(mod_754_974_721.isPrime)
        let a = _Internal.fft_info<mod_754_974_721>()
        let b = _Internal.fft_info_754_974_721
        let c = _Internal.__static_const_fft_info.info(mod_754_974_721.self)
        #expect(a.root == b.root)
        #expect(a.iroot == b.iroot)
        #expect(a.rate2 == b.rate2)
        #expect(a.irate2 == b.irate2)
        #expect(a.rate3 == b.rate3)
        #expect(a.irate3 == b.irate3)
        #expect(a.root == c.root)
        #expect(a.iroot == c.iroot)
        #expect(a.rate2 == c.rate2)
        #expect(a.irate2 == c.irate2)
        #expect(a.rate3 == c.rate3)
        #expect(a.irate3 == c.irate3)
      }

      do {
        #expect(mod_167_772_161.isPrime)
        let a = _Internal.fft_info<mod_167_772_161>()
        let b = _Internal.fft_info_167_772_161
        let c = _Internal.__static_const_fft_info.info(mod_167_772_161.self)
        #expect(a.root == b.root)
        #expect(a.iroot == b.iroot)
        #expect(a.rate2 == b.rate2)
        #expect(a.irate2 == b.irate2)
        #expect(a.rate3 == b.rate3)
        #expect(a.irate3 == b.irate3)
        #expect(a.root == c.root)
        #expect(a.iroot == c.iroot)
        #expect(a.rate2 == c.rate2)
        #expect(a.irate2 == c.irate2)
        #expect(a.rate3 == c.rate3)
        #expect(a.irate3 == c.irate3)
      }

      do {
        #expect(mod_469_762_049.isPrime)
        let a = _Internal.fft_info<mod_469_762_049>()
        let b = _Internal.fft_info_469_762_049
        let c = _Internal.__static_const_fft_info.info(mod_469_762_049.self)
        #expect(a.root == b.root)
        #expect(a.iroot == b.iroot)
        #expect(a.rate2 == b.rate2)
        #expect(a.irate2 == b.irate2)
        #expect(a.rate3 == b.rate3)
        #expect(a.irate3 == b.irate3)
        #expect(a.root == c.root)
        #expect(a.iroot == c.iroot)
        #expect(a.rate2 == c.rate2)
        #expect(a.irate2 == c.irate2)
        #expect(a.rate3 == c.rate3)
        #expect(a.irate3 == c.irate3)
      }

    #endif
  }
  @Test(.tags(.swiftSpecific))
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

    measureRepeated {

      _ = convolution(a, b)
    }
  }
}
