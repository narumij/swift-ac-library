import XCTest
@testable import atcoder

final class atcoderTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
        
        XCTAssertTrue((0..<0).isEmpty)
        XCTAssertFalse((0...0).isEmpty)
        
        do {
            let log = 0
            XCTAssertEqual([], (1..<=log).map{$0})
            XCTAssertEqual([], (log..>=1).map{$0})
            XCTAssertEqual([], ((log - 1)..>=1).map{$0})
        }

        do {
            let log = 1
            XCTAssertEqual([1], (1..<=log).map{$0})
            XCTAssertEqual([1], (log..>=1).map{$0})
            XCTAssertEqual([], ((log - 1)..>=1).map{$0})
        }

        do {
            let log = 2
            XCTAssertEqual([1,2], (1..<=log).map{$0})
            XCTAssertEqual([2,1], (log..>=1).map{$0})
            XCTAssertEqual([1], ((log - 1)..>=1).map{$0})
        }
    }
}
