# String

A Swift reference for String.

## Swift usage

String overloads return Character offsets, not UTF-8 byte offsets or String.Index. Convert to Array(text) when indexing by these results. ASCII String and [UInt8] suffix arrays run in O(n); non-ASCII String/[Character] use rank compression, O(n log n) character comparisons. Unicode comparison/conversion costs depend on the encoded text length. Generic suffix_array accepts Comparable collections with Int indices but indexes 0..<count: pass a zero-based Array, not a nonzero-based slice. Generic lcp_array/z_algorithm accept Equatable arrays. The upper-bound suffix-array overload accepts integer arrays whose values fit Int. Never mix a byte suffix array with a Character-based LCP call. LCP requires nonempty input; suffix_array and z_algorithm accept empty input.

It contains string algorithms.

Let `s` be a string.
We denote the substring of `s` between `a`-th and `b - 1`-th character by `s[a..b)`.

## suffix_array

```swift
// (1): String -> [Int]
let sa = suffix_array(text)
// (2): [Int] -> [Int]
let sa2 = suffix_array(values)
// (3): [Int] and alphabet upper bound -> [Int]
let sa3 = suffix_array(values, upper)
```

Given a string `s` of length `n`, it returns the suffix array of `s`.
Here, the suffix array `sa` of `s` is a permutation of `0, …, n-1` such that `s[sa[i]..n) < s[sa[i+1]..n)` holds for all `i = 0,1, … ,n-2`.

**Constraints**

- `0 ≤ n ≤ 10^8`
- (2) See the Swift element-type and indexing requirements above.
- (3) `0 ≤ (upper) ≤ 10^8`
- (3) `0 ≤ x ≤ (upper)` for all elements `x` of `s`.

Complexity

- (1) ASCII: O(n); non-ASCII: O(n log n) character comparisons.
- (2) `O(n log n)`-time, `O(n)`-space
- (3) `O(n + (upper))`-time

## lcp_array

```swift
// (1): String and its suffix array
let lcp = lcp_array(text, sa)
// (2): Array and its suffix array
let lcp2 = lcp_array(values, sa2)
```

Given a string `s` of length `n`, it returns the LCP array of `s`.
Here, the LCP array of `s` is the array of length `n-1`, such that the `i`-th element is the length of the LCP (Longest Common Prefix) of `s[sa[i]..n)` and `s[sa[i+1]..n)`.

**Constraints**

- `sa` is the suffix array of `s`.
- `1 ≤ n ≤ 10^8`
- (2) See the Swift element-type and indexing requirements above.

**Complexity**

- `O(n)`

## z_algorithm

```swift
// (1): String
let z = z_algorithm(text)
// (2): Array
let z2 = z_algorithm(values)
```

Given a string of length `n`, it returns the array of length `n`, such that the `i`-th element is the length of the LCP (Longest Common Prefix) of `s[0..n)` and `s[i..n)`.

**Constraints**

- `0 ≤ n ≤ 10^8`
- (2) See the Swift element-type and indexing requirements above.

**Complexity**

- `O(n)`

## Example

```swift
import AtCoder

let text = "banana"
let sa = suffix_array(text)
print(sa) // [5, 3, 1, 0, 4, 2]
print(lcp_array(text, sa)) // [1, 3, 0, 0, 2]
print(z_algorithm("aaaa")) // [4, 3, 2, 1]
let characters = Array(text)
print(String(characters[sa[0]...])) // a
```

## Source

Adapted from [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_en/string.md), CC0-1.0.
