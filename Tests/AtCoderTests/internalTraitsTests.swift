import XCTest

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

final class internalTraitsTests: XCTestCase {

  func testHandleUnsigned() throws {

    XCTAssertEqual(UInt32(4_294_967_293), Int32(-3).unsigned)
    XCTAssertEqual(UInt64(18_446_744_073_709_551_613), Int64(-3).unsigned)
    XCTAssertEqual(UInt(18_446_744_073_709_551_613), Int(-3).unsigned)

    XCTAssertEqual(UInt32(3), UInt32(3).unsigned)
    XCTAssertEqual(UInt64(3), UInt64(3).unsigned)
    XCTAssertEqual(UInt(3), UInt(3).unsigned)
  }

}
