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

  func testPerformanceExample1() throws {
    throw XCTSkip()
    // This is an example of a performance test case.
    var a: CUnsignedLongLong = 0
    self.measure {
      // Put the code you want to measure the time of here.
      //          for i in 0 ..< CUnsignedInt(100_000_000) {
      var i = CUnsignedInt(0)
      while i < 100_000_000 {
        defer { i += 1 }
        a = CUnsignedLongLong(i)
      }
    }
    print(a)
  }

  func testPerformanceExample2() throws {
    throw XCTSkip()
    // This is an example of a performance test case.
    var a: CUnsignedLongLong = 0
    self.measure {
      // Put the code you want to measure the time of here.
      //        for i in 0 ..< CUnsignedInt(100_000_000) {
      var i = CUnsignedInt(0)
      while i < 100_000_000 {
        defer { i += 1 }
        a = CUnsignedLongLong(truncatingIfNeeded: i)
      }
    }
    print(a)
  }

  func testPerformanceExample3() throws {
    throw XCTSkip()
    // This is an example of a performance test case.
    var a: CUnsignedInt = 0
    self.measure {
      // Put the code you want to measure the time of here.
      //        for i in 0 ..< CUnsignedLongLong(100_000_000) {
      var i = CUnsignedLongLong(0)
      while i < 100_000_000 {
        defer { i += 1 }
        a = CUnsignedInt(i)
      }
    }
    print(a)
  }

  func testPerformanceExample4() throws {
    throw XCTSkip()
    // This is an example of a performance test case.
    var a: CUnsignedInt = 0
    self.measure {
      // Put the code you want to measure the time of here.
      //      for i in 0 ..< CUnsignedLongLong(100_000_000) {
      var i = CUnsignedLongLong(0)
      while i < 100_000_000 {
        defer { i += 1 }
        a = CUnsignedInt(truncatingIfNeeded: i)
      }
    }
    print(a)
  }

  func testPerformanceExample5() throws {
    throw XCTSkip()
    // This is an example of a performance test case.
    var a = 0
    self.measure {
      // Put the code you want to measure the time of here.
      for i in 0 ..< 1_000_000_000 {
        a = (a + i) % 1_000_000_007
      }
    } // 4.16 sec
    print(a)
  }

  func testPerformanceExample6() throws {
    throw XCTSkip()
    // This is an example of a performance test case.
    var a = 0
    self.measure {
      // Put the code you want to measure the time of here.
      //      for i in 0 ..< CUnsignedLongLong(100_000_000) {
      var i = 0
      while i < 1_000_000_000 {
        defer { i += 1 }
        a = (a + i) % 1_000_000_007
      }
    } // 3.94 sec
    // 5%程度早くなる模様
    print(a)
  }

}
