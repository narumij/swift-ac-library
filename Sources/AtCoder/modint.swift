import Foundation

public protocol static_modint_base: modint_base & modint_raw {
    init(unsigned v: CUnsignedLongLong)
}

public protocol dynamic_modint_base: modint_base & modint_raw {
    static func set_mod(_ m: CInt)
}

public struct static_modint<m: static_mod>: static_modint_base {
    public init(raw v: CUnsignedInt) {
        _v = v
    }
    public var _v: CUnsignedInt
}

public extension static_modint {
    
    @inlinable @inline(__always)
    static func mod() -> CInt { return CInt(bitPattern: m.umod) }

    init() { self.init(raw: 0) }
    init(_ v: Bool) { _v = ___modint_v(v ? 1 : 0, mod: __modint_mod(m.umod)) }
    init(_ v: CInt) { _v = ___modint_v(v, mod: __modint_mod(m.umod)) }
    init(unsigned v: CUnsignedLongLong) { _v = __modint_v(v, umod: __modint_umod(m.umod)) }
    init<T: BinaryInteger>(_ v: T) { _v = ___modint_v(v, mod: __modint_mod(m.umod)) }

    func val() -> CUnsignedInt { return _v }
    
    static func +=(lhs: inout Self, rhs: Self) {
        lhs._v &+= rhs._v
        if lhs._v >= umod() { lhs._v &-= umod() }
    }
    static func -=(lhs: inout Self, rhs: Self) {
        lhs._v &-= rhs._v
        if lhs._v >= umod() { lhs._v &+= umod() }
   }
    static func *=(lhs: inout Self, rhs: Self) {
        var z: ULL = ULL(lhs._v)
        z &*= ULL(rhs._v)
        lhs._v = UINT(z % ULL(umod()))
    }
    static func /=(lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs.inv()
    }
    static prefix func + (_ m: Self) -> Self {
        return m
    }
    static prefix func - (_ m: Self) -> Self {
        return .init(raw: 0) - m
    }
    static func + (lhs: Self, rhs: Self) -> Self {
        var _v = lhs._v &+ rhs._v
        if _v >= umod() { _v &-= umod() }
        return .init(raw:_v)
    }
    static func - (lhs: Self, rhs: Self) -> Self {
        var _v = lhs._v &- rhs._v
        if _v >= umod() { _v &+= umod() }
        return .init(raw:_v)
    }
    static func * (lhs: Self, rhs: Self) -> Self {
        var z: ULL = ULL(lhs._v)
        z &*= ULL(rhs._v)
        return .init(raw: UINT(z % ULL(umod())))
    }
    static func / (lhs: Self, rhs: Self) -> Self {
        lhs * rhs.inv()
    }
    
    func pow<LL: SignedInteger>(_ n: LL) -> Self {
        pow(CLongLong(n))
    }
    
    func pow(_ n: CLongLong) -> Self {
        assert(0 <= n)
        var n = n
        var x = self, r: Self = .init(raw: 1)
        while n != 0 {
            if (n & 1) != 0 { r *= x }
            x *= x
            n >>= 1
        }
        return r
    }
    
    func inv() -> Self {
        if isPrime {
            assert(_v != 0)
            return pow(LL(Self.umod()) - 2)
        } else {
            let eg = _Internal.inv_gcd(LL(_v), LL(m.m))
            assert(eg.first == 1)
            return Self.init(CInt(eg.second))
        }
    }
    
    @inlinable @inline(__always)
    static func umod() -> CUnsignedInt { m.umod }
    
    @inlinable @inline(__always)
    var isPrime: Bool { m.isPrime }
}


public struct dynamic_modint<bt: dynamic_mod>: dynamic_modint_base {
//    public typealias bt = bt
    public init(raw v: CUnsignedInt) {
        _v = v
    }
    public var _v: CUnsignedInt
    public static func set_mod(_ m: CInt) {
        bt.set_mod(m)
    }
}

extension dynamic_modint {

    @inlinable @inline(__always)
    public static func mod() -> CInt { return CInt(bitPattern: bt.umod); }

    public init() { self.init(raw: 0) }
    public init(_ v: Bool) { _v = ___modint_v(v ? 1 : 0, mod: __modint_mod(bt.umod)) }
    public init(_ v: CInt) { _v = ___modint_v(v, mod: __modint_mod(bt.umod)) }
    public init<T: BinaryInteger>(_ v: T) { _v = ___modint_v(v, mod: __modint_mod(bt.umod))  }

    public func val() -> CUnsignedInt { return _v; }
    
    public static func +=(lhs: inout Self, rhs: Self) {
        lhs._v &+= rhs._v
        if lhs._v >= umod() { lhs._v &-= umod() }
    }
    public static func -=(lhs: inout Self, rhs: Self) {
        lhs._v &+= umod() &- rhs._v
        if lhs._v >= umod() { lhs._v &-= umod() }
   }
    public static func *=(lhs: inout Self, rhs: Self) {
        lhs._v = bt.mul(lhs._v, rhs._v)
    }
    public static func /=(lhs: inout Self, rhs: Self) {
        lhs *= rhs.inv()
    }
    public static prefix func + (_ m: Self) -> Self {
        return m
    }
    public static prefix func - (_ m: Self) -> Self {
        return .init(raw: 0) - m
    }
    public static func + (lhs: Self, rhs: Self) -> Self {
        var _v = lhs._v &+ rhs._v
        if _v >= umod() { _v &-= umod() }
        return .init(raw:_v)
    }
    public static func - (lhs: Self, rhs: Self) -> Self {
        var _v = lhs._v &+ umod() &- rhs._v
        if _v >= umod() { _v &-= umod() }
        return .init(raw:_v)
    }
    public static func * (lhs: Self, rhs: Self) -> Self {
        let _v = bt.mul(lhs._v, rhs._v)
        return .init(raw:_v)
    }
    public static func / (lhs: Self, rhs: Self) -> Self {
        lhs * rhs.inv()
    }

    public func pow<LL: SignedInteger>(_ n: LL) -> Self {
        pow(CLongLong(n))
    }
    
    public func pow(_ n: CLongLong) -> Self {
        assert(0 <= n)
        var n = n
        var x = self, r: Self = .init(raw: 1)
        while n != 0 {
            if (n & 1) != 0 { r *= x }
            x *= x
            n >>= 1
        }
        return r
    }
    
    public func inv() -> Self {
        let eg = _Internal.inv_gcd(LL(_v), LL(Self.mod()))
        assert(eg.first == 1)
        return .init(CInt(eg.second))
    }
    
    @inlinable @inline(__always)
    public static func umod() -> CUnsignedInt { return bt.umod }
}

public typealias modint998244353 = static_modint<mod_998_244_353>
public typealias modint1000000007 = static_modint<mod_1_000_000_007>

public typealias modint = dynamic_modint<mod_dynamic>

