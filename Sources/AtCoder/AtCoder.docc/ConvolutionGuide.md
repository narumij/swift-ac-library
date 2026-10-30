# Convolution

A Swift reference for Convolution.

## Swift usage

Prefer convolution(mod_998_244_353.self, a, b) for integer arrays. The two-integer-array overload with an implicit modulus is deprecated. Result residues must fit the array element type; use Int rather than a narrow type. ModInt arrays infer the static modulus from their element type; dynamic modint is not supported. UnsafeBufferPointer and Sequence overloads are available for static ModInt values. convolution_ll takes [Int] and assumes a 64-bit host. Internal FFT caches are shared; passing serial sanitizer tests is not a guarantee of concurrent safety.

It calculates `(+,×)` convolution. Given two arrays `a_0, a_1, …, a_(N - 1)` and `b_0, b_1, …, b_(M - 1)`, it calculates the array `c` of length `N + M - 1`, defined by

`c[i] = Σ a[j] × b[i-j]` (valid array indices only)

## convolution

```swift
// (1): [Int] -> [Int], explicit modulus
let c = convolution(mod_998_244_353.self, a, b)
// (2): [modint998244353] -> [modint998244353]
let modularC = convolution(modularA, modularB)
```

It calculates the convolution in `mod m`. It returns an empty array if at least one of `a` and `b` are empty.

**Constraints**

- `2 ≤ m ≤ 2 × 10^9`
- `m` is prime.
- There is an integer `c` with `2^c | (m - 1)` and `|a| + |b| - 1 ≤ 2^c`.
- (1) T is a FixedWidthInteger; every output residue must fit T.

**Complexity**

- `O(nlog(n) + log((mod)))`, where `n = |a| + |b|`.

## convolution_ll

```swift
let c: [Int] = convolution_ll(a, b)
```

It calculates the convolution. It returns an empty array if at least one of `a` and `b` are empty.

**Constraints**

- `|a| + |b| - 1 ≤ 2^(24)`
- All the elements of the array are in `Int64` after convolution

**Complexity**

- `O(nlog(n))`, where `n = |a| + |b|`.

## Example

```swift
import AtCoder

let a = [1, 2, 3]
let b = [4, 5]
print(convolution(mod_998_244_353.self, a, b)) // [4, 13, 22, 15]
print(convolution_ll(a, b)) // [4, 13, 22, 15]
```

## Source

Adapted from [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_en/convolution.md), CC0-1.0.
