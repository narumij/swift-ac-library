import Foundation

extension _Internal {

  @inlinable
  static func sa_naive<Element>(_ s: UnsafeBufferPointer<Element>) -> [Int]
  where Element: BinaryInteger {
    let n = s.count
    return (0..<n)
      .sorted { l, r in
        if l == r { return false }
        var (l, r) = (l, r)
        while l < n, r < n {
          if s[l] != s[r] { return s[l] < s[r] }
          l += 1
          r += 1
        }
        return l == n
      }
  }

  @inlinable
  static func sa_doubling<Element>(_ s: UnsafeBufferPointer<Element>) -> [Int]
  where Element: BinaryInteger {
    let n = s.count
    var sa = (0..<n) + []

    var rnk = UnsafeMutablePointer<Element>.allocate(capacity: n)
    var tmp = UnsafeMutablePointer<Element>.allocate(capacity: n)
    rnk.initialize(from: s.baseAddress!, count: n)
    tmp.initialize(repeating: 0, count: n)
    
    defer {
      rnk.deinitialize(count: n)
      tmp.deinitialize(count: n)
      rnk.deallocate()
      tmp.deallocate()
    }

    for k in sequence(first: 1, next: { $0 < n ? $0 * 2 : nil }) {

      func cmp(_ x: Int, _ y: Int) -> Bool {
        if rnk[x] != rnk[y] { return rnk[x] < rnk[y] }
        let rx = x + k < n ? rnk[x + k] : -1
        let ry = y + k < n ? rnk[y + k] : -1
        return rx < ry
      }

      sa.sort(by: cmp)
      tmp[sa[0]] = 0

      for i in 1..<n {
        tmp[sa[i]] = tmp[sa[i - 1]] + (cmp(sa[i - 1], sa[i]) ? 1 : 0)
      }
      swap(&tmp, &rnk)
    }

    return sa
  }

  /// SA-IS, linear-time suffix array construction
  /// Reference:
  /// G. Nong, S. Zhang, and W. H. Chan,
  /// Two Efficient Algorithms for Linear Time Suffix Array Construction
  @inlinable
  static func sa_is<Element>(
    _ s: UnsafeBufferPointer<Element>, _ upper: Int, _ THRESHOLD_NAIVE: Int = 10,
    _ THRESHOLD_DOUBLING: Int = 40
  ) -> [Int] where Element: BinaryInteger {
    let n = s.count
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
      return sa_naive(s)
    }
    if n < THRESHOLD_DOUBLING {
      return sa_doubling(s)
    }

    func index(_ i: Element) -> Int {
      Int(i)
    }

    var sa = [Int](repeating: 0, count: n)
    var ls = [Bool](repeating: false, count: n)
    for i in stride(from: n - 2, through: 0, by: -1) {
      ls[i] = s[i] == s[i + 1] ? ls[i + 1] : s[i] < s[i + 1]
    }

    let sum_l = UnsafeMutableBufferPointer<Int>(
      start: .allocate(capacity: upper + 1), count: upper + 1)
    let sum_s = UnsafeMutableBufferPointer<Int>(
      start: .allocate(capacity: upper + 1), count: upper + 1)

    defer {
      sum_l.deinitialize()
      sum_l.deallocate()
      sum_s.deinitialize()
      sum_s.deallocate()
    }

    for i in 0..<n {
      if !ls[i] {
        sum_s[index(s[i])] += 1
      } else {
        sum_l[index(s[i] + 1)] += 1
      }
    }

    for i in 0...upper {
      sum_s[i] += sum_l[i]
      if i < upper { sum_l[i + 1] += sum_s[i] }
    }

