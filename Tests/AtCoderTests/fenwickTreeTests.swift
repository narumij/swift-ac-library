import XCTest
import AtCoder

fileprivate typealias int = CInt
fileprivate typealias uint = CUnsignedInt
fileprivate typealias ll = CLongLong
fileprivate typealias ull = CUnsignedLongLong

final class fenwickTreeTests: XCTestCase {

    typealias fenwick_tree = FenwickTree
    
    func testEmpty() throws {
        var fw_ll = fenwick_tree<ll>()
        XCTAssertEqual(0, fw_ll.sum(0, 0))
        
        var fw_modint = fenwick_tree<modint>()
        XCTAssertEqual(0, fw_modint.sum(0, 0))
    }
    
#if false
    func testAssign() throws {
        throw XCTSkip("代入のオーバーロードはSwiftにはない。")
        /*
         fenwick_tree<ll> fw;
         fw = fenwick_tree<ll>(10);
         */
    }
#endif
    
    func testZero() throws {
        var fw_ll = fenwick_tree<ll>(0)
        XCTAssertEqual(0, fw_ll.sum(0, 0))
        
        var fw_modint = fenwick_tree<modint>(0)
        XCTAssertEqual(0, fw_modint.sum(0, 0))
    }
    
    func testOverFlowULL() throws {
        var fw = fenwick_tree<ull>(10)
        for i in 0..<10 {
            fw.add(i, ull(bitPattern: 1 << 63) + ull(i))
        }
        for i in 0..<=10 {
            for j in 0..<=10 {
                var sum: ull = 0
                for k in stride(from: i, to: j, by: 1) {
                    sum += ull(k)
                }
                if i <= j {
                    XCTAssertEqual(((j - i) % 2) != 0 ? ull(bitPattern: 1 << 63) + sum : sum, fw.sum(i, j)
                    )
                }
            }
        }
    }
    
    func testNaiveTest() throws {
        for n in 0..<=50 {
            var fw = fenwick_tree<ll>(n)
            for i in 0..<n {
                fw.add(i, ll(i * i))
            }
            for l in 0..<=n {
                for r in l..<=n {
                    var sum: ll = 0
                    for i in l..<r {
                        sum += ll(i * i)
                    }
                    XCTAssertEqual(sum, fw.sum(l, r))
                }
            }
        }
    }
    
    func testSMintTest() throws {
        enum mod_11: static_mod_value { static let mod: mod_value = 11 }
        typealias mint = static_modint<mod_11>
        for n in 0..<=5 {
            var fw = fenwick_tree<mint>(n)
            for i in 0..<n {
                fw.add(i, mint(i * i))
            }
            for l in 0..<=n {
                for r in l..<=n {
                    var sum = 0
                    for i in l..<r {
                        sum += i * i
                    }
                    XCTAssertEqual(mint(sum), fw.sum(l, r))
                }
            }
        }
    }
    
    func testMintTest() throws {
        typealias mint = modint
        for n in 0..<=50 {
            var fw = fenwick_tree<mint>(n)
            for i in 0..<n {
                fw.add(i, mint(i * i))
            }
            for l in 0..<=n {
                for r in l..<=n {
                    var sum = 0
                    for i in l..<r {
                        sum += i * i
                    }
                    XCTAssertEqual(mint(sum), fw.sum(l, r))
                }
            }
        }
    }
    
#if false
    func testInvalid() throws {
        throw XCTSkip("Swift Packageでは実施不可")
        /*
        EXPECT_THROW(auto s = fenwick_tree<int>(-1), std::exception);
        fenwick_tree<int> s(10);

        EXPECT_DEATH(s.add(-1, 0), ".*");
        EXPECT_DEATH(s.add(10, 0), ".*");

        EXPECT_DEATH(s.sum(-1, 3), ".*");
        EXPECT_DEATH(s.sum(3, 11), ".*");
        EXPECT_DEATH(s.sum(5, 3), ".*");
         */
    }
#endif
    
    func testBound() throws {
        var fw = fenwick_tree<int>(10)
        fw.add(3, int.max)
        fw.add(5, int.min)
        XCTAssertEqual(-1, fw.sum(0, 10))
        XCTAssertEqual(-1, fw.sum(3, 6))
        XCTAssertEqual(int.max, fw.sum(3, 4))
        XCTAssertEqual(int.min, fw.sum(4, 10))
    }
    
    func testBoundll() throws {
        var fw = fenwick_tree<ll>(10)
        fw.add(3, ll.max)
        fw.add(5, ll.min)
        XCTAssertEqual(-1, fw.sum(0, 10))
        XCTAssertEqual(-1, fw.sum(3, 6))
        XCTAssertEqual(ll.max, fw.sum(3, 4))
        XCTAssertEqual(ll.min, fw.sum(4, 10))
    }
    
    func testOverFlow() throws {
        var fw = fenwick_tree<int>(20)
        var a = [ll](repeating: 0, count: 20)
        for i in 0..<10 {
            let x = int.max
             a[i] += ll(x)
            fw.add(i, x)
        }
        for i in 10..<20 {
            let x = int.min
             a[i] += ll(x)
            fw.add(i, x)
        }
         a[5] += 11111
        fw.add(5, 11111)
        
        for l in 0..<=20 {
            for r in l..<=20 {
                var sum: ll = 0
                for i in l..<r {
                     sum &+= ll(a[i])
                }
                let dif = sum - ll(fw.sum(l, r))
                if dif != 0 {
                    XCTAssertEqual(0, dif % ll(bitPattern: 1 << 32))
                }
             }
         }
    }
    
#if false
    func testInt128() throws {
        throw XCTSkip("__int128がSwiftにはない")
        /*
         fenwick_tree<__int128> fw(20);
         for (int i = 0; i < 20; i++) {
             fw.add(i, i);
         }

         for (int l = 0; l <= 20; l++) {
             for (int r = l; r <= 20; r++) {
                 ll sum = 0;
                 for (int i = l; i < r; i++) {
                     sum += i;
                 }
                 ASSERT_EQ(sum, fw.sum(l, r));
             }
         }
         */
    }
#endif
    
    func testInt() throws {
        var fw = fenwick_tree<Int>(20)
        for i in 0 ..< 20 {
            fw.add(i, i)
        }
        for l in 0 ... 20 {
            for r in l ... 20 {
                var sum = 0
                for i in l ..< r {
                    sum += i
                }
                XCTAssertEqual(sum, fw.sum(l, r))
            }
        }
    }
    
    func testSum() throws {
        var fw = fenwick_tree<Int>(20)
        for i in 0 ..< 20 {
            fw.add(i, i)
        }
        for l in 0 ... 20 {
            var sum = 0
            for i in 0 ..< l {
                sum += i
            }
            XCTAssertEqual(sum, Int(fw.sum(l)))
        }
    }

    func testHandleUnsigned() throws {
        XCTAssertEqual(4294967295, CInt(-1).unsigned)
        XCTAssertEqual(18446744073709551615, CLongLong(-1).unsigned)
        XCTAssertEqual(18446744073709551615, Int(-1).unsigned)
    }
}
