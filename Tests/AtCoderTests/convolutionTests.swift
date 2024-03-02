import XCTest
import AtCoder
// TODO: C++のメルセンヌツイスターの挙動の確認

extension static_mod {
    public static func value<T: FixedWidthInteger>() -> T { T(umod) }
}

fileprivate typealias int = CInt;
fileprivate typealias uint = CUnsignedInt;
fileprivate typealias ll = CLongLong;
fileprivate typealias ull = CUnsignedLongLong;

fileprivate func conv_ll_naive(_ a: [ll],_ b: [ll]) -> [ll] {
    let n = a.count, m = b.count
    var c = [ll](repeating: 0, count: n + m - 1)
    for i in 0 ..< n {
        for j in 0 ..< m {
            c[i + j] += a[i] * b[j]
        }
    }
    return c;
}

fileprivate func conv_naive<mint: modint_base>(_ a: [mint],_ b: [mint]) -> [mint] {
    let n = a.count, m = b.count
    var c = [mint](repeating: 0, count: n + m - 1)
    for i in 0 ..< n {
        for j in 0 ..< m {
            c[i + j] += a[i] * b[j]
        }
    }
    return c
}

fileprivate func conv_naive<T: FixedWidthInteger>(_ MOD: T,_ a: [T],_ b: [T]) -> [T] {
    let (n,m) = (a.count, b.count)
    var c = [T](repeating: 0, count: n + m - 1)
    for i in 0 ..< n {
        for j in 0 ..< m {
            c[i + j] &+= (T)(ll(a[i]) * ll(b[j]) % ll(MOD))
            if c[i + j] >= MOD { c[i + j] -= MOD }
        }
    }
    return c
}

fileprivate func conv_naive<MOD: static_mod, T: FixedWidthInteger>(_ t: MOD.Type,_ a: [T],_ b: [T]) -> [T] {
    conv_naive(t.value(), a, b)
}

final class convolutionTests: XCTestCase {
    
    func testEmpty() throws {
        XCTAssertEqual([] as [CInt],
                       convolution([] as [CInt], [] as [CInt]));
        XCTAssertEqual([] as [CInt],
                       convolution([] as [CInt], [1, 2]));
        XCTAssertEqual([] as [CInt],
                       convolution([1, 2], [] as [CInt]));
        XCTAssertEqual([] as [CInt],
                       convolution([1], [] as [CInt]));
        XCTAssertEqual([] as [ll],
                       convolution([] as [ll], [] as [ll]));
        XCTAssertEqual([] as [ll],
                       convolution([] as [ll], [1, 2]));
        XCTAssertEqual([] as [modint998244353],
                       convolution([] as [modint998244353],
                                   [] as [modint998244353]));
        XCTAssertEqual([] as [modint998244353],
                       convolution([] as [modint998244353],
                                   [1, 2]));
    }
    
    func testMid() throws {
        typealias mint = modint998244353
        
        // std::mt19937 mt;
        let mt = { mint(CInt.random(in: 0...CInt.max)) }
        let n = 1234, m = 2345;
        var a = [mint](repeating: 0, count: n); var b = [mint](repeating: 0, count: m);
        
        for i in 0 ..< n {
            a[i] = mt()
        }
        for i in 0 ..< m {
            b[i] = mt()
        }
        XCTAssertEqual(conv_naive(a, b), convolution(a, b));
    }
    
    func testSimpleSMod() throws {
        
        enum MOD1: static_mod { static let mod: mod_value = 998244353 }
        enum MOD2: static_mod { static let mod: mod_value = 924844033 }
        
        typealias s_mint1 = static_modint<MOD1>
        typealias s_mint2 = static_modint<MOD2>
        
        // std::mt19937 mt;
        let mt = { int.random(in: 0...int.max) }
        
        for n in 1..<20 {
            for m in 1..<20 {
                var a = [s_mint1](repeating: 0, count: n)
                var b = [s_mint1](repeating: 0, count: m)
                for i in 0..<n {
                    a[i] = s_mint1(mt());
                }
                for i in 0..<m {
                    b[i] = s_mint1(mt());
                }
                XCTAssertEqual(conv_naive(a, b), (convolution(a, b)));
            }
        }
        
        for n in 1..<20 {
            for m in 1..<20 {
                var a = [s_mint2](repeating: 0, count: n)
                var b = [s_mint2](repeating: 0, count: m)
                for i in 0..<n {
                    a[i] = s_mint2(mt());
                }
                for i in 0..<m {
                    b[i] = s_mint2(mt());
                }
                XCTAssertEqual(conv_naive(a, b), (convolution(a, b)));
            }
        }
    }
    
