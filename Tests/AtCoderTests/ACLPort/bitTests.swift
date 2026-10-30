import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

extension LibraryTests {
  final class bitTests {

    #if DEBUG
      @Test(.tags(.aclPort))
      func testBitCeil() throws {
        #expect(1 == _Internal.bit_ceil(0))
        #expect(1 == _Internal.bit_ceil(1))
        #expect(2 == _Internal.bit_ceil(2))
        #expect(4 == _Internal.bit_ceil(3))
        #expect(4 == _Internal.bit_ceil(4))
        #expect(8 == _Internal.bit_ceil(5))
        #expect(8 == _Internal.bit_ceil(6))
        #expect(8 == _Internal.bit_ceil(7))
        #expect(8 == _Internal.bit_ceil(8))
        #expect(16 == _Internal.bit_ceil(9))
        #expect(1 << 30 == _Internal.bit_ceil(1 << 30))
        #expect(1 << 31 == _Internal.bit_ceil((1 << 30) + 1))
        #expect(1 << 31 == _Internal.bit_ceil((1 << 31) - 1))
        #expect(1 << 31 == _Internal.bit_ceil(1 << 31))
      }

      @Test(.tags(.aclPort))
      func testCountrZero() throws {
        #expect(0 == (1).trailingZeroBitCount)
        #expect(1 == (2).trailingZeroBitCount)
        #expect(0 == (3).trailingZeroBitCount)
        #expect(2 == (4).trailingZeroBitCount)
        #expect(0 == (5).trailingZeroBitCount)
        #expect(1 == (6).trailingZeroBitCount)
        #expect(0 == (7).trailingZeroBitCount)
        #expect(3 == (8).trailingZeroBitCount)
        #expect(0 == (9).trailingZeroBitCount)
        #expect(30 == (1 << 30).trailingZeroBitCount)
        #expect(0 == ((1 << 31) - 1).trailingZeroBitCount)
        #expect(31 == (1 << 31).trailingZeroBitCount)
        #expect(0 == (CInt.max).trailingZeroBitCount)
      }

      @Test(.tags(.aclPort))
      func testCountrZeroConstexpr() throws {
        #expect(0 == (1).trailingZeroBitCount)
        #expect(1 == (2).trailingZeroBitCount)
        #expect(0 == (3).trailingZeroBitCount)
        #expect(2 == (4).trailingZeroBitCount)
        #expect(0 == (5).trailingZeroBitCount)
        #expect(1 == (6).trailingZeroBitCount)
        #expect(0 == (7).trailingZeroBitCount)
        #expect(3 == (8).trailingZeroBitCount)
        #expect(0 == (9).trailingZeroBitCount)
        #expect(30 == (1 << 30).trailingZeroBitCount)
        #expect(0 == ((1 << 31) - 1).trailingZeroBitCount)
        #expect(31 == (1 << 31).trailingZeroBitCount)
        #expect(0 == (UInt32(CInt.max)).trailingZeroBitCount)
      }
    #endif
  }

}
