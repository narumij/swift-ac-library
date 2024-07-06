import XCTest
#if DEBUG
@testable import AtCoder
#else
import AtCoder
#endif

final class bitTests: XCTestCase {

#if DEBUG
    func testBitCeil() throws {
        XCTAssertEqual(1, _Internal.bit_ceil(0))
        XCTAssertEqual(1, _Internal.bit_ceil(1))
        XCTAssertEqual(2, _Internal.bit_ceil(2))
        XCTAssertEqual(4, _Internal.bit_ceil(3))
        XCTAssertEqual(4, _Internal.bit_ceil(4))
        XCTAssertEqual(8, _Internal.bit_ceil(5))
        XCTAssertEqual(8, _Internal.bit_ceil(6))
        XCTAssertEqual(8, _Internal.bit_ceil(7))
        XCTAssertEqual(8, _Internal.bit_ceil(8))
        XCTAssertEqual(16, _Internal.bit_ceil(9))
        XCTAssertEqual(1 << 30, _Internal.bit_ceil(1 << 30))
        XCTAssertEqual(1 << 31, _Internal.bit_ceil((1 << 30) + 1))
        XCTAssertEqual(1 << 31, _Internal.bit_ceil((1 << 31) - 1))
        XCTAssertEqual(1 << 31, _Internal.bit_ceil(1 << 31))
    }
    
    func testCountrZero() throws {
        XCTAssertEqual(0, _Internal.countr_zero(1))
        XCTAssertEqual(1, _Internal.countr_zero(2))
        XCTAssertEqual(0, _Internal.countr_zero(3))
        XCTAssertEqual(2, _Internal.countr_zero(4))
        XCTAssertEqual(0, _Internal.countr_zero(5))
        XCTAssertEqual(1, _Internal.countr_zero(6))
        XCTAssertEqual(0, _Internal.countr_zero(7))
        XCTAssertEqual(3, _Internal.countr_zero(8))
        XCTAssertEqual(0, _Internal.countr_zero(9))
        XCTAssertEqual(30, _Internal.countr_zero(1 << 30))
        XCTAssertEqual(0, _Internal.countr_zero((1 << 31) - 1))
        XCTAssertEqual(31, _Internal.countr_zero(1 << 31))
        XCTAssertEqual(0, _Internal.countr_zero(CUnsignedInt(CInt.max)))
    }
    
    func testCountrZeroConstexpr() throws {
        XCTAssertEqual(0, _Internal.countr_zero_constexpr(1))
        XCTAssertEqual(1, _Internal.countr_zero_constexpr(2))
        XCTAssertEqual(0, _Internal.countr_zero_constexpr(3))
        XCTAssertEqual(2, _Internal.countr_zero_constexpr(4))
        XCTAssertEqual(0, _Internal.countr_zero_constexpr(5))
        XCTAssertEqual(1, _Internal.countr_zero_constexpr(6))
        XCTAssertEqual(0, _Internal.countr_zero_constexpr(7))
        XCTAssertEqual(3, _Internal.countr_zero_constexpr(8))
        XCTAssertEqual(0, _Internal.countr_zero_constexpr(9))
        XCTAssertEqual(30, _Internal.countr_zero_constexpr(1 << 30))
        XCTAssertEqual(0, _Internal.countr_zero_constexpr((1 << 31) - 1))
        XCTAssertEqual(31, _Internal.countr_zero_constexpr(1 << 31))
        XCTAssertEqual(0, _Internal.countr_zero_constexpr(UInt32(CInt.max)))
    }
#endif
}
