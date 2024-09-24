//
//  etcTests.swift
//  swift-ac-library
//
//  Created by narumij on 2024/09/25.
//

import XCTest

final class etcTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCTAssertEqual(-1, ~0)
        XCTAssertNotEqual(0, ~0.trailingZeroBitCount)
        XCTAssertEqual(0, (~0).trailingZeroBitCount)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
