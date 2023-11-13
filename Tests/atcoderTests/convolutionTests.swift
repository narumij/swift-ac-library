//
//  convolutionTests.swift
//  
//
//  Created by narumij on 2023/11/12.
//

import XCTest
@testable import atcoder

fileprivate typealias uint = CUnsignedInt;
fileprivate typealias ll = CLongLong;
fileprivate typealias ull = CUnsignedLongLong;

fileprivate func test() {
    
    enum mod1: dynamic_mod { static var modValue: barrett = -1 }
    mod1.set_mod(2)
    typealias modint1 = modint_base<mod1>
    
    enum mod2: dynamic_mod { static var modValue: barrett = -1 }
    mod2.set_mod(5)
    typealias modint2 = modint_base<mod2>
    
    enum mod3: dynamic_mod { static var modValue: barrett = -1 }
    mod3.set_mod(7)
    typealias modint3 = modint_base<mod3>
}


//template <class mint, internal::is_static_modint_t<mint>* = nullptr>
func conv_naive<mint: modint_base_protocol>(_ a: [mint],_ b: [mint]) -> [mint] {
    let n = a.count, m = b.count;
    var c = [mint](repeating: 0, count: n + m - 1);
//    for (int i = 0; i < n; i++) {
    for i in 0..<n {
//        for (int j = 0; j < m; j++) {
        for j in 0..<m {
            c[i + j] += a[i] * b[j];
        }
    }
    return c;
}


