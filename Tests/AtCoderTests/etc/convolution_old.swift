import Foundation
#if DEBUG
@testable import AtCoder

extension _Internal {

//template <class mint, internal::is_static_modint_t<mint>* = nullptr>
static func butterfly<mod: static_mod>(_ a: UnsafeMutableBufferPointer<static_modint<mod>>) {
    typealias mint = static_modint<mod>

    let n = a.count;
//    int h = internal::countr_zero((unsigned int)n);
    let h: CInt = _Internal.countr_zero(CUnsignedInt(n))

//    static const fft_info<mint> info;
    let info = fft_info<mod>()
    // Swiftの制限でC++のstatic constに該当するものをgeneric型では使うことができない。
    // Swift5.9でのプロファイルでは今のところ性能上、目立った実行時間にはなっていない。(ABC331-Gの重たい問題でも18ms程度)
    // 手元のOSではSwift5.8.1が動かせず、ジャッジ環境で実際にどのくらいの影響があるのかは不明。
    
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
                    { rot *= info.rate2[_Internal.countr_zero(~CUnsignedInt(s))]; }
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
                    let mod2: ULL = 1 * ULL(mint.mod) * ULL(mint.mod);
                    let a0: ULL = 1 * ULL(a[i + offset].val);
                    let a1: ULL = 1 * ULL(a[i + offset + p].val) * ULL(rot.val);
                    let a2: ULL = 1 * ULL(a[i + offset + 2 * p].val) * ULL(rot2.val);
                    let a3: ULL = 1 * ULL(a[i + offset + 3 * p].val) * ULL(rot3.val);
                    let a1na3imag =
                    1 * ULL(mint(a1 + mod2 - a3).val) * ULL(imag.val);
                    let na2 = mod2 - a2;
                    a[i + offset] = mint(a0 + a2 + a1 + a3);
                    a[i + offset + 1 * p] = mint(a0 + a2 + (2 * mod2 - (a1 + a3)));
                    a[i + offset + 2 * p] = mint(a0 + na2 + a1na3imag);
                    a[i + offset + 3 * p] = mint(a0 + na2 + (mod2 - a1na3imag));
                }
                if (s + 1 != (1 << len))
                    { rot *= info.rate3[_Internal.countr_zero(~(CUnsignedInt(s)))]; }
            }
            len += 2;
        }
    }
}

//template <class mint, internal::is_static_modint_t<mint>* = nullptr>
static func butterfly_inv<mod: static_mod>(_ a: UnsafeMutableBufferPointer<static_modint<mod>>) {
    typealias mint = static_modint<mod>
    let n = a.count;
    let h: CInt = _Internal.countr_zero(CUnsignedInt(n));

//    static const fft_info<mint> info;
    let info = fft_info<mod>()

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
                        (ULL(mint.mod) + ULL(l.val) - ULL(r.val)) *
                    ULL(irot.val));
                }
                if (s + 1 != (1 << (len - 1)))
                    { irot *= info.irate2[_Internal.countr_zero(~CUnsignedInt(s))]; }
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
                    let a0: ULL = 1 * ULL(a[i + offset + 0 * p].val);
                    let a1: ULL = 1 * ULL(a[i + offset + 1 * p].val);
                    let a2: ULL = 1 * ULL(a[i + offset + 2 * p].val);
                    let a3: ULL = 1 * ULL(a[i + offset + 3 * p].val);

                    let a2na3iimag: ULL =
                        1 *
                    ULL(mint((ULL(mint.mod) + a2 - a3) * ULL(iimag.val)).val);
                    a[i + offset] = mint(a0 + a1 + a2 + a3);
                    a[i + offset + 1 * p] =
                    mint((a0 + (ULL(mint.mod) - a1) + a2na3iimag) * ULL(irot.val));
                    a[i + offset + 2 * p] =
                    mint((a0 + a1 + (ULL(mint.mod) - a2) + (ULL(mint.mod) - a3)) *
                        ULL(irot2.val));
                    a[i + offset + 3 * p] =
                    mint((a0 + (ULL(mint.mod) - a1) + (ULL(mint.mod) - a2na3iimag)) *
                        ULL(irot3.val));
                }
                if (s + 1 != (1 << (len - 2)))
                    { irot *= info.irate3[_Internal.countr_zero(~(CUnsignedInt(s)))]; }
            }
            len -= 2;
        }
    }
}

}
#endif
