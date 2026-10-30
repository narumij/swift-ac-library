import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

extension LibraryTests {
  final class internalTraitsTests {

    @Test(.tags(.swiftSpecific))
    func testHandleUnsigned() throws {

      #expect(UInt32(4_294_967_293) == Int32(-3).unsigned)
      #expect(UInt64(18_446_744_073_709_551_613) == Int64(-3).unsigned)
      #expect(UInt(18_446_744_073_709_551_613) == Int(-3).unsigned)

      #expect(UInt32(3) == UInt32(3).unsigned)
      #expect(UInt64(3) == UInt64(3).unsigned)
      #expect(UInt(3) == UInt(3).unsigned)
    }

  }

}
