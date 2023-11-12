import Foundation

// AC - https://atcoder.jp/contests/practice2/submissions/47521141

//extension `internal` {

//template <class mint,
//          int g = internal::primitive_root<mint::mod()>,
//          internal::is_static_modint_t<mint>* = nullptr>
struct fft_info<mint: modint_protocol> {
//    static constexpr int rank2 = countr_zero_constexpr(mint::mod() - 1);
//    std::array<mint, rank2 + 1> root;   // root[i]^(2^i) == 1
//    std::array<mint, rank2 + 1> iroot;  // root[i] * iroot[i] == 1
//
//    std::array<mint, std::max(0, rank2 - 2 + 1)> rate2;
//    std::array<mint, std::max(0, rank2 - 2 + 1)> irate2;
//
//    std::array<mint, std::max(0, rank2 - 3 + 1)> rate3;
//    std::array<mint, std::max(0, rank2 - 3 + 1)> irate3;
    static var g: CInt { `internal`.primitive_root(mint.mod()) }
    static var rank2: CInt { `internal`.countr_zero(UInt32(mint.mod()) - 1) }
    var g: CInt { Self.g }
    var rank2: CInt { Self.rank2 }
    
    var root = [mint](repeating: .init(), count: Int(rank2 + 1))
    var iroot = [mint](repeating: .init(), count: Int(rank2 + 1))
    
    var rate2 = [mint](repeating: .init(), count: Int(rank2 - 2 + 1))
    var irate2 = [mint](repeating: .init(), count: Int(rank2 - 2 + 1))

    var rate3 = [mint](repeating: .init(), count: Int(rank2 - 3 + 1))
    var irate3 = [mint](repeating: .init(), count: Int(rank2 - 3 + 1))

    init() {
        root[Int(rank2)] = mint(g).pow(CLongLong((mint.mod() - 1) >> rank2));
        iroot[Int(rank2)] = root[Int(rank2)].inv();
//        for (int i = rank2 - 1; i >= 0; i--) {
        for i in Int(rank2 - 1)..>=0 {
            root[i] = root[i + 1] * root[i + 1];
            iroot[i] = iroot[i + 1] * iroot[i + 1];
        }

        do {
            var prod: mint = 1; var iprod: mint = 1;
//            for (int i = 0; i <= rank2 - 2; i++) {
            for i in 0..<=Int(rank2 - 2) {
                rate2[i] = root[i + 2] * prod;
                irate2[i] = iroot[i + 2] * iprod;
                prod *= iroot[i + 2];
                iprod *= root[i + 2];
            }
        }
        do {
            var prod: mint = 1; var iprod: mint = 1;
//            for (int i = 0; i <= rank2 - 3; i++) {
            for i in 0..<=Int(rank2 - 3) {
                rate3[i] = root[i + 3] * prod;
                irate3[i] = iroot[i + 3] * iprod;
                prod *= iroot[i + 3];
                iprod *= root[i + 3];
            }
        }
    }
};

