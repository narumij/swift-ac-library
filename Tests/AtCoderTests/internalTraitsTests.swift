//
//  internalTraitsTests.swift
//  
//
//  Created by narumij on 2024/03/01.
//

import XCTest
@testable import AtCoder

final class internalTraitsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHandleUnsigned() throws {
        
        XCTAssertEqual(UInt32(4294967293), Int32(-3).unsigned)
        XCTAssertEqual(UInt64(18446744073709551613), Int64(-3).unsigned)
        XCTAssertEqual(UInt(18446744073709551613), Int(-3).unsigned)
        
        XCTAssertEqual(UInt32(3), UInt32(3).unsigned)
        XCTAssertEqual(UInt64(3), UInt64(3).unsigned)
        XCTAssertEqual(UInt(3), UInt(3).unsigned)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
