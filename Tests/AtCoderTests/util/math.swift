import Foundation
@testable import AtCoder

func factors(_ m: CInt) -> [CInt] {
    var m = m
    var result = [CInt]();
//    for (int i = 2; (long long)(i)*i <= m; i++) {
    do { var i = CInt(2); while CLongLong(i)*CLongLong(i) <= CLongLong(m) { defer { i += 1 }
        if (m % i == 0) {
            result.append(i);
            while (m % i == 0) {
                m /= i;
            }
        }
    } }
    
    if (m > 1) { result.append(m); }
    return result;
}

func is_primitive_root(_ m: CInt,_ g: CInt) -> Bool {
    assert(1 <= g && g < m);
    for x in factors(m - 1) {
        if (_internal.pow_mod_constexpr(CLongLong(g), CLongLong((m - 1) / x), m) == 1) { return false; }
    }
    return true;
}