//template <class mint, internal::is_static_modint_t<mint>* = nullptr>
func butterfly<mint: modint_protocol>(_ a: inout [mint]) {
    let n = CInt(a.count);
//    int h = internal::countr_zero((unsigned int)n);
    let h = `internal`.countr_zero(CUnsignedInt(n))

//    static const fft_info<mint> info;
    let info = fft_info<mint>(); // 挙動に関して注意
    
    typealias ULL = CUnsignedLongLong

    var len: CInt = 0;  // a[i, i+(n>>len), i+2*(n>>len), ..] is transformed
    while (len < h) {
        if (h - len == 1) {
            let p = 1 << (h - len - 1);
            var rot: mint = 1;
//            for (int s = 0; s < (1 << len); s++) {
            for s in 0..<(1 << len) {
                let offset = s << (h - len);
//                for (int i = 0; i < p; i++) {
                for i in 0..<p {
                    let l = a[i + offset];
                    let r = a[i + offset + p] * rot;
                    a[i + offset] = l + r;
                    a[i + offset + p] = l - r;
                }
                if (s + 1 != (1 << len))
                    { rot *= info.rate2[Int(`internal`.countr_zero(~CUnsignedInt(s)))]; }
            }
            len += 1;
        } else {
            // 4-base
            let p = 1 << (h - len - 2);
            var rot: mint = 1; let imag = info.root[2];
//            for (int s = 0; s < (1 << len); s++) {
            for s in 0..<(1 << len) {
                let rot2 = rot * rot;
                let rot3 = rot2 * rot;
                let offset = s << (h - len);
//                for (int i = 0; i < p; i++) {
                for i in 0..<p {
                    let mod2: ULL = 1 * ULL(mint.mod()) * ULL(mint.mod());
                    let a0: ULL = 1 * ULL(a[i + offset].val());
                    let a1: ULL = 1 * ULL(a[i + offset + p].val()) * ULL(rot.val());
                    let a2: ULL = 1 * ULL(a[i + offset + 2 * p].val()) * ULL(rot2.val());
                    let a3: ULL = 1 * ULL(a[i + offset + 3 * p].val()) * ULL(rot3.val());
                    let a1na3imag =
                    1 * ULL(mint(a1 + ULL(mod2) - a3).val()) * ULL(imag.val());
                    let na2 = mod2 - a2;
                    a[i + offset] = mint(a0 + a2 + a1 + a3);
                    a[i + offset + 1 * p] = mint(a0 + a2 + (2 * mod2 - (a1 + a3)));
                    a[i + offset + 2 * p] = mint(a0 + na2 + a1na3imag);
                    a[i + offset + 3 * p] = mint(a0 + na2 + (mod2 - a1na3imag));
                }
                if (s + 1 != (1 << len))
                    { rot *= info.rate3[Int(`internal`.countr_zero(~(CUnsignedInt(s))))]; }
            }
            len += 2;
        }
    }
}

//template <class mint, internal::is_static_modint_t<mint>* = nullptr>
func butterfly_inv<mint: modint_protocol>(_ a: inout [mint]) {
    let n = CInt(a.count);
    let h = `internal`.countr_zero(CUnsignedInt(n));

//    static const fft_info<mint> info;
    let info = fft_info<mint>(); // 挙動に関して注意

    typealias ULL = CUnsignedLongLong

    var len = h;  // a[i, i+(n>>len), i+2*(n>>len), ..] is transformed
    while ((len) != 0) {
        if (len == 1) {
            let p = 1 << (h - len);
            var irot: mint = 1;
//            for (int s = 0; s < (1 << (len - 1)); s++) {
            for s in 0..<(1 << (len - 1)) {
                let offset = s << (h - len + 1);
//                for (int i = 0; i < p; i++) {
                for i in 0..<p {
                    let l = a[i + offset];
                    let r = a[i + offset + p];
                    a[i + offset] = l + r;
                    a[i + offset + p] = mint(
                        (ULL(mint.mod()) + ULL(l.val()) - ULL(r.val())) *
                    ULL(irot.val()));
                }
                if (s + 1 != (1 << (len - 1)))
                    { irot *= info.irate2[Int(`internal`.countr_zero(~CUnsignedInt(s)))]; }
            }
            len -= 1;
        } else {
            // 4-base
            let p = 1 << (h - len);
            var irot: mint = 1; let iimag = info.iroot[2];
//            for (int s = 0; s < (1 << (len - 2)); s++) {
            for s in 0..<(1 << (len - 2)) {
                let irot2 = irot * irot;
                let irot3 = irot2 * irot;
                let offset = s << (h - len + 2);
//                for (int i = 0; i < p; i++) {
                for i in 0..<p {
                    let a0: ULL = 1 * ULL(a[i + offset + 0 * p].val());
                    let a1: ULL = 1 * ULL(a[i + offset + 1 * p].val());
                    let a2: ULL = 1 * ULL(a[i + offset + 2 * p].val());
                    let a3: ULL = 1 * ULL(a[i + offset + 3 * p].val());

                    let a2na3iimag: ULL =
                        1 *
                    ULL(mint((ULL(mint.mod()) + a2 - a3) * ULL(iimag.val())).val());
                    a[i + offset] = mint(a0 + a1 + a2 + a3);
                    a[i + offset + 1 * p] =
                    mint((a0 + (ULL(mint.mod()) - a1) + a2na3iimag) * ULL(irot.val()));
                    a[i + offset + 2 * p] =
                    mint((a0 + a1 + (ULL(mint.mod()) - a2) + (ULL(mint.mod()) - a3)) *
                        ULL(irot2.val()));
                    a[i + offset + 3 * p] =
                    mint((a0 + (ULL(mint.mod()) - a1) + (ULL(mint.mod()) - a2na3iimag)) *
                        ULL(irot3.val()));
                }
                if (s + 1 != (1 << (len - 2)))
                    { irot *= info.irate3[Int(`internal`.countr_zero(~(CUnsignedInt(s))))]; }
            }
            len -= 2;
        }
    }
}

