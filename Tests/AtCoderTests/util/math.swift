import Foundation
#if DEBUG
@testable import AtCoder
#endif

func factors(_ m: CInt) -> [CInt] {
    var m = m
    var result = [CInt]()
    for i in sequence(first: CInt(2), next: { CLongLong($0) * CLongLong($0) <= CLongLong(m) ? $0 + 1 : nil }) {
        if m % i == 0 {
            result.append(i)
            while m % i == 0 {
                m /= i
            }
        }
    }
    
    if (m > 1) { result.append(m) }
    return result
}

#if DEBUG
func is_primitive_root(_ m: CInt,_ g: CInt) -> Bool {
    assert(1 <= g && g < m)
    for x in factors(m - 1) {
        if _Internal.pow_mod_constexpr(CLongLong(g), CLongLong((m - 1) / x), m) == 1 { return false }
    }
    return true
}
#endif