    func testSimpleInt() throws {
        enum MOD1: static_mod { static let mod: mod_value = 998_244_353 }
        enum MOD2: static_mod { static let mod: mod_value = 924_844_033 }
        
        // std::mt19937 mt;
        let mt = { int.random(in: 0...int.max) }
        
        for n in 1 ..< 20 as Range<int> {
            for m in 1 ..< 20 as Range<int> {
                var a = [int](repeating: 0, count: Int(n))
                var b = [int](repeating: 0, count: Int(m))
                for i in 0..<n as Range<int> {
                    a[Int(i)] = mt() % MOD1.value();
                }
                for i in 0..<m as Range<int> {
                    b[Int(i)] = mt() % MOD1.value();
                }
                XCTAssertEqual(conv_naive(MOD1.value(), a, b), convolution(a, b))
                // これがコンパイル通るのは、コンパイラのバグな気がする。あるいは5.9のマクロで緩んだ？
                XCTAssertEqual(conv_naive(MOD1.value(), a, b), convolution<MOD1>(a, b))
                XCTAssertEqual(conv_naive(MOD1.value(), a, b), (convolution(MOD1.self, a, b)))
            }
        }
        
        for n in 1..<10 {
            for m in 1..<10 {
                var a = [int](repeating: 0, count: n)
                var b = [int](repeating: 0, count: m)
                for i in 0..<n {
                    a[i] = mt() % MOD2.value();
                }
                for i in 0..<m {
                    b[i] = mt() % MOD2.value();
                }
                XCTAssertEqual(conv_naive(MOD2.value(), a, b), (convolution(MOD2.self, a, b)));
            }
        }
    }
    
    func testSimpleUint() throws {
        enum MOD1: static_mod { static let mod: mod_value = 998244353 }
        enum MOD2: static_mod { static let mod: mod_value = 924844033 }
        
        // std::mt19937 mt;
        let mt = { uint.random(in: uint.min...uint.max) }
        
        for n in 1..<20 {
            for m in 1..<20 {
                var a = [uint](repeating: 0, count: n)
                var b = [uint](repeating: 0, count: m)
                for i in 0..<n {
                    a[i] = mt() % MOD1.value();
                }
                for i in 0..<m {
                    b[i] = mt() % MOD1.value();
                }
                XCTAssertEqual(conv_naive(MOD1.self,a, b), convolution(a, b));
                XCTAssertEqual(conv_naive(MOD1.self,a, b), (convolution(MOD1.self, a, b)));
            }
        }
        
        for n in 1..<20 {
            for m in 1..<20 {
                var a = [uint](repeating: 0, count: n)
                var b = [uint](repeating: 0, count: m)
                for i in 0..<n {
                    a[i] = mt() % MOD2.value();
                }
                for i in 0..<m {
                    b[i] = mt() % MOD2.value();
                }
                XCTAssertEqual(conv_naive(MOD2.self,a, b), (convolution(MOD2.self,a, b)));
            }
        }
    }
    
