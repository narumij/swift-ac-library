//
//  etcTests.swift
//  swift-ac-library
//
//  Created by narumij on 2024/09/25.
//

import Testing

extension LibraryTests {
  final class etcTests {

    @Test(.tags(.swiftSpecific))
    func testExample() throws {
      #expect(-1 == ~0)
      #expect(0 != ~0.trailingZeroBitCount)
      #expect(0 == (~0).trailingZeroBitCount)
    }

    @Test(.disabled("Previously skipped performance example"), .tags(.swiftSpecific))
    func testPerformanceExample1() throws {
      // This is an example of a performance test case.
      var a: CUnsignedLongLong = 0
      measureRepeated {
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

    @Test(.disabled("Previously skipped performance example"), .tags(.swiftSpecific))
    func testPerformanceExample2() throws {
      // This is an example of a performance test case.
      var a: CUnsignedLongLong = 0
      measureRepeated {
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

    @Test(.disabled("Previously skipped performance example"), .tags(.swiftSpecific))
    func testPerformanceExample3() throws {
      // This is an example of a performance test case.
      var a: CUnsignedInt = 0
      measureRepeated {
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

    @Test(.disabled("Previously skipped performance example"), .tags(.swiftSpecific))
    func testPerformanceExample4() throws {
      // This is an example of a performance test case.
      var a: CUnsignedInt = 0
      measureRepeated {
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

    @Test(.disabled("Previously skipped performance example"), .tags(.swiftSpecific))
    func testPerformanceExample5() throws {
      // This is an example of a performance test case.
      var a = 0
      measureRepeated {
        // Put the code you want to measure the time of here.
        for i in 0..<1_000_000_000 {
          a = (a + i) % 1_000_000_007
        }
      }  // 4.16 sec
      print(a)
    }

    @Test(.disabled("Previously skipped performance example"), .tags(.swiftSpecific))
    func testPerformanceExample6() throws {
      // This is an example of a performance test case.
      var a = 0
      measureRepeated {
        // Put the code you want to measure the time of here.
        //      for i in 0 ..< CUnsignedLongLong(100_000_000) {
        var i = 0
        while i < 1_000_000_000 {
          defer { i += 1 }
          a = (a + i) % 1_000_000_007
        }
      }  // 3.94 sec
      // 5%程度早くなる模様
      print(a)
    }

  }

}
