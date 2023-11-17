import XCTest
@testable import atcoder

fileprivate typealias uint = CUnsignedInt;
fileprivate typealias ll = CLongLong;
fileprivate typealias ull = CUnsignedLongLong;

fileprivate func compileCheckAboutModintTypes() {
    
    enum mod1: dynamic_mod { static var modValue: barrett = -1 }
    mod1.set_mod(2)
    typealias modint1 = internal_modint<mod1>
    
    enum mod2: dynamic_mod { static var modValue: barrett = -1 }
    mod2.set_mod(5)
    typealias modint2 = internal_modint<mod2>
    
    enum mod3: dynamic_mod { static var modValue: barrett = -1 }
    mod3.set_mod(7)
    typealias modint3 = internal_modint<mod3>
}


final class etcTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