    func testSimpleULL() throws {
        enum MOD1: static_mod { static let mod: mod_value = 998244353 }
        enum MOD2: static_mod { static let mod: mod_value = 924844033 }
        
        // std::mt19937 mt;
        let mt = { ull.random(in: ull.min...ull.max) }
        
        for n in 1..<20 {
            for m in 1..<20 {
                var a = [ull](repeating: 0, count: n)
                var b = [ull](repeating: 0, count: m)
                for i in 0..<n {
                    a[i] = mt() % MOD1.value();
                }
                for i in 0..<m {
                    b[i] = mt() % MOD1.value();
                }
                XCTAssertEqual(conv_naive(MOD1.self,a, b), convolution(a, b));
                XCTAssertEqual(conv_naive(MOD1.self,a, b), (convolution(MOD1.self, a, b)));
            }
        }
        
        for n in 1..<20 {
            for m in 1..<20 {
                var a = [ull](repeating: 0, count: n)
                var b = [ull](repeating: 0, count: m)
                for i in 0..<n {
                    a[i] = mt() % MOD2.value();
                }
                for i in 0..<m {
                    b[i] = mt() % MOD2.value();
                }
                XCTAssertEqual(conv_naive(MOD2.self,a, b), (convolution(MOD2.self,a, b)));
            }
        }
    }
    
#if false
    func testSimpleInt128() throws {
        throw XCTSkip("__int128はSwiftでは利用できないため")
        /*
         const int MOD1 = 998244353;
         const int MOD2 = 924844033;
         
         std::mt19937 mt;
         for (int n = 1; n < 20; n++) {
         for (int m = 1; m < 20; m++) {
         std::vector<__int128> a(n), b(m);
         for (int i = 0; i < n; i++) {
         a[i] = mt() % MOD1;
         }
         for (int i = 0; i < m; i++) {
         b[i] = mt() % MOD1;
         }
         ASSERT_EQ(conv_naive<MOD1>(a, b), convolution(a, b));
         ASSERT_EQ(conv_naive<MOD1>(a, b), (convolution<MOD1>(a, b)));
         }
         }
         for (int n = 1; n < 20; n++) {
         for (int m = 1; m < 20; m++) {
         std::vector<__int128> a(n), b(m);
         for (int i = 0; i < n; i++) {
         a[i] = mt() % MOD2;
         }
         for (int i = 0; i < m; i++) {
         b[i] = mt() % MOD2;
         }
         ASSERT_EQ(conv_naive<MOD2>(a, b), (convolution<MOD2>(a, b)));
         }
         }
         */
    }
#endif
    
#if false
    func testSimpleUInt128() throws {
        throw XCTSkip("__int128はSwiftでは利用できないため")
        /*
         const int MOD1 = 998244353;
         const int MOD2 = 924844033;
         
         std::mt19937 mt;
         for (int n = 1; n < 20; n++) {
         for (int m = 1; m < 20; m++) {
         std::vector<unsigned __int128> a(n), b(m);
         for (int i = 0; i < n; i++) {
         a[i] = mt() % MOD1;
         }
         for (int i = 0; i < m; i++) {
         b[i] = mt() % MOD1;
         }
         ASSERT_EQ(conv_naive<MOD1>(a, b), convolution(a, b));
         ASSERT_EQ(conv_naive<MOD1>(a, b), (convolution<998244353>(a, b)));
         }
         }
         for (int n = 1; n < 20; n++) {
         for (int m = 1; m < 20; m++) {
         std::vector<unsigned __int128> a(n), b(m);
         for (int i = 0; i < n; i++) {
         a[i] = mt() % MOD2;
         }
         for (int i = 0; i < m; i++) {
         b[i] = mt() % MOD2;
         }
         ASSERT_EQ(conv_naive<MOD2>(a, b), (convolution<MOD2>(a, b)));
         }
         }
         */
    }
#endif
    
    func testConvLL() throws {
        
        // std::mt19937 mt;
        let mt = { ll.random(in: ll.min...ll.max) }
        
        for n in 1..<20 {
            for m in 1..<20 {
                var a = [ll](repeating: 0, count: n)
                var b = [ll](repeating: 0, count: m)
                for i in 0..<n {
                    a[i] = mt() % 1_000_000 - 500_000;
                }
                for i in 0..<m {
                    b[i] = mt() % 1_000_000 - 500_000;
                }
                XCTAssertEqual(conv_ll_naive(a, b), convolution_ll(a, b));
            }
        }
    }
    
