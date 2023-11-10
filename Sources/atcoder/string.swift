import Foundation

extension `internal` {

    static func sa_naive(_ s: [Int]) -> [Int] {
        let n = s.count;
        var sa = [Int](repeating: 0, count: n);
        sa = (0..<n).map{ $0 }
        sa.sort { l, r in
            var l = l, r = r
            if (l == r) { return false; }
            while (l < n && r < n) {
                if (s[l] != s[r]) { return s[l] < s[r]; }
                l += 1;
                r += 1;
            }
            return l == n;
        };
        return sa;
    }
    
    static func sa_doubling(_ s: [Int]) -> [Int] {
        let n = s.count;
        var sa = [Int](repeating: 0, count: n), rnk = s, tmp = [Int](repeating: 0, count: n);
        sa = (0..<n).map{ $0 }
//        for (int k = 1; k < n; k *= 2) {
        do { var k = 1; while k < n { defer { k *= 2 }
            func cmp(_ x: Int,_ y: Int) -> Bool {
                if (rnk[x] != rnk[y]) { return rnk[x] < rnk[y]; }
                let rx = x + k < n ? rnk[x + k] : -1;
                let ry = y + k < n ? rnk[y + k] : -1;
                return rx < ry;
            };
            sa.sort(by: cmp)
            tmp[sa[0]] = 0;
//            for (int i = 1; i < n; i++) {
            for i in 1..<n {
                tmp[sa[i]] = tmp[sa[i - 1]] + (cmp(sa[i - 1], sa[i]) ? 1 : 0);
            }
            swap(&tmp, &rnk);
        } }
        return sa;
    }
    
    // SA-IS, linear-time suffix array construction
    // Reference:
    // G. Nong, S. Zhang, and W. H. Chan,
    // Two Efficient Algorithms for Linear Time Suffix Array Construction
//    template <int THRESHOLD_NAIVE = 10, int THRESHOLD_DOUBLING = 40>
    static func sa_is(_ s: [Int],_ upper: Int,_ THRESHOLD_NAIVE: Int = 10,_ THRESHOLD_DOUBLING: Int = 40) -> [Int] {
        let n = s.count;
        if (n == 0) { return []; }
        if (n == 1) { return [0]; }
        if (n == 2) {
            if (s[0] < s[1]) {
                return [0, 1];
            } else {
                return [1, 0];
            }
        }
        if (n < THRESHOLD_NAIVE) {
            return sa_naive(s);
        }
        if (n < THRESHOLD_DOUBLING) {
            return sa_doubling(s);
        }
        
        var sa = [Int](repeating: 0, count: n);
        var ls = [Bool](repeating: false, count: n);
//        for (int i = n - 2; i >= 0; i--) {
        for i in (n - 2)..>=0 {
            ls[i] = (s[i] == s[i + 1]) ? ls[i + 1] : (s[i] < s[i + 1]);
        }
        var sum_l = [Int](repeating: 0, count: upper + 1), sum_s = [Int](repeating: 0, count: upper + 1);
//        for (int i = 0; i < n; i++) {
        for i in 0..<n {
            if (!ls[i]) {
                sum_s[s[i]] += 1;
            } else {
                sum_l[s[i] + 1] += 1;
            }
        }
//        for (int i = 0; i <= upper; i++) {
        for i in 0..<=upper {
            sum_s[i] += sum_l[i];
            if (i < upper) { sum_l[i + 1] += sum_s[i]; }
        }
        
        func induce(_ lms: [Int]) {
            sa.withUnsafeMutableBufferPointer{ $0.update(repeating: -1) }
            var buf = [Int](repeating: 0, count: upper + 1);
//            std::copy(sum_s.begin(), sum_s.end(), buf.begin());
            buf = sum_s
//            for (auto d : lms) {
            for d in lms {
                if (d == n) { continue; }
                sa[buf[s[d]]] = d; buf[s[d]] += 1
            }
//            std::copy(sum_l.begin(), sum_l.end(), buf.begin());
            buf = sum_l
            sa[buf[s[n - 1]]] = n - 1; buf[s[n - 1]] += 1
//            for (int i = 0; i < n; i++) {
            for i in 0..<n {
                let v = sa[i];
                if (v >= 1 && !ls[v - 1]) {
                    sa[buf[s[v - 1]]] = v - 1; buf[s[v - 1]] += 1
                }
            }
//            std::copy(sum_l.begin(), sum_l.end(), buf.begin());
            buf = sum_l
//            for (int i = n - 1; i >= 0; i--) {
            for i in (n - 1)..>=0 {
                let v = sa[i];
                if (v >= 1 && ls[v - 1]) {
                    buf[s[v - 1] + 1] -= 1; sa[buf[s[v - 1] + 1]] = v - 1;
                }
            }
        };
        
        var lms_map = [Int](repeating: -1, count: n + 1);
        var m = 0;
//        for (int i = 1; i < n; i++) {
        for i in 1..<n {
            if (!ls[i - 1] && ls[i]) {
                lms_map[i] = m; m += 1
            }
        }
        var lms = [Int]();
        lms.reserveCapacity(m);
//        for (int i = 1; i < n; i++) {
        for i in 1..<n {
            if (!ls[i - 1] && ls[i]) {
                lms.append(i);
            }
        }
        
        induce(lms);
        
        if ((m) != 0) {
            var sorted_lms = [Int]();
            sorted_lms.reserveCapacity(m);
//            for (int v : sa) {
            for v in sa {
                if (lms_map[v] != -1) { sorted_lms.append(v); }
            }
            var rec_s = [Int](repeating: 0, count: m);
            var rec_upper = 0;
            rec_s[lms_map[sorted_lms[0]]] = 0;
//            for (int i = 1; i < m; i++) {
            for i in 1..<m {
                var l = sorted_lms[i - 1], r = sorted_lms[i];
                let end_l = (lms_map[l] + 1 < m) ? lms[lms_map[l] + 1] : n;
                let end_r = (lms_map[r] + 1 < m) ? lms[lms_map[r] + 1] : n;
                var same = true;
                if (end_l - l != end_r - r) {
                    same = false;
                } else {
                    while (l < end_l) {
                        if (s[l] != s[r]) {
                            break;
                        }
                        l += 1;
                        r += 1;
                    }
                    if (l == n || s[l] != s[r]) { same = false; }
                }
                if (!same) { rec_upper += 1 };
                rec_s[lms_map[sorted_lms[i]]] = rec_upper;
            }
            
            let rec_sa =
            sa_is(rec_s, rec_upper, THRESHOLD_NAIVE, THRESHOLD_DOUBLING);
            
//            for (int i = 0; i < m; i++) {
            for i in 0..<m {
                sorted_lms[i] = lms[rec_sa[i]];
            }
            induce(sorted_lms);
        }
        return sa;
    }

}  // namespace internal

