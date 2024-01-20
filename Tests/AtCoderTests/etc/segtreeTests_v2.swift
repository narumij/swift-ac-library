//
//  ManagedBufferSegtreeTests.swift
//  
//
//  Created by narumij on 2023/12/03.
//

import XCTest
@testable import AtCoder

extension _Segtree._Storage {
    
    var array: [Base.S] { _buffer.d }
    
    subscript(index: Int) -> Base.S {
        get { _buffer.d[index] }
        nonmutating set { _buffer.d[index] = newValue }
    }
}

enum fixture: SegtreeParameter {
    static let op: (String,String) -> String = { a, b in
        assert(a == "$" || b == "$" || a <= b);
        if (a == "$") { return b; }
        if (b == "$") { return a; }
        return a + b;
    }
    static let e: String = "$"
    typealias S = String
}

protocol SegtreeFixture: _SegtreeProtocol { }

extension SegtreeFixture {
    static var op: (String,String) -> String { { a, b in
        assert(a == "$" || b == "$" || a <= b);
        if (a == "$") { return b; }
        if (b == "$") { return a; }
        return a + b;
    } }
    static var e: String { "$" }
}


final class segtreeTests_v2: XCTestCase {

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
    
    struct segtree: SegtreeProtocol, SegtreeFixture {
        var storage: Storage
    }
    
    func test0() {
        XCTAssertEqual("$", segtree(0).allProd())
        XCTAssertEqual("$", segtree().allProd())
    }
    
    func testInvalid() throws {
        
        throw XCTSkip("配列のfatalをSwiftのみでハンドリングする方法が、まだない。SE-0403以後に、テストするように切り替えます。")
        
        XCTAssertThrowsError(segtree_naive_v0<fixture>(-1))
        
        let s = segtree(10)
        
        XCTAssertThrowsError(s.get(-1))
        XCTAssertThrowsError(s.get(10))
        
        XCTAssertThrowsError(s.prod(-1,-1))
        
        XCTAssertThrowsError(s.prod(3,2))
        XCTAssertThrowsError(s.prod(0,11))
        XCTAssertThrowsError(s.prod(-1,11))

        XCTAssertThrowsError(s.maxRight(11, { _ in true }))
        XCTAssertThrowsError(s.minLeft(-1, { _ in true }))
        XCTAssertThrowsError(s.maxRight(0, { _ in false }))
    }
    
    func testOne() throws {
        var s = segtree(1)
        XCTAssertEqual("$", s.allProd());
        XCTAssertEqual("$", s.get(0));
        XCTAssertEqual("$", s.prod(0, 1));
        s.set(0, "dummy");
        XCTAssertEqual("dummy", s.get(0));
        XCTAssertEqual("$", s.prod(0, 0));
        XCTAssertEqual("dummy", s.prod(0, 1));
        XCTAssertEqual("$", s.prod(1, 1));
    }
    
    func testCompareNaive() throws {
        var y: String = ""
        func leq_y(_ x: String) -> Bool { x.count <= y.count }

//        for (int n = 0; n < 30; n++) {
        for n in 0..<30 {
            var seg0 = segtree_naive_v0<fixture>(n);
            var seg1 = segtree(n);
//            for (int i = 0; i < n; i++) {
            for i in 0..<n {
                var s = ""
                s.append(String(cString:["a" + CChar(i),0]))
                seg0.set(i, s);
                seg1.set(i, s);
            }

//            for (int l = 0; l <= n; l++) {
            for l in 0..<=n {
//                for (int r = l; r <= n; r++) {
                for r in l..<=n {
                    XCTAssertEqual(seg0.prod(l, r), seg1.prod(l, r));
                }
            }

//            for (int l = 0; l <= n; l++) {
            for l in 0..<=n {
//                for (int r = l; r <= n; r++) {
                for r in l..<=n {
                    y = seg1.prod(l, r);
                    XCTAssertEqual(seg0.max_right(l, leq_y), seg1.maxRight(l,leq_y));
                    XCTAssertEqual(seg0.max_right(l, leq_y),
                              seg1.maxRight(l, { x in
                                  return x.count <= y.count;
                              }));
                }
            }

//            for (int r = 0; r <= n; r++) {
            for r in 0..<=n {
//                for (int l = 0; l <= r; l++) {
                for l in 0..<=r {
                    y = seg1.prod(l, r);
                    XCTAssertEqual(seg0.min_left(r,leq_y), seg1.minLeft(r,leq_y));
                    XCTAssertEqual(seg0.min_left(r,leq_y),
                              seg1.minLeft(r, { x in
                                  return x.count <= y.count;
                              }));
                }
            }
        }
    }
    
    func testAssign() throws {
        var seg0 = segtree();
        XCTAssertNoThrow(seg0 = segtree(10));
    }
    
    func testSample1() throws {
        
        struct segtree: SegtreeProtocol {
            static let e = 0
            static let op: (Int, Int) -> Int = max
            var storage: Storage
        }
        
        var seg = segtree()
    }
    
    func testSample2() throws {
        
        struct segtree: SegtreeProtocol {
            static let e = 0
            static let op: (Int, Int) -> Int = (+)
            var storage: Storage
        }
        
        var seg = segtree()
    }

    func testSample3() throws {
        
        struct segtree: SegtreeProtocol {
            static let e = 1
            static let op: (Int, Int) -> Int = (*)
            var storage: Storage
        }
        
        var seg = segtree()
    }

    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