    func induce(_ lms: [Int]) {
      
      sa.withUnsafeMutableBufferPointer { sa in
        sa.update(repeating: -1)
      }

      let buf = UnsafeMutableBufferPointer<Int>(
        start: .allocate(capacity: upper + 1), count: upper + 1)

      defer {
        buf.deinitialize()
        buf.deallocate()
      }

      // std::copy(sum_s.begin(), sum_s.end(), buf.begin());
      _ = buf.initialize(from: sum_s)
      for d in lms {
        if d == n { continue }
        sa[buf[index(s[d])]] = d
        buf[index(s[d])] += 1
      }
      // std::copy(sum_l.begin(), sum_l.end(), buf.begin());
      _ = buf.update(from: sum_l)
      sa[buf[index(s[n - 1])]] = n - 1
      buf[index(s[n - 1])] += 1
      for i in 0..<n {
        let v = sa[i]
        if v >= 1, !ls[v - 1] {
          sa[buf[index(s[v - 1])]] = v - 1
          buf[index(s[v - 1])] += 1
        }
      }
      // std::copy(sum_l.begin(), sum_l.end(), buf.begin());
      _ = buf.update(from: sum_l)
      for i in stride(from: n - 1, through: 0, by: -1) {
        let v = sa[i]
        if v >= 1, ls[v - 1] {
          buf[index(s[v - 1]) + 1] -= 1
          sa[buf[index(s[v - 1]) + 1]] = v - 1
        }
      }
    }

    var lms_map = [Int](repeating: -1, count: n + 1)
    var m: Int = 0
    for i in 1..<n {
      if !ls[i - 1], ls[i] {
        lms_map[i] = m
        m += 1
      }
    }
    var lms = [Int]()
    lms.reserveCapacity(m)
    for i in 1..<n {
      if !ls[i - 1], ls[i] {
        lms.append(i)
      }
    }

    induce(lms)

