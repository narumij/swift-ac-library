import Foundation

extension _Internal {
    
    static func sa_naive<Element>(pointer s: UnsafePointer<Element>, count n: Int) -> [Int] where Element: Comparable {
        
        (0 ..< n)
            .sorted { l, r in
                if l == r { return false }
                var l = l, r = r
                while l < n, r < n {
                    if s[l] != s[r] { return s[l] < s[r] }
                    l += 1
                    r += 1
                }
                return l == n
            }
    }
    
    static func sa_naive(_ s: [Int]) -> [Int] {
        s.withUnsafeBufferPointer { sa_naive(pointer: $0.baseAddress!, count: s.count) }
    }
    
    static func sa_doubling<Element>(_ s: [Element]) -> [Int] where Element: Comparable & AdditiveArithmetic & ExpressibleByIntegerLiteral {
        let n = s.count
        var sa = (0 ..< n) + [], rnk = s, tmp = [Element](repeating: 0, count: n)
        
        do {
            // for (int k = 1; k < n; k *= 2) {
            var k = 1
            while k < n {
                defer { k *= 2 }
                
                func cmp(_ x: Int,_ y: Int) -> Bool {
                    if rnk[x] != rnk[y] { return rnk[x] < rnk[y] }
                    let rx = x + k < n ? rnk[x + k] : -1
                    let ry = y + k < n ? rnk[y + k] : -1
                    return rx < ry
                }
                
                sa.sort(by: cmp)
                tmp[sa[0]] = 0
                
                // for (int i = 1; i < n; i++) {
                for i in 1 ..< n {
                    tmp[sa[i]] = tmp[sa[i - 1]] + (cmp(sa[i - 1], sa[i]) ? 1 : 0)
                }
                swap(&tmp, &rnk)
            }
        }
        
        return sa
    }
    
    static func sa_doubling<Element>(pointer s: UnsafePointer<Element>, count n: Int) -> [Int] where Element: Comparable & AdditiveArithmetic & ExpressibleByIntegerLiteral {
        sa_doubling((0 ..< n).map{ s[$0] })
    }
    
