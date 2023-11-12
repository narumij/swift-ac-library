import Foundation

protocol modint_base { }
protocol static_modint_base: modint_base { }

typealias modint = dynamic_modint;

/*
#ifndef ATCODER_MODINT_HPP
#define ATCODER_MODINT_HPP 1

#include <cassert>
#include <numeric>
#include <type_traits>

#ifdef _MSC_VER
#include <intrin.h>
#endif

#include "atcoder/internal_math"
#include "atcoder/internal_type_traits"

namespace atcoder {

namespace internal {

struct modint_base {};
struct static_modint_base : modint_base {};

template <class T> using is_modint = std::is_base_of<modint_base, T>;
template <class T> using is_modint_t = std::enable_if_t<is_modint<T>::value>;

}  // namespace internal

template <int m, std::enable_if_t<(1 <= m)>* = nullptr>
struct static_modint : internal::static_modint_base {
    using mint = static_modint;

  public:
    static constexpr int mod() { return m; }
    static mint raw(int v) {
        mint x;
        x._v = v;
        return x;
    }

    static_modint() : _v(0) {}
    template <class T, internal::is_signed_int_t<T>* = nullptr>
    static_modint(T v) {
        long long x = (long long)(v % (long long)(umod()));
        if (x < 0) x += umod();
        _v = (unsigned int)(x);
    }
    template <class T, internal::is_unsigned_int_t<T>* = nullptr>
    static_modint(T v) {
        _v = (unsigned int)(v % umod());
    }

    unsigned int val() const { return _v; }

    mint& operator++() {
        _v++;
        if (_v == umod()) _v = 0;
        return *this;
    }
    mint& operator--() {
        if (_v == 0) _v = umod();
        _v--;
        return *this;
    }
    mint operator++(int) {
        mint result = *this;
        ++*this;
        return result;
    }
    mint operator--(int) {
        mint result = *this;
        --*this;
        return result;
    }

    mint& operator+=(const mint& rhs) {
        _v += rhs._v;
        if (_v >= umod()) _v -= umod();
        return *this;
    }
    mint& operator-=(const mint& rhs) {
        _v -= rhs._v;
        if (_v >= umod()) _v += umod();
        return *this;
    }
    mint& operator*=(const mint& rhs) {
        unsigned long long z = _v;
        z *= rhs._v;
        _v = (unsigned int)(z % umod());
        return *this;
    }
    mint& operator/=(const mint& rhs) { return *this = *this * rhs.inv(); }

    mint operator+() const { return *this; }
    mint operator-() const { return mint() - *this; }

    mint pow(long long n) const {
        assert(0 <= n);
        mint x = *this, r = 1;
        while (n) {
            if (n & 1) r *= x;
            x *= x;
            n >>= 1;
        }
        return r;
    }
    mint inv() const {
        if (prime) {
            assert(_v);
            return pow(umod() - 2);
        } else {
            auto eg = internal::inv_gcd(_v, m);
            assert(eg.first == 1);
            return eg.second;
        }
    }

    friend mint operator+(const mint& lhs, const mint& rhs) {
        return mint(lhs) += rhs;
    }
    friend mint operator-(const mint& lhs, const mint& rhs) {
        return mint(lhs) -= rhs;
    }
    friend mint operator*(const mint& lhs, const mint& rhs) {
        return mint(lhs) *= rhs;
    }
    friend mint operator/(const mint& lhs, const mint& rhs) {
        return mint(lhs) /= rhs;
    }
    friend bool operator==(const mint& lhs, const mint& rhs) {
        return lhs._v == rhs._v;
    }
    friend bool operator!=(const mint& lhs, const mint& rhs) {
        return lhs._v != rhs._v;
    }

  private:
    unsigned int _v;
    static constexpr unsigned int umod() { return m; }
    static constexpr bool prime = internal::is_prime<m>;
};
*/

protocol modint_protocol: modint_base, AdditiveArithmetic, Equatable, ExpressibleByIntegerLiteral {
    static func mod() -> CInt
    static func set_mod(_ m: CInt)
    static func raw(_ v: CInt) -> mint
    init()
    init(_ v: Int)
    init(_ v: CInt)
    init(_ v: CLongLong)
    init(_ v: CUnsignedInt)
    init(_ v: CUnsignedLongLong)
    init<T: FixedWidthInteger>(_ v: T)
    func val() -> CUnsignedInt
    static func +(lhs: mint, rhs: mint) -> mint
    static func -(lhs: mint, rhs: mint) -> mint
    static func *(lhs: mint, rhs: mint) -> mint
    static func /(lhs: mint, rhs: mint) -> mint
    static func +=(lhs: inout mint, rhs: mint)
    static func -=(lhs: inout mint, rhs: mint)
    static func *=(lhs: inout mint, rhs: mint)
    static func /=(lhs: inout mint, rhs: mint)
    func pow(_ n: CLongLong) -> mint
    func inv() -> mint
}

extension modint_protocol {
    typealias mint = Self
    static var zero: Self { .init() }
}

extension dynamic_modint: ExpressibleByIntegerLiteral {
    init(integerLiteral value: CInt) {
        self.init(value)
    }
}

struct dynamic_modint: modint_protocol {
//  public:
    static func mod() -> CInt { return CInt(bitPattern: bt.umod()); }
    static func set_mod(_ m: CInt) {
        assert(1 <= m);
        bt = `internal`.barrett(CUnsignedInt(m));
    }
    static func raw(_ v: CInt) -> mint {
        var x = mint();
        x._v = CUnsignedInt(bitPattern: v);
        return x;
    }