func suffix_array(_ s: [Int],_ upper: Int) -> [Int] {
    assert(0 <= upper);
//    for (int d : s) {
    for d in s {
        assert(0 <= d && d <= upper);
    }
    let sa = `internal`.sa_is(s, upper);
    return sa;
}

func suffix_array<T: Comparable>(_ s: [T]) -> [Int] {
    let n = s.count;
    var idx = [Int](repeating: 0, count: n);
    idx = (0..<n).map { $0 }
    idx.sort { l, r in return s[l] < s[r]; };
    var s2 = [Int](repeating: 0, count: n);
    var now = 0;
//    for (int i = 0; i < n; i++) {
    for i in 0..<n {
        if ((i != 0) && s[idx[i - 1]] != s[idx[i]]) { now += 1; }
        s2[idx[i]] = now;
    }
    return `internal`.sa_is(s2, now);
}

func suffix_array(_ s: String) -> [Int] {
    let n = s.count;
    var s2 = [Int](repeating: 0, count: n);
//    for (int i = 0; i < n; i++) {
    for i in 0..<n {
        s2[i] = Int(s[s.index(s.startIndex, offsetBy: i)].asciiValue!);
    }
    return `internal`.sa_is(s2, 255);
}

// Reference:
// T. Kasai, G. Lee, H. Arimura, S. Arikawa, and K. Park,
// Linear-Time Longest-Common-Prefix Computation in Suffix Arrays and Its
// Applications
func lcp_array<T: Equatable>(_ s: [T],
                  _ sa: [Int]) -> [Int] {
    let n = s.count;
    assert(n >= 1);
    var rnk = [Int](repeating: 0, count: n);
//    for (int i = 0; i < n; i++) {
    for i in 0..<n {
        rnk[sa[i]] = i;
    }
    var lcp = [Int](repeating: 0, count: n - 1);
    var h = 0;
//    for (int i = 0; i < n; i++) {
    for i in 0..<n {
        if (h > 0) { h -= 1; }
        if (rnk[i] == 0) { continue; }
        let j = sa[rnk[i] - 1];
        //        for (; j + h < n && i + h < n; h++) {
        while j + h < n && i + h < n { defer { h += 1 }
            if (s[j + h] != s[i + h]) { break; }
        }
        lcp[rnk[i] - 1] = h;
    }
    return lcp;
}

func lcp_array(_ s: String,_ sa: [Int]) -> [Int] {
    let n = s.count;
    var s2 = [Int](repeating: 0, count: n);
//    for (int i = 0; i < n; i++) {
    for i in 0..<n {
        s2[i] = Int(s[s.index(s.startIndex, offsetBy: i)].asciiValue!);
    }
    return lcp_array(s2, sa);
}

// Reference:
// D. Gusfield,
// Algorithms on Strings, Trees, and Sequences: Computer Science and
// Computational Biology
func z_algorithm<T: Comparable>(_ s: [T]) -> [Int] {
    var n = s.count;
    if (n == 0) { return []; }
    var z = [Int](repeating: 0, count: n);
    z[0] = 0;
//    for (int i = 1, j = 0; i < n; i++) {
    var j = 0
    for i in 0..<n {
//        int& k = z[i];
        func k(_ k: inout Int) {
            k = (j + z[j] <= i) ? 0 : min(j + z[j] - i, z[i - j]);
            while (i + k < n && s[k] == s[i + k]) { k += 1; }
            if (j + z[j] < i + z[i]) { j = i; }
        }
        k(&z[i])
    }
    z[0] = n;
    return z;
}

func z_algorithm(_ s: String) -> [Int] {
    var n = s.count;
    var s2 = [Int](repeating: 0, count: n);
//    for (int i = 0; i < n; i++) {
    for i in 0..<n {
        s2[i] = Int(s[s.index(s.startIndex, offsetBy: i)].asciiValue!);
    }
    return z_algorithm(s2);
}


