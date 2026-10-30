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
        #expect(0 == _Internal.countr_zero(1))
        #expect(1 == _Internal.countr_zero(2))
        #expect(0 == _Internal.countr_zero(3))
        #expect(2 == _Internal.countr_zero(4))
        #expect(0 == _Internal.countr_zero(5))
        #expect(1 == _Internal.countr_zero(6))
        #expect(0 == _Internal.countr_zero(7))
        #expect(3 == _Internal.countr_zero(8))
        #expect(0 == _Internal.countr_zero(9))
        #expect(30 == _Internal.countr_zero(1 << 30))
        #expect(0 == _Internal.countr_zero((1 << 31) - 1))
        #expect(31 == _Internal.countr_zero(1 << 31))
        #expect(0 == _Internal.countr_zero(CInt.max))
      }

      @Test(.tags(.aclPort))
      func testCountrZeroConstexpr() throws {
        #expect(0 == _Internal.countr_zero_constexpr(1))
        #expect(1 == _Internal.countr_zero_constexpr(2))
        #expect(0 == _Internal.countr_zero_constexpr(3))
        #expect(2 == _Internal.countr_zero_constexpr(4))
        #expect(0 == _Internal.countr_zero_constexpr(5))
        #expect(1 == _Internal.countr_zero_constexpr(6))
        #expect(0 == _Internal.countr_zero_constexpr(7))
        #expect(3 == _Internal.countr_zero_constexpr(8))
        #expect(0 == _Internal.countr_zero_constexpr(9))
        #expect(30 == _Internal.countr_zero_constexpr(1 << 30))
        #expect(0 == _Internal.countr_zero_constexpr((1 << 31) - 1))
        #expect(31 == _Internal.countr_zero_constexpr(1 << 31))
        #expect(0 == _Internal.countr_zero_constexpr(UInt32(CInt.max)))
      }
    #endif
  }

}
