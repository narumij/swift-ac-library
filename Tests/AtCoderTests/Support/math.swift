import Foundation

#if DEBUG
  @testable import AtCoder
#else
  import AtCoder
#endif

func factors(_ m: Int) -> [Int] {
  var m = m
  var result = [Int]()
  for i in sequence(
    first: 2, next: { $0 * $0 <= m ? $0 + 1 : nil })
  {
    if m % i == 0 {
      result.append(i)
      while m % i == 0 {
        m /= i
      }
    }
  }

  if m > 1 { result.append(m) }
  return result
}

#if DEBUG
  func is_primitive_root(_ m: Int, _ g: Int) -> Bool {
    assert(1 <= g && g < m)
    for x in factors(m - 1) {
      if _Internal.pow_mod_constexpr(Int(g), Int((m - 1) / x), Int(m)) == 1 { return false }
    }
    return true
  }
#endif