    if m != 0 {
      var sorted_lms = [Int]()
      sorted_lms.reserveCapacity(m)
      for v in sa {
        if lms_map[v] != -1 { sorted_lms.append(v) }
      }
      var rec_s = [Int](repeating: 0, count: m)
      var rec_upper: Int = 0
      rec_s[lms_map[sorted_lms[0]]] = 0
      for i in 1..<m {
        var l = sorted_lms[i - 1]
        var r = sorted_lms[i]
        let end_l = lms_map[l] + 1 < m ? lms[lms_map[l] + 1] : n
        let end_r = lms_map[r] + 1 < m ? lms[lms_map[r] + 1] : n
        var same = true
        if end_l - l != end_r - r {
          same = false
        } else {
          while l < end_l {
            if s[l] != s[r] {
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

      let rec_sa = rec_s.withUnsafeBufferPointer {
        sa_is(
          $0, rec_upper, THRESHOLD_NAIVE,
          THRESHOLD_DOUBLING)
      }

      for i in 0..<m {
        sorted_lms[i] = lms[rec_sa[i]]
      }
      induce(sorted_lms)
    }
    return sa
  }
}

extension _Internal {

  @inlinable
  static func sa_naive<Element>(_ s: [Element]) -> [Int]
  where Element: BinaryInteger {

    s.withUnsafeBufferPointer { sa_naive($0) }
  }

  @inlinable
  static func sa_doubling<Element>(_ s: [Element]) -> [Int]
  where Element: BinaryInteger {

    s.withUnsafeBufferPointer { sa_doubling($0) }
  }
}

// MARK: - Suffix Array

@inlinable
public func suffix_array<Element>(_ s: [Element], _ upper: Element) -> [Int]
where Element: BinaryInteger {
  assert(0 <= upper)
  assert(s.allSatisfy { d in (0...upper).contains(d) })
  return s.withUnsafeBufferPointer { _Internal.sa_is($0, Int(upper)) }
}

@inlinable
public func suffix_array<V>(_ s: V) -> [Int]
where V: Collection, V.Element: Comparable, V.Index == Int {
  let n = s.count
  var idx = [Int](repeating: 0, count: n)
  idx = (0..<n).map { $0 }
  idx.sort { l, r in return s[l] < s[r] }
  var s2 = [Int](repeating: 0, count: n)
  var now = 0
  for i in 0..<n {
    if i != 0, s[idx[i - 1]] != s[idx[i]] { now += 1 }
    s2[idx[i]] = now
  }
  return s2.withUnsafeBufferPointer { _Internal.sa_is($0, now) }
}

@inlinable
public func suffix_array(_ s: [UInt8]) -> [Int] {
  suffix_array(s, UInt8.max)
}

/// Constructs a suffix array for a buffer of `Character`s.
///
/// This is the Unicode/`Character` fallback path used when the input cannot be
/// handled as plain ASCII bytes.
///
/// Swift `Character` represents an extended grapheme cluster, not a fixed-width
/// integer code point. Therefore it cannot be passed directly to the integer
/// alphabet SA-IS implementation, which requires values in `0...upper`.
///
/// This function first compresses the distinct characters into integer ranks:
///
/// ```text
/// ["b", "a", "n", "a", "n", "a"]
///        ↓
/// [ 1,   0,   2,   0,   2,   0 ]
/// ```
///
/// The relative order of characters is determined by `Character`'s
/// `Comparable` conformance. Equal characters receive the same rank, and
/// different characters receive increasing ranks according to the sorted order.
///
/// After rank compression, the existing integer SA-IS implementation is used.
///
/// The returned indices are offsets in the original `Character` buffer.
///
/// - Complexity: O(n log n), where n is the number of characters.
///   The SA-IS step itself is linear, but rank compression sorts the characters.
@inlinable
func suffix_array(_ s: UnsafeBufferPointer<Character>) -> [Int] {
  let n = s.count
  if n == 0 { return [] }

  // Sort indices by the corresponding Character.
  //
  // We sort indices instead of the characters themselves so that we can write
  // each computed rank back to the original position.
  var order = Array(0..<n)
  order.sort { s[$0] < s[$1] }

  return withUnsafeTemporaryAllocation(of: Int.self, capacity: n) { ranked in

    let rankedBase = ranked.baseAddress!

    // `ranked` is a temporary integer alphabet buffer.
    //
    // Every position is assigned exactly once below because `order` is a
    // permutation of `0..<n`. The initialization is kept explicit here to make
    // the temporary buffer's initialized state obvious before it is exposed as
    // an `UnsafeBufferPointer<Int>` to `sa_is`.
    rankedBase.initialize(repeating: 0, count: n)
    defer {
      rankedBase.deinitialize(count: n)
    }

    var upper = 0
    ranked[order[0]] = 0

    // Assign the same rank to equal adjacent characters in sorted order, and
    // advance the rank whenever the character value changes.
    for i in 1..<n {
      if s[order[i - 1]] != s[order[i]] {
        upper += 1
      }
      ranked[order[i]] = upper
    }

    // Now `ranked` contains only values in `0...upper`, which is exactly the
    // integer alphabet expected by SA-IS.
    return _Internal.sa_is(
      UnsafeBufferPointer(start: rankedBase, count: n),
      upper
    )
  }
}

/// Constructs a suffix array for a character array.
///
/// Fast path:
/// If every `Character` has an ASCII representation, this overload converts the
/// input to `[UInt8]` and uses the integer-alphabet SA-IS implementation.
///
/// Fallback:
/// If any character is not ASCII, this overload falls back to the
/// `UnsafeBufferPointer<Character>` implementation, which first compresses
/// characters into integer ranks by sorting them.
///
/// Important:
/// `Character.asciiValue` is non-nil only when the character is exactly one
/// ASCII character. Swift `Character` represents an extended grapheme cluster,
/// so many visible characters, such as Japanese characters, emoji, or combined
/// characters, do not have an ASCII value.
///
/// - Complexity:
///   - O(n) when all characters are ASCII.
///   - O(n log n) otherwise, due to rank compression by sorting.
@inlinable
public func suffix_array(_ s: [Character]) -> [Int] {
  let n = s.count
  if n == 0 { return [] }

  var ascii = [UInt8]()
  ascii.reserveCapacity(n)

  for c in s {
    guard let v = c.asciiValue else {
      // Non-ASCII `Character`.
      //
      // Fall back to the Character-based rank-compression path.
      // The returned indices are still offsets in the original `[Character]`.
      return s.withUnsafeBufferPointer {
        suffix_array($0)
      }
    }
    ascii.append(v)
  }

  // All characters are ASCII, so `[Character]` offsets and `[UInt8]` offsets
  // are identical. Therefore the suffix array produced from `ascii` is also
  // valid for the original `[Character]`.
  return ascii.withUnsafeBufferPointer {
    _Internal.sa_is($0, Int(UInt8.max))
  }
}

/// Constructs a suffix array for a string.
///
/// This overload returns indices as `Character` offsets.
///
/// ASCII fast path:
/// When the string contains only ASCII code units, UTF-8 code unit offsets and
/// `Character` offsets are identical. In that case, this overload runs SA-IS
/// directly on the UTF-8 code units.
///
/// Unicode fallback:
/// When the string contains any non-ASCII code unit, byte offsets and
/// `Character` offsets may differ. In that case, this overload converts the
/// string to `[Character]` and uses the Character-based overload instead.
///
/// Important:
/// `withCString(encodedAs: Unicode.UTF8.self)` provides a temporary,
/// null-terminated UTF-8 buffer. The null terminator is not part of the Swift
/// string, so `count` must be `s.utf8.count`, not the C-string length including
/// the terminator.
///
/// - Complexity:
///   - O(n) for ASCII strings, where n is the number of characters.
///   - O(n log n) for non-ASCII strings, due to Character rank compression.
@inlinable
public func suffix_array(_ s: String) -> [Int] {
  if s.isEmpty { return [] }

  if s.utf8.allSatisfy({ $0 < 0x80 }) {
    let n = s.utf8.count

    // ASCII only:
    //   UTF-8 code unit count == Character count
    //   UTF-8 code unit offset == Character offset
    //
    // Therefore it is safe to compute the suffix array over the UTF-8 bytes
    // while documenting the result as Character offsets.
    return s.withCString(encodedAs: Unicode.UTF8.self) {
      _Internal.sa_is(
        UnsafeBufferPointer(start: $0, count: n),
        Int(UInt8.max)
      )
    }
  } else {
    // Non-ASCII:
    // UTF-8 byte offsets and Character offsets may differ, so the UTF-8 suffix
    // array would not be a valid Character-offset suffix array.
    //
    // Convert to `[Character]` and use the Character overload, which preserves
    // Character offset semantics.
    return suffix_array(Array(s))
  }
}

// MARK: - LCP Array

/// Reference:
/// T. Kasai, G. Lee, H. Arimura, S. Arikawa, and K. Park,
/// Linear-Time Longest-Common-Prefix Computation in Suffix Arrays and Its
/// Applications
@inlinable
func lcp_array<Element>(pointer s: UnsafePointer<Element>, count n: Int, _ sa: [Int]) -> [Int]
where Element: Equatable {
  assert(n == sa.count)
  assert(n >= 1)
  var rnk = [Int](repeating: 0, count: n)
  for i in 0..<n {
    assert(0 <= sa[i] && sa[i] < n)
    rnk[sa[i]] = i
  }
  var lcp = [Int](repeating: 0, count: n - 1)
  var h = 0
  // for (int i = 0; i < n; i++) {
  for i in 0..<n {
    if h > 0 { h -= 1 }
    if rnk[i] == 0 { continue }
    let j = sa[rnk[i] - 1]
    // for (; j + h < n && i + h < n; h++) {
    //  if s[j + h] != s[i + h] { break }
    while j + h < n, i + h < n,
      s[j + h] == s[i + h]
    {
      h += 1
    }
    lcp[rnk[i] - 1] = h
  }
  return lcp
}

@inlinable
public func lcp_array<C>(_ s: [C], _ sa: [Int]) -> [Int]
where C: Equatable {
  lcp_array(pointer: s, count: s.count, sa)
}

@inlinable
public func lcp_array(_ s: String, _ sa: [Int]) -> [Int] {
  s.withCString(encodedAs: Unicode.ASCII.self) {
    lcp_array(pointer: $0, count: s.count, sa)
  }
}

// MARK: - Z algorithm

/// Reference:
/// D. Gusfield,
/// Algorithms on Strings, Trees, and Sequences: Computer Science and
/// Computational Biology
@inlinable
func z_algorithm<Element>(pointer s: UnsafePointer<Element>, count n: Int) -> [Int]
where Element: Equatable {
  if n == 0 { return [] }
  return [Int](unsafeUninitializedCapacity: n) { z, initializedCount in
    let z = z.baseAddress!
    z.initialize(repeating: 0, count: n)
    initializedCount = n
    z[0] = 0
    var i = 1
    var j = 0
    while i < n {
      defer { i += 1 }
      z[i] = j + z[j] <= i ? 0 : min(j + z[j] - i, z[i - j])
      while i + z[i] < n, s[z[i]] == s[i + z[i]] { z[i] += 1 }
      if j + z[j] < i + z[i] { j = i }
    }
    z[0] = n
  }
}

@inlinable
public func z_algorithm<C>(_ s: [C]) -> [Int]
where C: Equatable {
  z_algorithm(pointer: s, count: s.count)
}

@inlinable
public func z_algorithm(_ s: String) -> [Int] {
  s.withCString(encodedAs: Unicode.ASCII.self) {
    z_algorithm(pointer: $0, count: s.count)
  }
}