    init() { _v = 0 }

    init(_ v: Bool) { self.init(CInt(v ? 1 : 0)) }
    init(_ v: CInt) {
        var x = v % Self.mod();
        if (x < 0) { x += Self.mod(); }
        _v = CUnsignedInt(x);
    }
    init(_ v: CLongLong) {
        var x = v % CLongLong(Self.mod());
        if (x < 0) { x += CLongLong(Self.mod()); }
        _v = CUnsignedInt(x);
    }
    init(_ v: Int) {
        self.init(CInt(v))
    }
    init(_ v: CUnsignedInt) {
        _v = v % CUnsignedInt(Self.mod());
    }
    init(_ v: CUnsignedLongLong) {
        _v = CUnsignedInt(v % CUnsignedLongLong(Self.mod()));
    }
    init<T: FixedWidthInteger>(_ v: T) {
        fatalError("未実装")
    }

    func val() -> CUnsignedInt { return _v; }
    /*
    mint& operator++() {
        _v++;
        if (_v == umod()) _v = 0;
        return *this;
    }
    mint& operator--() {
        if (_v == 0) _v = umod();
        _v--;
        return *this;
    }
    mint operator++(int) {
        mint result = *this;
        ++*this;
        return result;
    }
    mint operator--(int) {
        mint result = *this;
        --*this;
        return result;
    }

    mint& operator+=(const mint& rhs) {
        _v += rhs._v;
        if (_v >= umod()) _v -= umod();
        return *this;
    }
    mint& operator-=(const mint& rhs) {
        _v += mod() - rhs._v;
        if (_v >= umod()) _v -= umod();
        return *this;
    }
    mint& operator*=(const mint& rhs) {
        _v = bt.mul(_v, rhs._v);
        return *this;
    }
    mint& operator/=(const mint& rhs) { return *this = *this * rhs.inv(); }

    mint operator+() const { return *this; }
    mint operator-() const { return mint() - *this; }
*/
    
    static func + (lhs: mint, rhs: mint) -> mint {
        var _v = lhs._v &+ rhs._v
        if (_v >= umod()) { _v -= umod(); }
        return Self.raw(CInt(bitPattern: _v))
    }
    static func - (lhs: mint, rhs: mint) -> mint {
        var _v = lhs._v &+ CUnsignedInt(bitPattern: mod()) &- rhs._v
        if (_v >= umod()) { _v -= umod(); }
        return Self.raw(CInt(bitPattern: _v))
    }
    static func * (lhs: mint, rhs: mint) -> mint {
        let _v = bt.mul(lhs._v, rhs._v);
        return Self.raw(CInt(bitPattern: _v))
    }
    static func / (lhs: mint, rhs: mint) -> mint {
        lhs * rhs.inv()
    }
    static func +=(lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    static func -=(lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
   }
    static func *=(lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    static func /=(lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    static prefix func + (_ m: Self) -> Self {
        return m
    }
    static prefix func - (_ m: Self) -> Self {
        return Self() - m
    }

    func pow(_ n: CLongLong) -> mint {
        assert(0 <= n);
        var n = n
        var x = self, r: Self = Self.init(CInt(1));
        while ((n) != 0) {
            if ((n & 1) != 0) { r *= x; }
            x *= x;
            n >>= 1;
        }
        return r;
    }
    func inv() -> mint {
        let eg = `internal`.inv_gcd(CLongLong(_v), CLongLong(Self.mod()));
        assert(eg.first == 1);
        return Self.init(CInt(eg.second));
    }
    
/*
    friend mint operator+(const mint& lhs, const mint& rhs) {
        return mint(lhs) += rhs;
    }
    friend mint operator-(const mint& lhs, const mint& rhs) {
        return mint(lhs) -= rhs;
    }
    friend mint operator*(const mint& lhs, const mint& rhs) {
        return mint(lhs) *= rhs;
    }
    friend mint operator/(const mint& lhs, const mint& rhs) {
        return mint(lhs) /= rhs;
    }
    friend bool operator==(const mint& lhs, const mint& rhs) {
        return lhs._v == rhs._v;
    }
    friend bool operator!=(const mint& lhs, const mint& rhs) {
        return lhs._v != rhs._v;
    }
     */
    
//  private:
    var _v: CUnsignedInt;
    static var bt: `internal`.barrett = .init(CUnsignedInt.max);
    static func umod() -> CUnsignedInt { return bt.umod(); }
};
/*
template <int id> internal::barrett dynamic_modint<id>::bt(998244353);

using modint998244353 = static_modint<998244353>;
using modint1000000007 = static_modint<1000000007>;
using modint = dynamic_modint<-1>;

namespace internal {

template <class T>
using is_static_modint = std::is_base_of<internal::static_modint_base, T>;

template <class T>
using is_static_modint_t = std::enable_if_t<is_static_modint<T>::value>;

template <class> struct is_dynamic_modint : public std::false_type {};
template <int id>
struct is_dynamic_modint<dynamic_modint<id>> : public std::true_type {};

template <class T>
using is_dynamic_modint_t = std::enable_if_t<is_dynamic_modint<T>::value>;

}  // namespace internal

}  // namespace atcoder

#endif  // ATCODER_MODINT_HPP
*/