    // SA-IS, linear-time suffix array construction
    // Reference:
    // G. Nong, S. Zhang, and W. H. Chan,
    // Two Efficient Algorithms for Linear Time Suffix Array Construction
    static func sa_is<Element>(_ s: UnsafePointer<Element>, count n: Int,_ upper: Int,_ THRESHOLD_NAIVE: Int = 10,_ THRESHOLD_DOUBLING: Int = 40) -> [Int] where Element: FixedWidthInteger {
        if n == 0 { return [] }
        if n == 1 { return [0] }
        if n == 2 {
            if s[0] < s[1] {
                return [0, 1]
            } else {
                return [1, 0]
            }
        }
        if n < THRESHOLD_NAIVE {
            return sa_naive(pointer: s, count: n)
        }
        if n < THRESHOLD_DOUBLING {
            return sa_doubling(pointer: s, count: n)
        }
        
        var sa = [Int](repeating: 0, count: n)
        var ls = [Bool](repeating: false, count: n)
        //        for (int i = n - 2; i >= 0; i--) {
        for i in (n - 2) ..>= 0 {
            ls[i] = s[i] == s[i + 1] ? ls[i + 1] : s[i] < s[i + 1]
        }
        var sum_l = [Int](repeating: 0, count: upper + 1), sum_s = [Int](repeating: 0, count: upper + 1)
        // for (int i = 0; i < n; i++) {
        for i in 0 ..< n {
            if !ls[i] {
                sum_s[s[i]] += 1
            } else {
                sum_l[s[i] + 1] += 1
            }
        }
        //  for (int i = 0; i <= upper; i++) {
        for i in 0 ..<= upper {
            sum_s[i] += sum_l[i]
            if i < upper { sum_l[i + 1] += sum_s[i] }
        }
        
        func induce(_ lms: [Int]) {
            sa.withUnsafeMutableBufferPointer{ $0.update(repeating: -1) }
            var buf = [Int](repeating: 0, count: upper + 1)
            // std::copy(sum_s.begin(), sum_s.end(), buf.begin());
            buf = sum_s
            // for (auto d : lms) {
            for d in lms {
                if d == n { continue }
                sa[buf[s[d]]] = d; buf[s[d]] += 1
            }
            // std::copy(sum_l.begin(), sum_l.end(), buf.begin());
            buf = sum_l
            sa[buf[s[n - 1]]] = n - 1; buf[s[n - 1]] += 1
            // for (int i = 0; i < n; i++) {
            for i in 0 ..< n {
                let v = sa[i]
                if v >= 1, !ls[v - 1] {
                    sa[buf[s[v - 1]]] = v - 1; buf[s[v - 1]] += 1
                }
            }
            // std::copy(sum_l.begin(), sum_l.end(), buf.begin());
            buf = sum_l
            // for (int i = n - 1; i >= 0; i--) {
            for i in (n - 1) ..>= 0 {
                let v = sa[i]
                if v >= 1, ls[v - 1] {
                    buf[s[v - 1] + 1] -= 1; sa[buf[s[v - 1] + 1]] = v - 1
                }
            }
        }
        
        var lms_map = [Int](repeating: -1, count: n + 1)
        var m: Int = 0
        // for (int i = 1; i < n; i++) {
        for i in 1 ..< n {
            if !ls[i - 1], ls[i] {
                lms_map[i] = m; m += 1
            }
        }
        var lms = [Int]()
        lms.reserveCapacity(m)
        // for (int i = 1; i < n; i++) {
        for i in 1 ..< n {
            if !ls[i - 1], ls[i] {
                lms.append(i)
            }
        }
        
        induce(lms)
        
        if m != 0 {
            var sorted_lms = [Int]()
            sorted_lms.reserveCapacity(m)
            // for (int v : sa) {
            for v in sa {
                if lms_map[v] != -1 { sorted_lms.append(v) }
            }
            var rec_s = [Int](repeating: 0, count: m)
            var rec_upper: Int = 0
            rec_s[lms_map[sorted_lms[0]]] = 0
            // for (int i = 1; i < m; i++) {
            for i in 1 ..< m {
                var l = sorted_lms[i - 1], r = sorted_lms[i]
                let end_l = lms_map[l] + 1 < m ? lms[lms_map[l] + 1] : n
                let end_r = lms_map[r] + 1 < m ? lms[lms_map[r] + 1] : n
                var same = true
                if end_l - l != end_r - r {
                    same = false
                } else {
                    while l < end_l {
                        if (s[l] != s[r]) {
                            break
                        }
                        l += 1
                        r += 1
                    }
                    if l == n || s[l] != s[r] { same = false }
                }
                if !same { rec_upper += 1 }
                rec_s[lms_map[sorted_lms[i]]] = rec_upper
            }
            
            let rec_sa =
            sa_is(rec_s, rec_upper, THRESHOLD_NAIVE, THRESHOLD_DOUBLING)
            
            // for (int i = 0; i < m; i++) {
            for i in 0 ..< m {
                sorted_lms[i] = lms[rec_sa[i]]
            }
            induce(sorted_lms)
        }
        return sa
    }
    
    static func sa_is(_ s: [Int],_ upper: Int,_ THRESHOLD_NAIVE: Int = 10,_ THRESHOLD_DOUBLING: Int = 40) -> [Int] {
        s.withUnsafeBufferPointer {
            sa_is($0.baseAddress!, count: s.count, upper, THRESHOLD_NAIVE, THRESHOLD_DOUBLING)
        }
    }
    
}

func suffix_array(_ s: [Int],_ upper: Int) -> [Int] {
    assert(0 <= upper)
    assert(s.allSatisfy{ d in (0 ... upper).contains(d) })
    let sa = _Internal.sa_is(s, upper)
    return sa
}

