//
//  bitTests.swift
//  
//
//  Created by narumij on 2023/11/11.
//

import XCTest
@testable import AtCoder

final class bitTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBitCeil() throws {
        XCTAssertEqual(1, _Internal.bit_ceil(0));
        XCTAssertEqual(1, _Internal.bit_ceil(1));
        XCTAssertEqual(2, _Internal.bit_ceil(2));
        XCTAssertEqual(4, _Internal.bit_ceil(3));
        XCTAssertEqual(4, _Internal.bit_ceil(4));
        XCTAssertEqual(8, _Internal.bit_ceil(5));
        XCTAssertEqual(8, _Internal.bit_ceil(6));
        XCTAssertEqual(8, _Internal.bit_ceil(7));
        XCTAssertEqual(8, _Internal.bit_ceil(8));
        XCTAssertEqual(16, _Internal.bit_ceil(9));
        XCTAssertEqual(1 << 30, _Internal.bit_ceil(1 << 30));
        XCTAssertEqual(1 << 31, _Internal.bit_ceil((1 << 30) + 1));
        XCTAssertEqual(1 << 31, _Internal.bit_ceil((1 << 31) - 1));
        XCTAssertEqual(1 << 31, _Internal.bit_ceil(1 << 31));
    }
    
    func testCountrZero() throws {
        XCTAssertEqual(0, _Internal.countr_zero(1));
        XCTAssertEqual(1, _Internal.countr_zero(2));
        XCTAssertEqual(0, _Internal.countr_zero(3));
        XCTAssertEqual(2, _Internal.countr_zero(4));
        XCTAssertEqual(0, _Internal.countr_zero(5));
        XCTAssertEqual(1, _Internal.countr_zero(6));
        XCTAssertEqual(0, _Internal.countr_zero(7));
        XCTAssertEqual(3, _Internal.countr_zero(8));
        XCTAssertEqual(0, _Internal.countr_zero(9));
        XCTAssertEqual(30, _Internal.countr_zero(1 << 30));
        XCTAssertEqual(0, _Internal.countr_zero((1 << 31) - 1));
        XCTAssertEqual(31, _Internal.countr_zero(1 << 31));
        XCTAssertEqual(0, _Internal.countr_zero(CUnsignedInt(CInt.max)));
    }
    
    func testCountrZeroConstexpr() throws {
        throw XCTSkip("未実装")
/*
        XCTAssertEqual(0, _Internal.countr_zero_constexpr(1));
        XCTAssertEqual(1, _Internal.countr_zero_constexpr(2));
        XCTAssertEqual(0, _Internal.countr_zero_constexpr(3));
        XCTAssertEqual(2, _Internal.countr_zero_constexpr(4));
        XCTAssertEqual(0, _Internal.countr_zero_constexpr(5));
        XCTAssertEqual(1, _Internal.countr_zero_constexpr(6));
        XCTAssertEqual(0, _Internal.countr_zero_constexpr(7));
        XCTAssertEqual(3, _Internal.countr_zero_constexpr(8));
        XCTAssertEqual(0, _Internal.countr_zero_constexpr(9));
        XCTAssertEqual(30, _Internal.countr_zero_constexpr(1 << 30));
        XCTAssertEqual(0, _Internal.countr_zero_constexpr((1 << 31) - 1));
        XCTAssertEqual(31, _Internal.countr_zero_constexpr(1 << 31));
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