    func testConvLLBound() throws {
        let MOD1: ll = 469762049;  // 2^26
        let MOD2: ll = 167772161;  // 2^25
        let MOD3: ll = 754974721;  // 2^24
        let M2M3: ll = MOD2 * MOD3;
        let M1M3: ll = MOD1 * MOD3;
        let M1M2: ll = MOD1 * MOD2;
        // for (int i = -1000; i <= 1000; i++) {
        for i in ll(-1000)..<=1000 {
            let a: [ll] = [ll(0 - M1M2 - M1M3 - M2M3 + i)]
            let b: [ll] = [1];
            
            XCTAssertEqual(a, convolution_ll(a, b));
        }
        // for (int i = 0; i < 1000; i++) {
        for i in ll(-1000)..<=1000 {
            let a: [ll] = [ll.min &+ i];
            let b: [ll] = [1];
            
            XCTAssertEqual(a, convolution_ll(a, b));
        }
        // for (int i = 0; i < 1000; i++) {
        for i in ll(-1000)..<=1000 {
            let a: [ll] = [ll.max &- i];
            let b: [ll] = [1];
            
            XCTAssertEqual(a, convolution_ll(a, b));
        }
    }
    
    // https://github.com/atcoder/ac-library/issues/30
    func testConv641() throws {
        // 641 = 128 * 5 + 1
        enum MOD: static_mod { static let mod: mod_value = 641 }
        
        var a = [ll](repeating: 0, count: 64)
        var b = [ll](repeating: 0, count: 65)
        
        for i in 0..<64 {
            a[i] = ll.random(in: 0...(MOD.value() - 1))
        }
        for i in 0..<65 {
            b[i] = ll.random(in: 0...(MOD.value() - 1))
        }
        
        XCTAssertEqual(conv_naive(MOD.self, a, b), convolution(MOD.self, a, b));
    }
    
    // https://github.com/atcoder/ac-library/issues/30
    func testConv18433() throws {
        
        // 18433 = 2048 * 9 + 1
        enum MOD: static_mod { static let mod: mod_value = 18433 }
        
        var a = [ll](repeating: 0, count: 1024)
        var b = [ll](repeating: 0, count: 1025)
        
        for i in 0..<1024 {
            a[i] = ll.random(in: 0...(MOD.value() - 1))
        }
        for i in 0..<1025 {
            b[i] = ll.random(in: 0...(MOD.value() - 1))
        }
        
        XCTAssertEqual(conv_naive(MOD.self, a, b), convolution(MOD.self, a, b));
    }
    
    func testConv2() throws {
        enum mod_2: static_mod { static let mod: mod_value = 2 }
        let empty: [ll] = [];
        XCTAssertEqual(empty, convolution(mod_2.self, empty, empty));
    }
    
    func testConv257() throws {
        enum MOD: static_mod { static let mod: mod_value = 257 }
        
        var a = [ll](repeating: 0, count: 128)
        var b = [ll](repeating: 0, count: 129)
        
        for i in 0..<128 {
            a[i] = ll.random(in: 0...(MOD.value() - 1))
        }
        for i in 0..<129 {
            b[i] = ll.random(in: 0...(MOD.value() - 1))
        }
        
        XCTAssertEqual(conv_naive(MOD.self, a, b), convolution(MOD.self, a, b));
    }
    
    func testConv2147483647() throws {
        enum MOD: static_mod { static let mod: mod_value = 2147483647 }
        
        var a = [ll](repeating: 0, count: 1)
        var b = [ll](repeating: 0, count: 2)
        
        for i in 0..<1 {
            a[i] = ll.random(in: 0...(MOD.value() - 1))
        }
        for i in 0..<2 {
            b[i] = ll.random(in: 0...(MOD.value() - 1))
        }
        
        XCTAssertEqual(conv_naive(MOD.self, a, b), convolution(MOD.self, a, b));
    }
    
    func testConv2130706433() throws {
        enum MOD: static_mod { static let mod: mod_value = 2130706433 }
        
        var a = [ll](repeating: 0, count: 1024)
        var b = [ll](repeating: 0, count: 1024)
        
        for i in 0..<1024 {
            a[i] = ll.random(in: 0...(MOD.value() - 1))
        }
        for i in 0..<1024 {
            b[i] = ll.random(in: 0...(MOD.value() - 1))
        }
        
        XCTAssertEqual(conv_naive(MOD.self, a, b), convolution(MOD.self, a, b));
    }
    
}
