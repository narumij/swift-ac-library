//
//  bitTests.swift
//  
//
//  Created by narumij on 2023/11/11.
//

import XCTest
@testable import atcoder

final class bitTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBitCeil() throws {
        XCTAssertEqual(1, _internal.bit_ceil(0 as CUnsignedInt));
        XCTAssertEqual(1, _internal.bit_ceil(1 as CUnsignedInt));
        XCTAssertEqual(2, _internal.bit_ceil(2 as CUnsignedInt));
        XCTAssertEqual(4, _internal.bit_ceil(3 as CUnsignedInt));
        XCTAssertEqual(4, _internal.bit_ceil(4 as CUnsignedInt));
        XCTAssertEqual(8, _internal.bit_ceil(5 as CUnsignedInt));
        XCTAssertEqual(8, _internal.bit_ceil(6 as CUnsignedInt));
        XCTAssertEqual(8, _internal.bit_ceil(7 as CUnsignedInt));
        XCTAssertEqual(8, _internal.bit_ceil(8 as CUnsignedInt));
        XCTAssertEqual(16, _internal.bit_ceil(9 as CUnsignedInt));
        XCTAssertEqual(1 << 30, _internal.bit_ceil(1 << 30 as CUnsignedInt));
        XCTAssertEqual(1 << 31, _internal.bit_ceil((1 << 30) + 1 as CUnsignedInt));
        XCTAssertEqual(1 << 31, _internal.bit_ceil((1 << 31) - 1 as CUnsignedInt));
        XCTAssertEqual(1 << 31, _internal.bit_ceil(1 << 31 as CUnsignedInt));
    }
    
#if false
    func testBitCeil2() throws {
        XCTAssertEqual(1, _internal.bit_ceil(0 as UInt));
        XCTAssertEqual(1, _internal.bit_ceil(1 as UInt));
        XCTAssertEqual(2, _internal.bit_ceil(2 as UInt));
        XCTAssertEqual(4, _internal.bit_ceil(3 as UInt));
        XCTAssertEqual(4, _internal.bit_ceil(4 as UInt));
        XCTAssertEqual(8, _internal.bit_ceil(5 as UInt));
        XCTAssertEqual(8, _internal.bit_ceil(6 as UInt));
        XCTAssertEqual(8, _internal.bit_ceil(7 as UInt));
        XCTAssertEqual(8, _internal.bit_ceil(8 as UInt));
        XCTAssertEqual(16, _internal.bit_ceil(9 as UInt));
        XCTAssertEqual(1 << 30, _internal.bit_ceil(1 << 30 as UInt));
        XCTAssertEqual(1 << 31, _internal.bit_ceil((1 << 30) as UInt + 1));
        XCTAssertEqual(1 << 31, _internal.bit_ceil((1 << 31) as UInt - 1));
        XCTAssertEqual(1 << 31, _internal.bit_ceil(1 << 31 as UInt) as UInt);
    }
#endif
    
    func testCountrZero() throws {
        XCTAssertEqual(0, _internal.countr_zero(1));
        XCTAssertEqual(1, _internal.countr_zero(2));
        XCTAssertEqual(0, _internal.countr_zero(3));
        XCTAssertEqual(2, _internal.countr_zero(4));
        XCTAssertEqual(0, _internal.countr_zero(5));
        XCTAssertEqual(1, _internal.countr_zero(6));
        XCTAssertEqual(0, _internal.countr_zero(7));
        XCTAssertEqual(3, _internal.countr_zero(8));
        XCTAssertEqual(0, _internal.countr_zero(9));
        XCTAssertEqual(30, _internal.countr_zero(1 << 30));
        XCTAssertEqual(0, _internal.countr_zero((1 << 31) - 1));
        XCTAssertEqual(31, _internal.countr_zero(1 << 31));
        XCTAssertEqual(0, _internal.countr_zero(CUnsignedInt(CInt.max)));
    }
    
    func testCountrZeroConstexpr() throws {
        throw XCTSkip("未実装")
/*
        XCTAssertEqual(0, _internal.countr_zero_constexpr(1));
        XCTAssertEqual(1, _internal.countr_zero_constexpr(2));
        XCTAssertEqual(0, _internal.countr_zero_constexpr(3));
        XCTAssertEqual(2, _internal.countr_zero_constexpr(4));
        XCTAssertEqual(0, _internal.countr_zero_constexpr(5));
        XCTAssertEqual(1, _internal.countr_zero_constexpr(6));
        XCTAssertEqual(0, _internal.countr_zero_constexpr(7));
        XCTAssertEqual(3, _internal.countr_zero_constexpr(8));
        XCTAssertEqual(0, _internal.countr_zero_constexpr(9));
        XCTAssertEqual(30, _internal.countr_zero_constexpr(1 << 30));
        XCTAssertEqual(0, _internal.countr_zero_constexpr((1 << 31) - 1));
        XCTAssertEqual(31, _internal.countr_zero_constexpr(1 << 31));
        XCTAssertEqual(0,
                       _internal.countr_zero_constexpr(CInt.max);
 */
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
