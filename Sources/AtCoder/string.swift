import Foundation

extension _Internal {

static func sa_naive<int>(_ s: [int]) -> [Int] where int: FixedWidthInteger {
    let n = s.count;
    var sa = [Int](repeating: 0, count: n);
    sa = (0..<n).map{ $0 }
    sa.sort(by: { l, r in
        var l = l, r = r
        if (l == r) { return false; }
        while (l < n && r < n) {
            if (s[l] != s[r]) { return s[l] < s[r]; }
            l += 1;
            r += 1;
        }
        return l == n;
    });
    return sa;
}

static func sa_doubling<int>(_ s: [int]) -> [Int] where int: FixedWidthInteger {
    let n = s.count;
    var sa = [Int](repeating: 0, count: n), rnk = s, tmp = [int](repeating: 0, count: n);
    sa = (0..<n).map{ $0 }
    // for (int k = 1; k < n; k *= 2) {
    do { var k = 1; while k < n { defer { k *= 2 }
        func cmp(_ x: Int,_ y: Int) -> Bool {
            if (rnk[x] != rnk[y]) { return rnk[x] < rnk[y]; }
            let rx = x + k < n ? rnk[x + k] : -1;
            let ry = y + k < n ? rnk[y + k] : -1;
            return rx < ry;
        };
        sa.sort(by: cmp)
        tmp[sa[0]] = 0;
        // for (int i = 1; i < n; i++) {
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
static func sa_is<int>(_ s: [int],_ upper: int,_ THRESHOLD_NAIVE: int = 10,_ THRESHOLD_DOUBLING: int = 40) -> [Int]
    where int: FixedWidthInteger {
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
    var sum_l = [int](repeating: 0, count: Int(upper + 1)), sum_s = [int](repeating: 0, count: Int(upper + 1));
    // for (int i = 0; i < n; i++) {
    for i in 0..<n {
        if (!ls[i]) {
            sum_s[s[i]] += 1;
        } else {
            sum_l[s[i] + 1] += 1;
        }
    }
    //  for (int i = 0; i <= upper; i++) {
    for i in 0..<=upper {
        sum_s[i] += sum_l[i];
        if (i < upper) { sum_l[i + 1] += sum_s[i]; }
    }

    func induce(_ lms: [int]) {
        sa.withUnsafeMutableBufferPointer{ $0.update(repeating: -1) }
        var buf = [int](repeating: 0, count: Int(upper + 1));
        // std::copy(sum_s.begin(), sum_s.end(), buf.begin());
        buf = sum_s
        // for (auto d : lms) {
        for d in lms {
            if (d == n) { continue; }
            sa[buf[s[d]]] = Int(d); buf[s[d]] += 1
        }
        // std::copy(sum_l.begin(), sum_l.end(), buf.begin());
        buf = sum_l
        sa[buf[s[n - 1]]] = n - 1; buf[s[n - 1]] += 1
        // for (int i = 0; i < n; i++) {
        for i in 0..<n {
            let v = sa[i];
            if (v >= 1 && !ls[v - 1]) {
                sa[buf[s[v - 1]]] = v - 1; buf[s[v - 1]] += 1
            }
        }
        // std::copy(sum_l.begin(), sum_l.end(), buf.begin());
        buf = sum_l
        // for (int i = n - 1; i >= 0; i--) {
        for i in (n - 1)..>=0 {
            let v = sa[i];
            if (v >= 1 && ls[v - 1]) {
                buf[s[v - 1] + 1] -= 1; sa[buf[s[v - 1] + 1]] = v - 1;
            }
        }
    };

    var lms_map = [int](repeating: -1, count: n + 1);
    var m: int = 0;
    // for (int i = 1; i < n; i++) {
    for i in 1..<n {
        if (!ls[i - 1] && ls[i]) {
            lms_map[i] = m; m += 1
        }
    }
    var lms = [int]();
    lms.reserveCapacity(Int(m));
    // for (int i = 1; i < n; i++) {
    for i in 1..<int(n) {
        if (!ls[i - 1] && ls[i]) {
            lms.append(i);
        }
    }

    induce(lms);

    if ((m) != 0) {
        var sorted_lms = [int]();
        sorted_lms.reserveCapacity(Int(m));
        // for (int v : sa) {
        for v in sa {
            if (lms_map[v] != -1) { sorted_lms.append(int(v)); }
        }
        var rec_s = [int](repeating: 0, count: Int(m));
        var rec_upper: int = 0;
        rec_s[lms_map[sorted_lms[0]]] = 0;
        // for (int i = 1; i < m; i++) {
        for i in 1..<m {
            var l = sorted_lms[i - 1], r = sorted_lms[i];
            let end_l = (lms_map[l] + 1 < m) ? lms[lms_map[l] + 1] : int(n);
            let end_r = (lms_map[r] + 1 < m) ? lms[lms_map[r] + 1] : int(n);
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

        // for (int i = 0; i < m; i++) {
        for i in 0..<m {
            sorted_lms[i] = lms[rec_sa[i]];
        }
        induce(sorted_lms);
    }
    return sa;
}

}  // namespace internal

public func suffix_array<int>(_ s: [int],_ upper: int) -> [Int]
where int: FixedWidthInteger
{
    assert(0 <= upper);
    assert(s.allSatisfy{ d in (0...upper).contains(d) })
    let sa = _Internal.sa_is(s, upper);
    return sa;
}

public func suffix_array<V>(_ s: V) -> [Int]
where V: Collection, V.Element: Comparable, V.Index == Int
{
    let n = s.count
#if false
    var idx = [Int](repeating: 0, count: n)
    idx = (0..<n).map { $0 }
    idx.sort { l, r in return s[l] < s[r]; }
#else
    let idx = (0..<n).sorted { l, r in return s[l] < s[r]; }
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
    _Internal.sa_is(s.utf8CString.dropLast().map(UInt8.init), 255);
}

// Reference:
// T. Kasai, G. Lee, H. Arimura, S. Arikawa, and K. Park,
// Linear-Time Longest-Common-Prefix Computation in Suffix Arrays and Its
// Applications
public func lcp_array<V>(_ s: V, _ sa: [Int]) -> [Int]
where V: Collection, V.Element: Equatable, V.Index == Int
{
    let n = s.count
    assert(n >= 1)
    var rnk = [Int](repeating: 0, count: n)
    // for (int i = 0; i < n; i++) {
    for i in 0..<n {
        rnk[sa[i]] = i
    }
    var lcp = [Int](repeating: 0, count: n - 1)
    var h = 0
    // for (int i = 0; i < n; i++) {
    for i in 0 ..< n {
        if h > 0 { h -= 1 }
        if rnk[i] == 0 { continue }
        let j = Int(sa[rnk[i] - 1])
        // for (; j + h < n && i + h < n; h++) {
        while j + h < n && i + h < n { defer { h += 1 }
            if (s[j + h] != s[i + h]) { h -= 1; /* defer分の補正 */ break }
        }
        lcp[rnk[i] - 1] = h
    }
    return lcp
}

public func lcp_array(_ s: String,_ sa: [Int]) -> [Int] {
    lcp_array(s.utf8CString.dropLast(), sa)
}

// Reference:
// D. Gusfield,
// Algorithms on Strings, Trees, and Sequences: Computer Science and
// Computational Biology
public func z_algorithm<V>(_ s: V) -> [Int]
where V: Collection, V.Element: Comparable, V.Index == Int
{
    let n = s.count
    if (n == 0) { return [] }
    var z = [Int](repeating: 0, count: n)
    z[0] = 0
    // for (int i = 1, j = 0; i < n; i++) {
    var j = 0
    for i in 0 ..< n {
        // int& k = z[i];
        // k = (j + z[j] <= i) ? 0 : std::min(j + z[j] - i, z[i - j]);
        // while (i + k < n && s[k] == s[i + k]) k++;
        // if (j + z[j] < i + z[i]) j = i;
        z[i] = (j + z[j] <= i) ? 0 : min(j + z[j] - i, z[i - j])
        while i + z[i] < n && s[z[i]] == s[i + z[i]] { z[i] += 1 }
        if j + z[j] < i + z[i] { j = i }
    }
    z[0] = n
    return z
}

public func z_algorithm(_ s: String) -> [Int] {
    z_algorithm(s.utf8CString.dropLast())
}
