//
//  convolutionTests.swift
//  
//
//  Created by narumij on 2023/11/12.
//

import XCTest
@testable import AtCoder

extension static_mod {
    public static func value<T: FixedWidthInteger>() -> T { T(umod) }
}

fileprivate typealias uint = CUnsignedInt;
fileprivate typealias ll = CLongLong;
fileprivate typealias ull = CUnsignedLongLong;

fileprivate func conv_ll_naive(_ a: [ll],_ b: [ll]) -> [ll] {
    let n = a.count, m = b.count;
    var c = [ll](repeating: 0, count: n + m - 1);
    for i in 0..<n {
        for j in 0..<m {
            c[i + j] += a[i] * b[j];
        }
    }
    return c;
}

//template <class mint, internal::is_static_modint_t<mint>* = nullptr>
fileprivate func conv_naive<mint: modint_base>(_ a: [mint],_ b: [mint]) -> [mint] {
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

fileprivate func conv_naive<T: FixedWidthInteger, MOD: static_mod>(_ t: MOD.Type,_ a: [T],_ b: [T]) -> [T] {
    let n = a.count, m = b.count
    var c = [T](repeating: 0, count: n + m - 1);
//    for (int i = 0; i < n; i++) {
    for i in 0..<n {
//        for (int j = 0; j < m; j++) {
        for j in 0..<m {
            c[i + j] &+= (T)(ll(a[i]) * ll(b[j]) % MOD.value());
            if (c[i + j] >= MOD.value()) { c[i + j] -= MOD.value(); }
        }
    }
    return c;
}

fileprivate func conv_naive2<T: FixedWidthInteger, MOD: static_mod>(_ t: MOD.Type,_ a: [T],_ b: [T]) -> [T] {
    // testSimpleIntの不一致を修正したバージョン
    let n = a.count, m = b.count
    var c = [T](repeating: 0, count: n + m - 1);
//    for (int i = 0; i < n; i++) {
    for i in 0..<n {
//        for (int j = 0; j < m; j++) {
        for j in 0..<m {
            c[i + j] &+= (T)(ll(a[i]) * ll(b[j]) % MOD.value());
            if (c[i + j] >= MOD.value()) { c[i + j] -= MOD.value(); }
            if (c[i + j] < 0) { c[i + j] += MOD.value(); } // ここが異なる。これにより、testSimpleIntでのRedがGreenとなる。
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

//        XCTAssertEqual([] as [dynamic_modint],
//                  convolution([] as [dynamic_modint],
//                              [] as [dynamic_modint]));
//        XCTAssertEqual([] as [dynamic_modint],
//                  convolution([] as [dynamic_modint],
//                              [1, 2]));
    }
    
    func testMid() throws {
        // std::mt19937 mt;
        let n = 1234, m = 2345;
        typealias mint = modint998244353
//        mint.set_mod(998244353)
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
        
        enum MOD1: static_mod { static let mod: mod_value = 998244353 }
        enum MOD2: static_mod { static let mod: mod_value = 924844033 }
        
        typealias s_mint1 = static_modint<MOD1>
        typealias s_mint2 = static_modint<MOD2>

        for n in 1..<20 {
            for m in 1..<20 {
                var a = [s_mint1](repeating: 0, count: n)
                var b = [s_mint1](repeating: 0, count: m)
                for i in 0..<n {
                    a[i] = s_mint1(CInt.random(in: CInt.min...CInt.max));
                }
                for i in 0..<m {
                    b[i] = s_mint1(CInt.random(in: CInt.min...CInt.max));
                }
                XCTAssertEqual(conv_naive(a, b), (convolution(a, b)));
            }
        }
        
        for n in 1..<20 {
            for m in 1..<20 {
                var a = [s_mint2](repeating: 0, count: n)
                var b = [s_mint2](repeating: 0, count: m)
                for i in 0..<n {
                    a[i] = s_mint2(CInt.random(in: CInt.min...CInt.max));
                }
                for i in 0..<m {
                    b[i] = s_mint2(CInt.random(in: CInt.min...CInt.max));
                }
                XCTAssertEqual(conv_naive(a, b), (convolution(a, b)));
            }
        }
    }
    
    func testSimpleInt() throws {
        
        throw XCTSkip("C++でも不一致のようなのでスキップ")

        enum MOD1: static_mod { static let mod: mod_value = 998244353 }
        enum MOD2: static_mod { static let mod: mod_value = 924844033 }

        for n in 1..<10 {
            for m in 1..<10 {
                var a = [CInt](repeating: 0, count: n)
                var b = [CInt](repeating: 0, count: m)
                for i in 0..<n {
                    a[i] = CInt.random(in: CInt.min...CInt.max) % MOD1.value();
                }
                for i in 0..<m {
                    b[i] = CInt.random(in: CInt.min...CInt.max) % MOD1.value();
                }
                XCTAssertEqual(conv_naive(MOD1.self,a, b), convolution(a, b), "n = \(n), m = \(m), a = \(a), b = \(b)");
                XCTAssertEqual(conv_naive(MOD1.self,a, b), (convolution(MOD1.self, a, b)), "n = \(n), m = \(m)");
                // C++で書き出してみた結果、一例として以下のようになる。
                // conv_naive(MOD1.self,a, b)     = [-106203501, 44681908, 925902337, -1327691457, 950643207, 804941, -651950935]
                // convolution(a, b)              = [ 892040852, 44681908, 925902337,   668797249, 950643207, 804941,  346293418]
                // (convolution(MOD1.self, a, b)) = [ 892040852, 44681908, 925902337,   668797249, 950643207, 804941,  346293418]
            }
        }
        
        for n in 1..<20 {
            for m in 1..<20 {
                var a = [CInt](repeating: 0, count: n)
                var b = [CInt](repeating: 0, count: m)
                for i in 0..<n {
                    a[i] = CInt.random(in: CInt.min...CInt.max) % MOD2.value();
                }
                for i in 0..<m {
                    b[i] = CInt.random(in: CInt.min...CInt.max) % MOD2.value();
                }
                XCTAssertEqual(conv_naive(MOD2.self,a, b), (convolution(MOD2.self,a, b)), "n = \(n), m = \(m)");
            }
        }
    }

    func testSimpleIntInvestigation() throws {
        
        throw XCTSkip("C++でも不一致のようなのでスキップ")
        // 検査データを出力したC++コードは一番下にある。
        enum MOD1: static_mod { static let mod: mod_value = 998244353 }
        let a: [CInt] = [-366508063, -606130801, 425354724, -16101483, 936317027, 75824908]
        let b: [CInt] = [723102387, -348770447]
        let c: [CInt] = [-106203501, 44681908, 925902337, -1327691457, 950643207, 804941, -651950935]
        let d: [CInt] = [ 892040852, 44681908, 925902337,   668797249, 950643207, 804941,  346293418]
        let e: [CInt] = [ 892040852, 44681908, 925902337,   668797249, 950643207, 804941,  346293418]
        XCTAssertEqual(c, convolution(a, b));
        XCTAssertEqual(c, (convolution(MOD1.self, a, b)));
        XCTAssertEqual(conv_naive(MOD1.self,a, b), d);
        XCTAssertEqual(conv_naive(MOD1.self,a, b), e);
    }
    
    func testSimpleInt2() throws {
        // testSimpleIntの不一致を修正したバージョン
        enum MOD1: static_mod { static let mod: mod_value = 998244353 }
        enum MOD2: static_mod { static let mod: mod_value = 924844033 }

        for n in 1..<20 {
            for m in 1..<20 {
                var a = [CInt](repeating: 0, count: n)
                var b = [CInt](repeating: 0, count: m)
                for i in 0..<n {
                    a[i] = CInt.random(in: CInt.min...CInt.max) % MOD1.value();
                }
                for i in 0..<m {
                    b[i] = CInt.random(in: CInt.min...CInt.max) % MOD1.value();
                }
                XCTAssertEqual(conv_naive2(MOD1.self,a, b), convolution(a, b));
                XCTAssertEqual(conv_naive2(MOD1.self,a, b), (convolution(MOD1.self, a, b)));
            }
        }
        
        for n in 1..<20 {
            for m in 1..<20 {
                var a = [CInt](repeating: 0, count: n)
                var b = [CInt](repeating: 0, count: m)
                for i in 0..<n {
                    a[i] = CInt.random(in: CInt.min...CInt.max) % MOD2.value();
                }
                for i in 0..<m {
                    b[i] = CInt.random(in: CInt.min...CInt.max) % MOD2.value();
                }
                XCTAssertEqual(conv_naive2(MOD2.self,a, b), (convolution(MOD2.self,a, b)));
            }
        }
    }
    
    func testSimpleUint() throws {
        enum MOD1: static_mod { static let mod: mod_value = 998244353 }
        enum MOD2: static_mod { static let mod: mod_value = 924844033 }

        for n in 1..<20 {
            for m in 1..<20 {
                var a = [uint](repeating: 0, count: n)
                var b = [uint](repeating: 0, count: m)
                for i in 0..<n {
                    a[i] = uint.random(in: uint.min...uint.max) % MOD1.value();
                }
                for i in 0..<m {
                    b[i] = uint.random(in: uint.min...uint.max) % MOD1.value();
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
                    a[i] = uint.random(in: 0...uint.max) % MOD2.value();
                }
                for i in 0..<m {
                    b[i] = uint.random(in: 0...uint.max) % MOD2.value();
                }
                XCTAssertEqual(conv_naive(MOD2.self,a, b), (convolution(MOD2.self,a, b)));
            }
        }
    }
    
    func testSimpleULL() throws {
        enum MOD1: static_mod { static let mod: mod_value = 998244353 }
        enum MOD2: static_mod { static let mod: mod_value = 924844033 }

        for n in 1..<20 {
            for m in 1..<20 {
                var a = [ull](repeating: 0, count: n)
                var b = [ull](repeating: 0, count: m)
                for i in 0..<n {
                    a[i] = ull.random(in: ull.min...ull.max) % MOD1.value();
                }
                for i in 0..<m {
                    b[i] = ull.random(in: ull.min...ull.max) % MOD1.value();
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
                    a[i] = ull.random(in: 0...ull.max) % MOD2.value();
                }
                for i in 0..<m {
                    b[i] = ull.random(in: 0...ull.max) % MOD2.value();
                }
                XCTAssertEqual(conv_naive(MOD2.self,a, b), (convolution(MOD2.self,a, b)));
            }
        }
    }
    
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
    
    func testConvLL() throws {
        for n in 1..<20 {
            for m in 1..<20 {
                var a = [ll](repeating: 0, count: n)
                var b = [ll](repeating: 0, count: m)
                for i in 0..<n {
                     a[i] = ll(ll.random(in: ll.min...ll.max) % 1_000_000) - 500_000;
                 }
                for i in 0..<m {
                    b[i] = ll(ll.random(in: ll.min...ll.max) % 1_000_000) - 500_000;
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
//         for (int i = -1000; i <= 1000; i++) {
        for i in ll(-1000)..<=1000 {
            let a: [ll] = [ll(0 - M1M2 - M1M3 - M2M3 + i)]
            let b: [ll] = [1];

             XCTAssertEqual(a, convolution_ll(a, b));
         }
//         for (int i = 0; i < 1000; i++) {
        for i in ll(-1000)..<=1000 {
            let a: [ll] = [ll.min &+ i];
            let b: [ll] = [1];

            XCTAssertEqual(a, convolution_ll(a, b));
         }
//         for (int i = 0; i < 1000; i++) {
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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

/*

// testSimpleIntの調査コード

#include<bits/stdc++.h>
#include<atcoder/convolution>
#include<atcoder/modint>
using namespace std;
using namespace atcoder;
using uint = unsigned int;
using ll = long long;
using ull = unsigned long long;

template <int MOD,
          class T,
          std::enable_if_t<internal::is_integral<T>::value>* = nullptr>
std::vector<T> conv_naive(std::vector<T> a, std::vector<T> b) {
    int n = int(a.size()), m = int(b.size());
    std::vector<T> c(n + m - 1);
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            c[i + j] += (T)((ll)a[i] * (ll)b[j] % MOD);
            if (c[i + j] >= MOD) c[i + j] -= MOD;
        }
    }
    return c;
}

int main() {
    
    const int MOD1 = 998244353;
    std::vector<int> a = {-366508063, -606130801, 425354724, -16101483, 936317027, 75824908};
    std::vector<int> b = {723102387, -348770447};
    std::vector<int> c = conv_naive<MOD1>(a, b);
    std::vector<int> d = convolution(a, b);
    std::vector<int> e = (convolution<MOD1>(a, b));

        cout << "let c: [CInt] = [";
        for (auto iter=c.begin(); iter!=c.end(); iter++) {
            if (iter != c.begin()) cout <<", ";
            cout << *iter;
        }
        cout << "]" << endl;

        cout << "let d: [CInt] = [";
        for (auto iter=d.begin(); iter!=d.end(); iter++) {
            if (iter != d.begin()) cout <<", ";
            cout << *iter;
        }
        cout << "]" << endl;

        cout << "let e: [CInt] = [";
        for (auto iter=e.begin(); iter!=e.end(); iter++) {
            if (iter != e.begin()) cout <<", ";
            cout << *iter;
        }
        cout << "]" << endl;
}

 */
