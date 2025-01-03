import XCTest

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

//private typealias uint = CUnsignedInt
//private typealias ll = CLongLong
//private typealias ull = CUnsignedLongLong

extension Array where Element: AdditiveArithmetic {
  fileprivate mutating func resize(_ n: Int) {
    if count > n {
      removeLast(count - n)
    } else {
      reserveCapacity(n)
      for _ in 0..<(n - count) {
        append(.zero)
      }
    }
  }
}

final class internalConvolutionTests: XCTestCase {

  #if DEBUG
    func testFFTINFO() throws {
      typealias mint = modint998244353
      #if true
        let info = _Internal.fft_info<mint.static_mod>()
      #else
        let info = _Internal.fft_info<mint>()
      #endif
      //        XCTAssertEqual( info.g, 3 )
      //        XCTAssertEqual( info.rank2, 23 )
      XCTAssertEqual(
        info.root,
        [
          1, 998_244_352, 911_660_635, 372_528_824, 929_031_873, 452_798_380, 922_799_308,
          781_712_469, 476_477_967, 166_035_806, 258_648_936, 584_193_783, 63_912_897, 350_007_156,
          666_702_199, 968_855_178, 629_671_588, 24_514_907, 996_173_970, 363_395_222, 565_042_129,
          733_596_141, 267_099_868, 15_311_432,
        ])
      XCTAssertEqual(
        info.iroot,
        [
          1, 998_244_352, 86_583_718, 509_520_358, 337_190_230, 87_557_064, 609_441_965,
          135_236_158, 304_459_705, 685_443_576, 381_598_368, 335_559_352, 129_292_727, 358_024_708,
          814_576_206, 708_402_881, 283_043_518, 3_707_709, 121_392_023, 704_923_114, 950_391_366,
          428_961_804, 382_752_275, 469_870_224,
        ])
      XCTAssertEqual(
        info.rate2,
        [
          911_660_635, 509_520_358, 369_330_050, 332_049_552, 983_190_778, 123_842_337, 238_493_703,
          975_955_924, 603_855_026, 856_644_456, 131_300_601, 842_657_263, 730_768_835, 942_482_514,
          806_263_778, 151_565_301, 510_815_449, 503_497_456, 743_006_876, 741_047_443, 56_250_497,
          867_605_899,
        ])
      XCTAssertEqual(
        info.irate2,
        [
          86_583_718, 372_528_824, 373_294_451, 645_684_063, 112_220_581, 692_852_209, 155_456_985,
          797_128_860, 90_816_748, 860_285_882, 927_414_960, 354_738_543, 109_331_171, 293_255_632,
          535_113_200, 308_540_755, 121_186_627, 608_385_704, 438_932_459, 359_477_183, 824_071_951,
          103_369_235,
        ])
      XCTAssertEqual(
        info.rate3,
        [
          372_528_824, 337_190_230, 454_590_761, 816_400_692, 578_227_951, 180_142_363, 83_780_245,
          6_597_683, 70_046_822, 623_238_099, 183_021_267, 402_682_409, 631_680_428, 344_509_872,
          689_220_186, 365_017_329, 774_342_554, 729_444_058, 102_986_190, 128_751_033, 395_565_204,
        ])
      XCTAssertEqual(
        info.irate3,
        [
          509_520_358, 929_031_873, 170_256_584, 839_780_419, 282_974_284, 395_914_482, 444_904_435,
          72_135_471, 638_914_820, 66_769_500, 771_127_074, 985_925_487, 262_319_669, 262_341_272,
          625_870_173, 768_022_760, 859_816_005, 914_661_783, 430_819_711, 272_774_365, 530_924_681,
        ])
    }