public func suffix_array<V>(_ s: V) -> [Int]
where V: Collection, V.Element: Comparable, V.Index == Int
{
    let n = s.count
#if false
    var idx = [Int](repeating: 0, count: n)
    idx = (0..<n).map { $0 }
    idx.sort { l, r in return s[l] < s[r] }
#else
    let idx = (0 ..< n).sorted { s[$0] < s[$1] }
#endif
    var s2 = [Int](repeating: 0, count: n)
    var now = 0
    // for (int i = 0; i < n; i++) {
    for i in 0 ..< n {
        if i != 0, s[idx[i - 1]] != s[idx[i]] { now += 1 }
        s2[idx[i]] = now
    }
    return _Internal.sa_is(s2, now)
}

public func suffix_array(_ s: String) -> [Int] {
    s.withCString { _Internal.sa_is( $0, count: s.count, 255) }
}

// Reference:
// T. Kasai, G. Lee, H. Arimura, S. Arikawa, and K. Park,
// Linear-Time Longest-Common-Prefix Computation in Suffix Arrays and Its
// Applications
public func lcp_array<Element>(pointer s: UnsafePointer<Element>, count n: Int, _ sa: [Int]) -> [Int]
where Element: Equatable
{
    assert(n >= 1)
    var rnk = [Int](repeating: 0, count: n)
    // for (int i = 0; i < n; i++) {
    for i in 0 ..< n {
        rnk[sa[i]] = i
    }
    var lcp = [Int](repeating: 0, count: n - 1)
    var h = 0
    // for (int i = 0; i < n; i++) {
    for i in 0 ..< n {
        if h > 0 { h -= 1 }
        if rnk[i] == 0 { continue }
        let j = sa[rnk[i] - 1]
        // for (; j + h < n && i + h < n; h++) {
        while j + h < n, i + h < n { defer { h += 1 }
            if s[j + h] != s[i + h] { h -= 1; /* defer分の補正 */ break }
        }
        lcp[rnk[i] - 1] = h
    }
    return lcp
}

public func lcp_array<V>(_ s: V, _ sa: [Int]) -> [Int]
where V: Collection, V.Element: Equatable, V.Index == Int {
    s.map{ $0 }.withUnsafeBufferPointer { lcp_array(pointer: $0.baseAddress!, count: s.count, sa) }
}

public func lcp_array(_ s: String,_ sa: [Int]) -> [Int] {
    s.withCString { lcp_array(pointer: $0, count: s.count, sa) }
}

// Reference:
// D. Gusfield,
// Algorithms on Strings, Trees, and Sequences: Computer Science and
// Computational Biology
public func z_algorithm<Element>(pointer s: UnsafePointer<Element>, count n: Int) -> [Int]
where Element: Comparable
{
    if n == 0 { return [] }
    var z = [Int](repeating: 0, count: n)
    z[0] = 0
    // for (int i = 1, j = 0; i < n; i++) {
    var j = 0
    for i in 0 ..< n {
        // int& k = z[i];
        // k = (j + z[j] <= i) ? 0 : std::min(j + z[j] - i, z[i - j]);
        // while (i + k < n && s[k] == s[i + k]) k++;
        // if (j + z[j] < i + z[i]) j = i;
        z[i] = j + z[j] <= i ? 0 : min(j + z[j] - i, z[i - j])
        while i + z[i] < n, s[z[i]] == s[i + z[i]] { z[i] += 1 }
        if j + z[j] < i + z[i] { j = i }
    }
    z[0] = n
    return z
}

public func z_algorithm<V>(_ s: V) -> [Int]
where V: Collection, V.Element: Comparable, V.Index == Int {
    s.map{ $0 }.withUnsafeBufferPointer { z_algorithm(pointer: $0.baseAddress!, count: s.count) }
}

public func z_algorithm(_ s: String) -> [Int] {
    s.withCString { z_algorithm(pointer: $0, count: s.count) }
}