//template <class mint, internal::is_static_modint_t<mint>* = nullptr>
func convolution_naive<mint: modint_protocol>(_ a: [mint],
                                              _ b: [mint]) -> [mint] {
    let n = a.count, m = b.count;
    var ans = [mint](repeating: .init(), count: n + m - 1);
    if (n < m) {
//        for (int j = 0; j < m; j++) {
        for j in 0..<m {
//            for (int i = 0; i < n; i++) {
            for i in 0..<n {
                ans[i + j] += a[i] * b[j];
            }
        }
    } else {
//        for (int i = 0; i < n; i++) {
        for i in 0..<n {
//            for (int j = 0; j < m; j++) {
            for j in 0..<m {
                ans[i + j] += a[i] * b[j];
            }
        }
    }
    return ans;
}

extension Array where Element: modint_protocol {
    mutating func resize(_ n: Int) {
        if count > n {
            removeLast(count - n)
        } else {
            append(contentsOf: [Element](repeating: 0, count: n - count))
        }
    }
}

//template <class mint, internal::is_static_modint_t<mint>* = nullptr>
func convolution_fft<mint: modint_protocol>(_ a: [mint],_ b: [mint]) -> [mint] {
    var a = a
    var b = b
    let n = CInt(a.count), m = CInt(b.count);
    let z = CInt(`internal`.bit_ceil(CUnsignedInt(n + m - 1)));
    a.resize(Int(z));
    butterfly(&a);
    b.resize(Int(z));
    butterfly(&b);
//    for (int i = 0; i < z; i++) {
    for i in 0..<Int(z) {
        a[i] *= b[i];
    }
    butterfly_inv(&a);
    a.resize(Int(n + m - 1));
    let iz = mint(z).inv();
//    for (int i = 0; i < n + m - 1; i++) a[i] *= iz;
    for i in 0..<Int(n + m - 1) { a[i] *= iz; }
    return a;
}



//}  // namespace internal

//template <class mint, internal::is_static_modint_t<mint>* = nullptr>
func convolution<mint: modint_protocol>(_ a: [mint],_ b: [mint]) -> [mint] {
    let n = a.count, m = b.count;
    if ((n == 0) || (m == 0)) { return []; }

    let z = Int(`internal`.bit_ceil(CUnsignedInt(n + m - 1)));
    assert((Int(mint.mod()) - 1) % z == 0);

    if (min(n, m) <= 60) { return convolution_naive(a, b); }
    return convolution_fft(a, b);
}

//template <class mint, internal::is_static_modint_t<mint>* = nullptr>
//func convolution<mint: modint_protocol>(_ a: [mint],
//                                        _ b: [mint]) -> [mint] {
//    let n = a.count, m = b.count;
//    if ((n == 0) || (m == 0)) { return []; }
//
//    let z = Int(`internal`.bit_ceil(CUnsignedInt(n + m - 1)));
//    assert((Int(mint.mod()) - 1) % z == 0);
//
//    if (min(n, m) <= 60) { return convolution_naive(a, b); }
//    return convolution_fft(a, b);
//}

