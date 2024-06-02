import XCTest
#if DEBUG
@testable import AtCoder
#else
import AtCoder
#endif

func is_primitive_root_naive(_ m: CInt,_ g: CInt) -> Bool {
    assert(1 <= g && g < m)
    var x: CInt = 1
    for _ in 1..<=(m - 2) {
        x = CInt(CLongLong(x)*CLongLong(g) % CLongLong(m))
        // x == n^i
        if (x == 1) { return false }
    }
    x = CInt(CLongLong(x)*CLongLong(g) % CLongLong(m))
    assert(x == 1)
    return true
}

final class utilsMathTests: XCTestCase {

    func testFactorsTest() throws {
        for m in CInt(1)..<=50000 {
            let f = factors(m)
            var m2 = m
            for x in f {
                XCTAssertEqual(0, m % x)
                while (m2 % x == 0) { m2 /= x }
            }
            XCTAssertEqual(1, m2)
        }
    }

#if DEBUG
    func testIsPrimitiveRootTest() throws {
        for m in CInt(2)..<=500 {
            if (!_Internal.is_prime_constexpr(m)) { continue }
            for g in 1..<m {
                XCTAssertEqual(is_primitive_root_naive(m, g), is_primitive_root(m, g))
            }
        }
    }
#endif
}
