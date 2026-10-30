import Testing

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

func is_primitive_root_naive(_ m: Int, _ g: Int) -> Bool {
  assert(1 <= g && g < m)
  var x: Int = 1
  for _ in 1 ..<= (m - 2) {
    x = x * g % m
    // x == n^i
    if x == 1 { return false }
  }
  x = x * g % m
  assert(x == 1)
  return true
}

extension LibraryTests {
  final class utilsMathTests {

    @Test(.tags(.aclPort))
    func testFactorsTest() throws {
      for m in Int(1) ..<= 50000 {
        let f = factors(m)
        var m2 = m
        for x in f {
          #expect(0 == m % x)
          while m2 % x == 0 { m2 /= x }
        }
        #expect(1 == m2)
      }
    }

    #if DEBUG
      @Test(.tags(.aclPort))
      func testIsPrimitiveRootTest() throws {
        for m in Int(2) ..<= 500 {
          if !_Internal.is_prime_constexpr(Int(m)) { continue }
          for g in 1..<m {
            #expect(is_primitive_root_naive(m, g) == is_primitive_root(m, g))
          }
        }
      }
    #endif
  }

}