    func testButterFly() throws {

      typealias mint = modint998244353
      let aa = [
        64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 937_240_163, 844_177_527, 312_516_614, 907_986_010, 702_634_021, 730_282_913,
        931_923_951, 605_818_204, 641_355_466, 159_687_040, 341_829_885, 438_319_871, 59_099_019,
        205_095_211, 954_849_985, 627_156_693, 415_058_905, 409_973_981, 650_539_286, 14_374_892,
        768_786_505, 131_911_124, 663_355_508, 632_199_223, 173_280_691, 46_051_172, 762_201_933,
        368_055_233, 747_939_028, 334_477_722, 264_383_240, 413_402_747, 584_841_608, 733_861_115,
        663_766_633, 250_305_327, 630_189_122, 236_042_422, 952_193_183, 824_963_664, 366_045_132,
        334_888_847, 866_333_231, 229_457_850, 983_869_463, 347_705_069, 588_270_374, 583_185_450,
        371_087_662, 43_394_370, 793_149_144, 939_145_336, 559_924_484, 656_414_470, 838_557_315,
        356_888_889, 392_426_151, 66_320_404, 267_961_442, 295_610_334, 90_258_345, 685_727_741,
        154_066_828, 61_004_192, 182_174_378, 588_297_792, 330_562_635, 941_424_244, 648_224_307,
        379_494_192, 603_869_647, 46_037_480, 302_949_417, 886_758_349, 84_601_358, 314_327_041,
        464_294_843, 359_103_670, 714_969_594, 82_646_597, 245_825_581, 394_914_908, 153_521_122,
        434_697_896, 927_192_765, 878_592_788, 542_627_112, 380_920_307, 407_603_456, 912_502_322,
        939_008_843, 621_711_858, 792_856_151, 441_310_072, 586_694_289, 324_184_798, 289_986_230,
        561_320_374, 769_546_129, 129_921_357, 341_212_160, 81_974_405, 185_617_561, 399_758_327,
        46_224_114, 784_159_542, 527_693_515, 299_019_615, 533_760_318, 678_323_534, 164_461_761,
        612_559_139, 455_936_488, 2_046_772, 211_342_662, 95_004_224, 611_157_530, 802_328_218,
        260_120_844, 247_958_822, 398_063_168, 733_585_656, 763_194_519, 856_531_878, 957_632_147,
        895_755_087, 863_288_081, 472_191_018, 62_856_033, 272_650_138, 368_237_972, 783_215_348,
        277_671_502, 499_932_017, 283_773_745, 177_073_942, 254_101_364, 342_944_755, 851_056_999,
        861_346_155, 884_680_510, 154_640_951, 719_575_195, 216_923_602, 813_754_207, 522_189_519,
        102_909_044, 607_540_711, 979_548_514, 408_419_287, 646_356_565, 469_775_353, 480_429_161,
        901_273_862, 559_313_830, 386_115_435, 186_822_735, 717_773_708, 508_924_422, 337_341_291,
        187_703_924, 293_938_696, 459_885_775, 687_901_750, 11_822_986, 965_539_859, 472_522_138,
        556_218_168, 57_745_503, 814_239_093, 274_578_207, 674_380_142, 789_601_849, 304_320_008,
        710_028_266, 471_322_563, 801_370_727, 607_930_328, 322_278_801, 460_593_082, 816_938_517,
        942_989_681, 338_990_461, 270_526_182, 583_736_505, 73_519_874, 552_238_621, 675_523_569,
        177_894_218, 230_814_526, 722_643_257, 994_914_212,
      ]
      let bb = [
        128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 98_920_802, 777_315_171, 13_164_392, 676_946_309, 884_361_374, 738_916_207,
        443_766_056, 373_961_611, 944_083_871, 461_184_171, 53_272_313, 409_049_160, 915_362_397,
        948_485_505, 20_455_549, 192_936_506, 686_163_654, 596_547_278, 760_861_750, 556_756_683,
        166_228_906, 517_430_864, 640_048_655, 236_591_087, 763_045_924, 353_396_467, 885_129_620,
        523_305_155, 18_370_684, 893_084_933, 206_171_876, 49_897_157, 864_305_575, 964_056_588,
        963_433_057, 854_759_258, 866_757_361, 434_321_211, 196_004_335, 830_989_802, 488_109_397,
        51_219_260, 32_690_511, 231_131_737, 837_880_243, 488_830_773, 553_932_878, 710_465_568,
        152_429_169, 194_132_213, 968_362_347, 121_984_350, 661_472_011, 862_931_855, 828_836_725,
        905_518_094, 134_405_509, 363_228_194, 176_678_785, 492_276_659, 87_833_082, 440_933_398,
        504_054_226, 322_751_268, 675_493_087, 494_190_129, 557_310_957, 910_411_273, 505_967_696,
        821_565_570, 635_016_161, 863_838_846, 92_726_261, 169_407_630, 135_312_500, 336_772_344,
        876_260_005, 29_882_008, 804_112_142, 845_815_186, 287_778_787, 444_311_477, 509_413_582,
        160_364_112, 767_112_618, 965_553_844, 947_025_095, 510_134_958, 167_254_553, 802_240_020,
        563_923_144, 131_486_994, 143_485_097, 34_811_298, 34_187_767, 133_938_780, 948_347_198,
        792_072_479, 105_159_422, 979_873_671, 474_939_200, 113_114_735, 644_847_888, 235_198_431,
        761_653_268, 358_195_700, 480_813_491, 832_015_449, 441_487_672, 237_382_605, 401_697_077,
        312_080_701, 805_307_849, 977_788_806, 49_758_850, 82_881_958, 589_195_195, 944_972_042,
        537_060_184, 54_160_484, 624_282_744, 554_478_299, 259_328_148, 113_882_981, 321_298_046,
        985_079_963, 220_929_184, 899_323_553,
      ]

      var a = repeatElement(1, count: 64).map { mint($0) }
      var b = repeatElement(1, count: 128).map { mint($0) }
      let n = CInt(a.count)
      let m = CInt(b.count)
      let z: CInt = _Internal.bit_ceil(CUnsignedInt(n + m - 1))
      a.resize(Int(z))
      a.withUnsafeMutableBufferPointer { a in
        _Internal.butterfly(a)
      }
      b.resize(Int(z))
      b.withUnsafeMutableBufferPointer { b in
        _Internal.butterfly(b)
      }
      let ai = a.map { Int($0.val) }
      let bi = b.map { Int($0.val) }
      XCTAssertEqual(a.count, aa.count)
      XCTAssertEqual(ai, aa)
      XCTAssertEqual(b.count, bb.count)
      XCTAssertEqual(bi, bb)
    }
  #endif
  
  func testSimpleInt128() throws {
    if #available(macOS 15.0, *) {
      enum MOD2: static_mod_value { nonisolated(unsafe) static let mod: mod_value = 924_844_033 }
      let a: [Int128] = [924844023, 924844024, ]
      let b: [Int128] = [924844023, 924844024, 924844025, 924844026, 924844027, 924844028, ]
      let c: [Int128] = [100, 180, 161, 142, 123, 104, 45, ]
      let n = 2
      let m = 6
      XCTAssertEqual(conv_naive(MOD2.self, a, b), c, "n:\(n), m:\(m)")
    }
    else {
      
    }
  }
  
}