//template <unsigned int mod = 998244353,
//          class T,
//          std::enable_if_t<internal::is_integral<T>::value>* = nullptr>
func convolution<T: FixedWidthInteger,mint: modint_protocol>(_ t: mint.Type,_ a: [T],_ b: [T]) -> [T] {
    let n = a.count, m = b.count;
    if ((n == 0) || (m == 0)) { return []; }

//    typ mint = static_modint<mod>;

    let z = Int(`internal`.bit_ceil(CUnsignedInt(n + m - 1)));
    assert((Int(mint.mod()) - 1) % z == 0);

    var a2 = [mint](repeating: .init(), count: n), b2 = [mint](repeating: .init(), count: m);
//    for (int i = 0; i < n; i++) {
    for i in 0..<n {
        a2[i] = mint(a[i]);
    }
//    for (int i = 0; i < m; i++) {
    for i in 0..<m {
        b2[i] = mint(b[i]);
    }
    let c2 = convolution(a2, b2);
    var c = [T](repeating: 0, count: n + m - 1);
//    for (int i = 0; i < n + m - 1; i++) {
    for i in 0..<(n + m - 1) {
        c[i] = T(c2[i].val());
    }
    return c;
}

/*
std::vector<long long> convolution_ll(const std::vector<long long>& a,
                                      const std::vector<long long>& b) {
    int n = int(a.size()), m = int(b.size());
    if (!n || !m) return {};

    static constexpr unsigned long long MOD1 = 754974721;  // 2^24
    static constexpr unsigned long long MOD2 = 167772161;  // 2^25
    static constexpr unsigned long long MOD3 = 469762049;  // 2^26
    static constexpr unsigned long long M2M3 = MOD2 * MOD3;
    static constexpr unsigned long long M1M3 = MOD1 * MOD3;
    static constexpr unsigned long long M1M2 = MOD1 * MOD2;
    static constexpr unsigned long long M1M2M3 = MOD1 * MOD2 * MOD3;

    static constexpr unsigned long long i1 =
        internal::inv_gcd(MOD2 * MOD3, MOD1).second;
    static constexpr unsigned long long i2 =
        internal::inv_gcd(MOD1 * MOD3, MOD2).second;
    static constexpr unsigned long long i3 =
        internal::inv_gcd(MOD1 * MOD2, MOD3).second;
        
    static constexpr int MAX_AB_BIT = 24;
    static_assert(MOD1 % (1ull << MAX_AB_BIT) == 1, "MOD1 isn't enough to support an array length of 2^24.");
    static_assert(MOD2 % (1ull << MAX_AB_BIT) == 1, "MOD2 isn't enough to support an array length of 2^24.");
    static_assert(MOD3 % (1ull << MAX_AB_BIT) == 1, "MOD3 isn't enough to support an array length of 2^24.");
    assert(n + m - 1 <= (1 << MAX_AB_BIT));

    auto c1 = convolution<MOD1>(a, b);
    auto c2 = convolution<MOD2>(a, b);
    auto c3 = convolution<MOD3>(a, b);

    std::vector<long long> c(n + m - 1);
    for (int i = 0; i < n + m - 1; i++) {
        unsigned long long x = 0;
        x += (c1[i] * i1) % MOD1 * M2M3;
        x += (c2[i] * i2) % MOD2 * M1M3;
        x += (c3[i] * i3) % MOD3 * M1M2;
        // B = 2^63, -B <= x, r(real value) < B
        // (x, x - M, x - 2M, or x - 3M) = r (mod 2B)
        // r = c1[i] (mod MOD1)
        // focus on MOD1
        // r = x, x - M', x - 2M', x - 3M' (M' = M % 2^64) (mod 2B)
        // r = x,
        //     x - M' + (0 or 2B),
        //     x - 2M' + (0, 2B or 4B),
        //     x - 3M' + (0, 2B, 4B or 6B) (without mod!)
        // (r - x) = 0, (0)
        //           - M' + (0 or 2B), (1)
        //           -2M' + (0 or 2B or 4B), (2)
        //           -3M' + (0 or 2B or 4B or 6B) (3) (mod MOD1)
        // we checked that
        //   ((1) mod MOD1) mod 5 = 2
        //   ((2) mod MOD1) mod 5 = 3
        //   ((3) mod MOD1) mod 5 = 4
        long long diff =
            c1[i] - internal::safe_mod((long long)(x), (long long)(MOD1));
        if (diff < 0) diff += MOD1;
        static constexpr unsigned long long offset[5] = {
            0, 0, M1M2M3, 2 * M1M2M3, 3 * M1M2M3};
        x -= offset[diff % 5];
        c[i] = x;
    }

    return c;
}

}  // namespace atcoder

#endif  // ATCODER_CONVOLUTION_HPP

*/