import Foundation

extension _Internal {

  @usableFromInline
  struct fft_info<mod: static_mod> {

    @usableFromInline
    typealias mint = static_modint<mod>

    @usableFromInline
    var root, iroot: [mint]
    @usableFromInline
    var rate2, irate2: [mint]
    @usableFromInline
    var rate3, irate3: [mint]

    @inlinable @inline(__always)
    init(root: [mint], iroot: [mint], rate2: [mint], irate2: [mint], rate3: [mint], irate3: [mint])
    {
      self.root = root
      self.iroot = iroot
      self.rate2 = rate2
      self.irate2 = irate2
      self.rate3 = rate3
      self.irate3 = irate3
    }

    @inlinable
    public init() {

      let g: Int = _Internal.primitive_root(mint.mod)
      let rank2: Int = (mint.mod - 1).trailingZeroBitCount

      root = [mint](repeating: 0, count: rank2 + 1)  // root[i]^(2^i) == 1
      iroot = [mint](repeating: 0, count: rank2 + 1)  // root[i] * iroot[i] == 1

      rate2 = [mint](repeating: 0, count: max(0, rank2 - 2 + 1))
      irate2 = [mint](repeating: 0, count: max(0, rank2 - 2 + 1))

      rate3 = [mint](repeating: 0, count: max(0, rank2 - 3 + 1))
      irate3 = [mint](repeating: 0, count: max(0, rank2 - 3 + 1))

      root[rank2] = mint(g).pow(CLongLong((mint.mod - 1) >> rank2))
      iroot[rank2] = root[rank2].inv

      root.withUnsafeMutableBufferPointer { root in
        iroot.withUnsafeMutableBufferPointer { iroot in

          // for (int i = rank2 - 1; i >= 0; i--) {
          for i in stride(from: Int(rank2 - 1), through: 0, by: -1) {
            root[i] = root[i + 1] * root[i + 1]
            iroot[i] = iroot[i + 1] * iroot[i + 1]
          }

          do {
            var prod: mint = 1
            var iprod: mint = 1
            // for (int i = 0; i <= rank2 - 2; i++) {
            for i in stride(from: 0, through: rank2 - 2, by: 1) {
              rate2[i] = root[i + 2] * prod
              irate2[i] = iroot[i + 2] * iprod
              prod *= iroot[i + 2]
              iprod *= root[i + 2]
            }
          }

          do {
            var prod: mint = 1
            var iprod: mint = 1
            // for (int i = 0; i <= rank2 - 3; i++) {
            for i in stride(from: 0, through: rank2 - 3, by: 1) {
              rate3[i] = root[i + 3] * prod
              irate3[i] = iroot[i + 3] * iprod
              prod *= iroot[i + 3]
              iprod *= root[i + 3]
            }
          }
        }
      }
    }

    @usableFromInline
    struct __Unsafe {
      @usableFromInline typealias Pointer = UnsafePointer<mint>
      @inlinable @inline(__always)
      init(
        root: Pointer, iroot: Pointer, rate2: Pointer, irate2: Pointer, rate3: Pointer,
        irate3: Pointer
      ) {
        (
          self.root, self.iroot,
          self.rate2, self.irate2,
          self.rate3, self.irate3
        ) = (
          root, iroot,
          rate2, irate2,
          rate3, irate3
        )
      }

      @usableFromInline let root, iroot, rate2, irate2, rate3, irate3: Pointer
    }

    @inlinable
    func _unsafe(_ f: (__Unsafe) -> Void) {
      f(
        __Unsafe(
          root: root, iroot: iroot,
          rate2: rate2, irate2: irate2,
          rate3: rate3, irate3: irate3))
    }
  }

