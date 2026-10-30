# Fenwick Tree

A Swift reference for Fenwick Tree.

## Swift usage

Use Int, UInt, Int32, UInt32, Int64 or UInt64; Int128/UInt128 require platform support. The generic constraints are AdditiveArithmetic and ToUnsignedType. The provided ModInt types also conform. Integer sums wrap at the storage bit width; ModInt storage uses UInt, so do not infer unlimited modular accumulation across UInt overflow. The tree is noncopyable; clone() creates an independent O(n) copy.

Given an array of length `n`, it processes the following queries in `O(log n)` time.

- Updating an element
- Calculating the sum of the elements of an interval

## Constructor

```swift
var fw = FenwickTree<Int>(n)
```

- It creates an array `a_0, a_1, …, a_(n-1)` of length `n`. All the elements are initialized to `0`.

**Constraints**

- T: AdditiveArithmetic & ToUnsignedType (see Swift notes).
- `0 ≤ n ≤ 10^8`

**Complexity**

- `O(n)`

## add

```swift
fw.add(p, x)
```

It processes `a[p] += x`.

**Constraints**

- `0 ≤ p < n`

**Complexity**

- `O(log n)`

## sum

```swift
let total: Int = fw.sum(l, r)
```

It returns `a[l] + a[l + 1] + ... + a[r - 1]`.
If `T` is integer type(`Int32`, `UInt32`, `Int64`, or `UInt64`), it returns the answer in `mod 2^bit`, if overflowed.

**Constraints**

- `0 ≤ l ≤ r ≤ n`

**Complexity**

- `O(log n)`

## Example

```swift
import AtCoder

var tree = FenwickTree<Int>(4)
tree.add(0, 3)
tree.add(2, 5)
print(tree.sum(0, 3)) // 8
print(tree.sum(1, 1)) // 0
```

## Source

Adapted from [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_en/fenwicktree.md), CC0-1.0.