final class convolutionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
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

        XCTAssertEqual([] as [dynamic_modint],
                  convolution([] as [dynamic_modint],
                              [] as [dynamic_modint]));
        XCTAssertEqual([] as [dynamic_modint],
                  convolution([] as [dynamic_modint],
                              [1, 2]));
    }
    
    func testMid() throws {
        // std::mt19937 mt;
        let n = 1234, m = 2345;
        typealias mint = dynamic_modint
        mint.set_mod(998244353)
        var a = [mint](repeating: 0, count: n); var b = [mint](repeating: 0, count: m);
        
//        for (int i = 0; i < n; i++) {
        for i in 0..<n {
            a[i] = mint(CInt.random(in: CInt.min...CInt.max));
        }
//        for (int i = 0; i < m; i++) {
        for i in 0..<m {
            b[i] = mint(CInt.random(in: CInt.min...CInt.max));
        }
        XCTAssertEqual(conv_naive(a, b), convolution(a, b));
    }
    
    func testSimpleSMod() throws {
        /*
        const int MOD1 = 998244353;
        const int MOD2 = 924844033;
        using s_mint1 = static_modint<MOD1>;
        using s_mint2 = static_modint<MOD2>;

        std::mt19937 mt;
        for (int n = 1; n < 20; n++) {
            for (int m = 1; m < 20; m++) {
                std::vector<s_mint1> a(n), b(m);
                for (int i = 0; i < n; i++) {
                    a[i] = mt();
                }
                for (int i = 0; i < m; i++) {
                    b[i] = mt();
                }
                ASSERT_EQ(conv_naive(a, b), convolution(a, b));
            }
        }
        for (int n = 1; n < 20; n++) {
            for (int m = 1; m < 20; m++) {
                std::vector<s_mint2> a(n), b(m);
                for (int i = 0; i < n; i++) {
                    a[i] = mt();
                }
                for (int i = 0; i < m; i++) {
                    b[i] = mt();
                }
                ASSERT_EQ(conv_naive(a, b), convolution(a, b));
            }
        }
         */
    }
    
    func testSimpleInt() throws {
        /*
        const int MOD1 = 998244353;
        const int MOD2 = 924844033;

        std::mt19937 mt;
        for (int n = 1; n < 20; n++) {
            for (int m = 1; m < 20; m++) {
                std::vector<int> a(n), b(m);
                for (int i = 0; i < n; i++) {
                    a[i] = int(mt() % MOD1);
                }
                for (int i = 0; i < m; i++) {
                    b[i] = int(mt() % MOD1);
                }
                ASSERT_EQ(conv_naive<MOD1>(a, b), convolution(a, b));
                ASSERT_EQ(conv_naive<MOD1>(a, b), (convolution<MOD1>(a, b)));
            }
        }
        for (int n = 1; n < 20; n++) {
            for (int m = 1; m < 20; m++) {
                std::vector<int> a(n), b(m);
                for (int i = 0; i < n; i++) {
                    a[i] = int(mt() % MOD2);
                }
                for (int i = 0; i < m; i++) {
                    b[i] = int(mt() % MOD2);
                }
                ASSERT_EQ(conv_naive<MOD2>(a, b), (convolution<MOD2>(a, b)));
            }
        }
         */
    }
    
    func testSimpleUint() throws {
        /*
        const int MOD1 = 998244353;
        const int MOD2 = 924844033;

        std::mt19937 mt;
        for (int n = 1; n < 20; n++) {
            for (int m = 1; m < 20; m++) {
                std::vector<uint> a(n), b(m);
                for (int i = 0; i < n; i++) {
                    a[i] = uint(mt() % MOD1);
                }
                for (int i = 0; i < m; i++) {
                    b[i] = uint(mt() % MOD1);
                }
                ASSERT_EQ(conv_naive<MOD1>(a, b), convolution(a, b));
                ASSERT_EQ(conv_naive<MOD1>(a, b), (convolution<MOD1>(a, b)));
            }
        }
        for (int n = 1; n < 20; n++) {
            for (int m = 1; m < 20; m++) {
                std::vector<uint> a(n), b(m);
                for (int i = 0; i < n; i++) {
                    a[i] = uint(mt() % MOD2);
                }
                for (int i = 0; i < m; i++) {
                    b[i] = uint(mt() % MOD2);
                }
                ASSERT_EQ(conv_naive<MOD2>(a, b), (convolution<MOD2>(a, b)));
            }
        }
         */
    }
    
    func testSimpleULL() throws {
        /*
         const int MOD1 = 998244353;
         const int MOD2 = 924844033;

         std::mt19937 mt;
         for (int n = 1; n < 20; n++) {
             for (int m = 1; m < 20; m++) {
                 std::vector<ull> a(n), b(m);
                 for (int i = 0; i < n; i++) {
                     a[i] = ull(mt() % MOD1);
                 }
                 for (int i = 0; i < m; i++) {
                     b[i] = ull(mt() % MOD1);
                 }
                 ASSERT_EQ(conv_naive<MOD1>(a, b), convolution(a, b));
                 ASSERT_EQ(conv_naive<MOD1>(a, b), (convolution<MOD1>(a, b)));
             }
         }
         for (int n = 1; n < 20; n++) {
             for (int m = 1; m < 20; m++) {
                 std::vector<ull> a(n), b(m);
                 for (int i = 0; i < n; i++) {
                     a[i] = ull(mt() % MOD2);
                 }
                 for (int i = 0; i < m; i++) {
                     b[i] = ull(mt() % MOD2);
                 }
                 ASSERT_EQ(conv_naive<MOD2>(a, b), (convolution<MOD2>(a, b)));
             }
         }
         */
    }
    
    func testSimpleInt128() throws {
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
    
    func testSimpleUInt128() throws {
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
    
    func testConvLL() throws {
        /*
         std::mt19937 mt;
         for (int n = 1; n < 20; n++) {
             for (int m = 1; m < 20; m++) {
                 std::vector<ll> a(n), b(m);
                 for (int i = 0; i < n; i++) {
                     a[i] = ll(mt() % 1'000'000) - 500'000;
                 }
                 for (int i = 0; i < m; i++) {
                     b[i] = ll(mt() % 1'000'000) - 500'000;
                 }
                 ASSERT_EQ(conv_ll_naive(a, b), convolution_ll(a, b));
             }
         }
         */
    }
    
    func testConvLLBound() throws {
        /*
         static constexpr unsigned long long MOD1 = 469762049;  // 2^26
         static constexpr unsigned long long MOD2 = 167772161;  // 2^25
         static constexpr unsigned long long MOD3 = 754974721;  // 2^24
         static constexpr unsigned long long M2M3 = MOD2 * MOD3;
         static constexpr unsigned long long M1M3 = MOD1 * MOD3;
         static constexpr unsigned long long M1M2 = MOD1 * MOD2;
         for (int i = -1000; i <= 1000; i++) {
             std::vector<ll> a = {(long long)(0ULL - M1M2 - M1M3 - M2M3 + i)};
             std::vector<ll> b = {1};

             ASSERT_EQ(a, convolution_ll(a, b));
         }
         for (int i = 0; i < 1000; i++) {
             std::vector<ll> a = {std::numeric_limits<ll>::min() + i};
             std::vector<ll> b = {1};

             ASSERT_EQ(a, convolution_ll(a, b));
         }
         for (int i = 0; i < 1000; i++) {
             std::vector<ll> a = {std::numeric_limits<ll>::max() - i};
             std::vector<ll> b = {1};

             ASSERT_EQ(a, convolution_ll(a, b));
         }
         */
    }
    
    // https://github.com/atcoder/ac-library/issues/30
    func testConv641() throws {
        /*
         // 641 = 128 * 5 + 1
         const int MOD = 641;
         std::vector<ll> a(64), b(65);
         for (int i = 0; i < 64; i++) {
             a[i] = randint(0, MOD - 1);
         }
         for (int i = 0; i < 65; i++) {
             b[i] = randint(0, MOD - 1);
         }

         ASSERT_EQ(conv_naive<MOD>(a, b), convolution<MOD>(a, b));
         */
    }
    
    // https://github.com/atcoder/ac-library/issues/30
    func testConv18433() throws {
        /*
         // 18433 = 2048 * 9 + 1
         const int MOD = 18433;
         std::vector<ll> a(1024), b(1025);
         for (int i = 0; i < 1024; i++) {
             a[i] = randint(0, MOD - 1);
         }
         for (int i = 0; i < 1025; i++) {
             b[i] = randint(0, MOD - 1);
         }

         ASSERT_EQ(conv_naive<MOD>(a, b), convolution<MOD>(a, b));
         */
    }
    
    func testConv2() throws {
        /*
         std::vector<ll> empty = {};
         ASSERT_EQ(empty, convolution<2>(empty, empty));
         */
    }
    
    func testConv257() throws {
        /*
        const int MOD = 257;
        std::vector<ll> a(128), b(129);
        for (int i = 0; i < 128; i++) {
            a[i] = randint(0, MOD - 1);
        }
        for (int i = 0; i < 129; i++) {
            b[i] = randint(0, MOD - 1);
        }

        ASSERT_EQ(conv_naive<MOD>(a, b), convolution<MOD>(a, b));
         */
    }
    
    func testConv2147483647() throws {
        /*
         const int MOD = 2147483647;
         using mint = static_modint<MOD>;
         std::vector<mint> a(1), b(2);
         for (int i = 0; i < 1; i++) {
             a[i] = randint(0, MOD - 1);
         }
         for (int i = 0; i < 2; i++) {
             b[i] = randint(0, MOD - 1);
         }
         ASSERT_EQ(conv_naive(a, b), convolution(a, b));
         */
    }
    
    func testConv2130706433() throws {
        /*
         const int MOD = 2130706433;
         using mint = static_modint<MOD>;
         std::vector<mint> a(1024), b(1024);
         for (int i = 0; i < 1024; i++) {
             a[i] = randint(0, MOD - 1);
         }
         for (int i = 0; i < 1024; i++) {
             b[i] = randint(0, MOD - 1);
         }
         ASSERT_EQ(conv_naive(a, b), convolution(a, b));
         */
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