  @inline(never)
  @inlinable
  static func butterfly<mod: static_mod>(
    _ a: UnsafeMutablePointer<static_modint<mod>>, _ count: Int
  ) {
    typealias mint = static_modint<mod>
    let info = __static_const_fft_info.info(mod.self)

    info._unsafe { info in

      let h: Int = min(32, count.trailingZeroBitCount)
      let umod = mod.umod
      var len: Int = 0  // a[i, i+(n>>len), i+2*(n>>len), ..] is transformed

      while len < h {
        if h &- len == 1 {
          let p = 1 << (h &- len &- 1)
          var rot: mint = 1
          for s in 0..<1 << len {
            let offset = s << (h &- len)
            for i in 0..<p {
              let l = a[i &+ offset]
              let r = a[i &+ offset &+ p] * rot
              a[i &+ offset] = l + r
              a[i &+ offset &+ p] = l - r
            }
            if s &+ 1 != 1 << len {
              rot *= info.rate2[min(32, (~s).trailingZeroBitCount)]
            }
          }
          len &+= 1
        } else {
          // 4-base
          let p = 1 << (h &- len &- 2)
          var rot: mint = 1
          let imag = info.root[2]
          for s in 0..<1 << len {
            let rot2 = rot * rot
            let rot3 = rot2 * rot
            let offset = s << (h &- len)
            for i in 0..<p {
              let mod2: UInt = umod &* umod
              let a0: UInt = a[i &+ offset].value
              let a1: UInt = a[i &+ offset &+ p].value &* rot.value
              let a2: UInt = a[i &+ offset &+ 2 &* p].value &* rot2.value
              let a3: UInt = a[i &+ offset &+ 3 &* p].value &* rot3.value
              let a1na3imag: UInt = 1 &* mint(UInt: a1 &+ mod2 &- a3).value &* imag.value
              let na2: UInt = mod2 &- a2
              a[i &+ offset] = mint(UInt: a0 &+ a2 &+ a1 &+ a3)
              a[i &+ offset &+ p] = mint(UInt: a0 &+ a2 &+ (2 * mod2 &- (a1 &+ a3)))
              a[i &+ offset &+ 2 &* p] = mint(UInt: a0 &+ na2 &+ a1na3imag)
              a[i &+ offset &+ 3 &* p] = mint(UInt: a0 &+ na2 &+ (mod2 &- a1na3imag))
            }
            if s &+ 1 != 1 << len {
              rot *= info.rate3[min(32, (~s).trailingZeroBitCount)]
            }
          }
          len &+= 2
        }
      }
    }
  }

  @inline(never)
  @inlinable
  static func butterfly_inv<mod: static_mod>(
    _ a: UnsafeMutablePointer<static_modint<mod>>, _ count: Int
  ) {
    typealias mint = static_modint<mod>
    let info = __static_const_fft_info.info(mod.self)

    info._unsafe { info in

      let h: Int = min(32, count.trailingZeroBitCount)
      let umod = mod.umod
      var len = h  // a[i, i+(n>>len), i+2*(n>>len), ..] is transformed

      while len != 0 {
        if len == 1 {
          let p = 1 << (h &- len)
          var irot: mint = 1
          for s in 0..<1 << (len &- 1) {
            let offset = s << (h &- len &+ 1)
            for i in 0..<p {
              let l = a[i &+ offset]
              let r = a[i &+ offset &+ p]
              a[i &+ offset] = l + r
              a[i &+ offset &+ p] = mint(
                UInt: (l.value &- r.value &+ umod)
                  &* irot.value)
            }
            if s &+ 1 != 1 << (len &- 1) {
              irot *= info.irate2[min(32, (~s).trailingZeroBitCount)]
            }
          }
          len &-= 1
        } else {
          // 4-base
          let p = 1 << (h &- len)
          var irot: mint = 1
          let iimag = info.iroot[2]
          for s in 0..<1 << (len &- 2) {
            let irot2 = irot * irot
            let irot3 = irot2 * irot
            let offset = s << (h &- len &+ 2)
            for i in 0..<p {
              let a0: UInt = a[i &+ offset].value
              let a1: UInt = a[i &+ offset &+ p].value
              let a2: UInt = a[i &+ offset &+ 2 &* p].value
              let a3: UInt = a[i &+ offset &+ 3 &* p].value
              let a2na3iimag: UInt = mint(UInt: (umod &+ a2 &- a3) &* iimag.value).value
              a[i &+ offset] = mint(UInt: a0 &+ a1 &+ a2 &+ a3)
              a[i &+ offset &+ p] = mint(UInt: (a0 &+ (umod &- a1) &+ a2na3iimag) &* irot.value)
              a[i &+ offset &+ 2 &* p] = mint(
                UInt: (a0 &+ a1 &+ (umod &- a2) &+ (umod &- a3)) &* irot2.value)
              a[i &+ offset &+ 3 &* p] = mint(
                UInt: (a0 &+ (umod &- a1) &+ (umod &- a2na3iimag)) &* irot3.value)
            }
            if s &+ 1 != 1 << (len &- 2) {
              irot *= info.irate3[min(32, (~s).trailingZeroBitCount)]
            }
          }
          len &-= 2
        }
      }
    }
  }

