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
        XCTAssertEqual(1, `internal`.bit_ceil(0));
        XCTAssertEqual(1, `internal`.bit_ceil(1));
        XCTAssertEqual(2, `internal`.bit_ceil(2));
        XCTAssertEqual(4, `internal`.bit_ceil(3));
        XCTAssertEqual(4, `internal`.bit_ceil(4));
        XCTAssertEqual(8, `internal`.bit_ceil(5));
        XCTAssertEqual(8, `internal`.bit_ceil(6));
        XCTAssertEqual(8, `internal`.bit_ceil(7));
        XCTAssertEqual(8, `internal`.bit_ceil(8));
        XCTAssertEqual(16, `internal`.bit_ceil(9));
        XCTAssertEqual(1 << 30, `internal`.bit_ceil(1 << 30));
        XCTAssertEqual(1 << 31, `internal`.bit_ceil((1 << 30) + 1));
        XCTAssertEqual(1 << 31, `internal`.bit_ceil((1 << 31) - 1));
        XCTAssertEqual(1 << 31, `internal`.bit_ceil(1 << 31));
    }
    
    func testCountrZero() throws {
        XCTAssertEqual(0, `internal`.countr_zero(1));
        XCTAssertEqual(1, `internal`.countr_zero(2));
        XCTAssertEqual(0, `internal`.countr_zero(3));
        XCTAssertEqual(2, `internal`.countr_zero(4));
        XCTAssertEqual(0, `internal`.countr_zero(5));
        XCTAssertEqual(1, `internal`.countr_zero(6));
        XCTAssertEqual(0, `internal`.countr_zero(7));
        XCTAssertEqual(3, `internal`.countr_zero(8));
        XCTAssertEqual(0, `internal`.countr_zero(9));
        XCTAssertEqual(30, `internal`.countr_zero(1 << 30));
        XCTAssertEqual(0, `internal`.countr_zero((1 << 31) - 1));
        XCTAssertEqual(31, `internal`.countr_zero(1 << 31));
        XCTAssertEqual(0, `internal`.countr_zero(CUnsignedInt(CInt.max)));
    }
    
    func testCountrZeroConstexpr() throws {
        
        throw XCTSkip("未テスト。そのうちやる。")
        
        /*
         ASSERT_EQ(0, internal::countr_zero_constexpr(1U));
         ASSERT_EQ(1, internal::countr_zero_constexpr(2U));
         ASSERT_EQ(0, internal::countr_zero_constexpr(3U));
         ASSERT_EQ(2, internal::countr_zero_constexpr(4U));
         ASSERT_EQ(0, internal::countr_zero_constexpr(5U));
         ASSERT_EQ(1, internal::countr_zero_constexpr(6U));
         ASSERT_EQ(0, internal::countr_zero_constexpr(7U));
         ASSERT_EQ(3, internal::countr_zero_constexpr(8U));
         ASSERT_EQ(0, internal::countr_zero_constexpr(9U));
         ASSERT_EQ(30, internal::countr_zero_constexpr(1U << 30));
         ASSERT_EQ(0, internal::countr_zero_constexpr((1U << 31) - 1));
         ASSERT_EQ(31, internal::countr_zero_constexpr(1U << 31));
         ASSERT_EQ(0,
                   internal::countr_zero_constexpr(std::numeric_limits<unsigned int>::max()));
         */
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