  @inline(never)
  @inlinable
  static func convolution_naive<mod: static_mod>(
    _ a: UnsafeBufferPointer<static_modint<mod>>,
    _ b: UnsafeBufferPointer<static_modint<mod>>
  ) -> [static_modint<mod>] {
    let n = a.count
    let m = b.count
    return .init(unsafeUninitializedCapacity: n + m - 1) {
      ans, initializedCount in
      ans.initialize(repeating: .init())
      if n < m {
        for j in 0..<m {
          for i in 0..<n {
            ans[i &+ j] += a[i] * b[j]
          }
        }
      } else {
        for i in 0..<n {
          for j in 0..<m {
            ans[i &+ j] += a[i] * b[j]
          }
        }
      }
      initializedCount = n &+ m &- 1
    }
  }

  @inline(never)
  @inlinable
  static func convolution_fft<mod: static_mod>(
    _ _a: UnsafeBufferPointer<static_modint<mod>>,
    _ _b: UnsafeBufferPointer<static_modint<mod>>
  ) -> [static_modint<mod>] {

    let (n, m) = (_a.count, _b.count)
    let z: Int = _Internal.bit_ceil(n + m - 1)
    let size = n &+ m &- 1

    return .init(unsafeUninitializedCapacity: max(z, size)) { a, initializedCount in
      withUnsafeTemporaryAllocation(of: static_modint<mod>.self, capacity: z) { b in

        _ = a.initialize(from: _a)
        _ = b.initialize(from: _b)

        if z > n {
          (a.baseAddress! + n).initialize(repeating: .zero, count: max(z, size) - n)
        }
        if z > m {
          (b.baseAddress! + m).initialize(repeating: .zero, count: z - m)
        }

        butterfly(a.baseAddress!, z)
        butterfly(b.baseAddress!, z)
        for i in 0..<z {
          a[i] *= b[i]
        }
        butterfly_inv(a.baseAddress!, z)
        // resize(size)
        let iz = static_modint<mod>(z).inv
        for i in 0..<size { a[i] *= iz }

        initializedCount = size
      }
    }
  }
}  // _Internal

@inlinable
public func convolution<mod: static_mod>(
  _ a: UnsafeBufferPointer<static_modint<mod>>,
  _ b: UnsafeBufferPointer<static_modint<mod>>
) -> [static_modint<mod>] {
  let (n, m) = (a.count, b.count)
  if n == 0 || m == 0 { return [] }
  //  let z: CInt = _Internal.bit_ceil(n + m - 1)
  assert((static_modint<mod>.mod - 1) % _Internal.bit_ceil(n + m - 1) == 0)
  if min(n, m) <= 60 {
    return _Internal.convolution_naive(a, b)
  }
  return _Internal.convolution_fft(a, b)
}

@inlinable
public func convolution<mod: static_mod, A, B>(_ a: A, _ b: B) -> [static_modint<mod>]
where
  A: Sequence, A.Element == static_modint<mod>,
  B: Sequence, B.Element == static_modint<mod>
{
  let result =
  a.withContiguousStorageIfAvailable { a in
    b.withContiguousStorageIfAvailable { b in
      return convolution(a, b)
    }
  }.flatMap{ $0 }
  
  if let result {
    return result
  }
  
  return ArraySlice(a).withUnsafeBufferPointer { a in
    ArraySlice(b).withUnsafeBufferPointer { b in
      return convolution(a, b)
    }
  }
}

@inlinable
public func convolution<mod: static_mod, T: FixedWidthInteger>(_ t: mod.Type, _ a: [T], _ b: [T])
  -> [T]
{

  let n = a.count
  let m = b.count
  if n == 0 || m == 0 { return [] }

  typealias mint = static_modint<mod>

  let z: Int = _Internal.bit_ceil(n + m - 1)
  assert((Int(mint.mod) - 1) % z == 0)

  var a2 = [mint](repeating: 0, count: n)
  var b2 = [mint](repeating: 0, count: m)
  for i in 0..<n {
    a2[i] = mint(a[i])
  }
  for i in 0..<m {
    b2[i] = mint(b[i])
  }
  let c2 = convolution(a2, b2)
  var c = [T](repeating: 0, count: n + m - 1)
  for i in 0..<(n + m - 1) {
    c[i] = T(c2[i].val)
  }
  return c
}

@available(*, deprecated, message: "mod_998_244_353を意図してない場合、convolution<,>(_:,_:,_:)を使うこと")
@inlinable
public func convolution<T: FixedWidthInteger>(_ a: [T], _ b: [T]) -> [T] {
  convolution(mod_998_244_353.self, a, b)
}

public func convolution_ll(
  _ a: [Int],
  _ b: [Int]
) -> [Int] {
  let n = a.count
  let m = b.count
  if n == 0 || m == 0 { return [] }

  enum const {
    static let MOD1: UInt = 754_974_721  // 2^24
    static let MOD2: UInt = 167_772_161  // 2^25
    static let MOD3: UInt = 469_762_049  // 2^26
    static let M2M3: UInt = MOD2 &* MOD3
    static let M1M3: UInt = MOD1 &* MOD3
    static let M1M2: UInt = MOD1 &* MOD2
    static let M1M2M3: UInt = MOD1 &* MOD2 &* MOD3
    enum mod1: static_mod {
      static let umod = MOD1
      static let isPrime: Bool = false
    }
    enum mod2: static_mod {
      static let umod = MOD2
      static let isPrime: Bool = false
    }
    enum mod3: static_mod {
      static let umod = MOD3
      static let isPrime: Bool = false
    }
    static let i1 = UInt(_Internal.inv_gcd(Int(MOD2) * Int(MOD3), Int(MOD1)).second)
    static let i2 = UInt(_Internal.inv_gcd(Int(MOD1) * Int(MOD3), Int(MOD2)).second)
    static let i3 = UInt(_Internal.inv_gcd(Int(MOD1) * Int(MOD2), Int(MOD3)).second)
  }

  typealias mod1 = const.mod1
  typealias mod2 = const.mod2
  typealias mod3 = const.mod3

  let MOD1: UInt = const.MOD1
  let MOD2: UInt = const.MOD2
  let MOD3: UInt = const.MOD3
  let M2M3: UInt = const.M2M3
  let M1M3: UInt = const.M1M3
  let M1M2: UInt = const.M1M2
  let M1M2M3: UInt = const.M1M2M3

  let i1: UInt = const.i1
  let i2: UInt = const.i2
  let i3: UInt = const.i3

  let MAX_AB_BIT: UInt = 24
  assert(MOD1 % (1 << MAX_AB_BIT) == 1, "MOD1 isn't enough to support an array length of 2^24.")
  assert(MOD2 % (1 << MAX_AB_BIT) == 1, "MOD2 isn't enough to support an array length of 2^24.")
  assert(MOD3 % (1 << MAX_AB_BIT) == 1, "MOD3 isn't enough to support an array length of 2^24.")
  assert(n + m - 1 <= (1 << MAX_AB_BIT))

  let c1 = convolution(mod1.self, a, b)
  let c2 = convolution(mod2.self, a, b)
  let c3 = convolution(mod3.self, a, b)

  var c = [Int](repeating: 0, count: n + m - 1)
  for i in 0..<(n + m - 1) {
    var x: UInt = 0
    x &+= (UInt(bitPattern: c1[i]) * i1) % MOD1 &* M2M3
    x &+= (UInt(bitPattern: c2[i]) * i2) % MOD2 &* M1M3
    x &+= (UInt(bitPattern: c3[i]) * i3) % MOD3 &* M1M2
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
    var diff: Int =
      c1[i] - _Internal.safe_mod(Int(bitPattern: x), Int(bitPattern: MOD1))
    if diff < 0 { diff += Int(bitPattern: MOD1) }
    let offset: [UInt] = [
      0, 0, M1M2M3, 2 * M1M2M3, 3 * M1M2M3,
    ]
    x &-= offset[diff % 5]
    c[i] = Int(bitPattern: x)
  }

  return c
}
