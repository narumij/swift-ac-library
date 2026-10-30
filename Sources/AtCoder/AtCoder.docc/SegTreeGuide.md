# Segtree

A Swift reference for Segtree.

## Swift usage

Define a SegTreeOperator type with associated element type S (inferred from op/e), static func op(_:_:) and static var e. The closure-based SegTreeOperation is an alternative. The example Minimum below uses Int.max as the identity. The tree is noncopyable; clone() costs O(n). Initializers also accept a Collection or (count, initializerClosure); the closure may take the element index. Counts and stored arithmetic must fit the available memory and element type.

It is the data structure for [monoids](https://en.wikipedia.org/wiki/Monoid) `(S, ·: S × S → S, e ∈ S)`, i.e., the algebraic structure that satisfies the following properties.

- associativity: `(a · b) · c` = `a · (b · c)` for all `a, b, c ∈ S`
- existence of the identity element: `a · e` = `e · a` = `a` for all `a ∈ S`

Given an array `S` of length `n`, it processes the following queries in `O(log n)` time (see [Appendix](<doc:Usage>) for further details).

- Updating an element
- Calculating the product of the elements of an interval

For simplicity, in this document, we assume that the oracles `op` and `e` work in constant time. If these oracles work in `O(T)` time, each time complexity appear in this document is multipled by `O(T)`.

## Constructor

```swift
// (1)
var seg = SegTree<Minimum>(n)
// (2)
var fromValues = SegTree<Minimum>(values)
```

The following should be defined.

- The type `S`
- The binary operation `static func op(_ a: S, _ b: S) -> S`
- The identity element `static var e: S`

For example, for Range Minimum Query, the definitions are as follows.

```swift
enum Minimum: SegTreeOperator {
    static func op(_ a: Int, _ b: Int) -> Int { min(a, b) }
    static var e: Int { Int.max }
}
var seg = SegTree<Minimum>(10)
```

- (1): It creates an array `a` of length `n`. All the elements are initialized to `e`.
- (2): It creates an array `a` of length `n = values.count`, initialized to `v`.

See the complete example below.

**Constraints**

- `0 ≤ n ≤ 10^8`

**Complexity**

- `O(n)`

## set

```swift
seg.set(p, x)
```

It assigns `x` to `a[p]`.

**Constraints**

- `0 ≤ p < n`

**Complexity**

- `O(log n)`

## get

```swift
let value = seg.get(p)
```

It returns `a[p]`.

**Constraints**

- `0 ≤ p < n`

**Complexity**

- `O(1)`

## prod

```swift
let value = seg.prod(l, r)
```

It returns `op(a[l], ..., a[r - 1])`, assuming the properties of the monoid. It returns `e` if `l = r`.

**Constraints**

- `0 ≤ l ≤ r ≤ n`

**Complexity**

- `O(log n)`

## all_prod

```swift
let value = seg.all_prod()
```

It returns `op(a[0], ..., a[n - 1])`, assuming the properties of the monoid. It returns `e` if `n = 0`.

**Complexity**

- `O(1)`

## max_right

```swift
let r: Int = seg.max_right(l, predicate)
```

Pass a pure predicate (S) -> Bool as the second argument.

It returns an index `r` that satisfies both of the following.

- `r = l` or `f(op(a[l], a[l + 1], ..., a[r - 1])) = true`
- `r = n` or `f(op(a[l], a[l + 1], ..., a[r])) = false`

If `f` is monotone, this is the maximum `r` that satisfies `f(op(a[l], a[l + 1], ..., a[r - 1])) = true`.

**Constraints**

- if `f` is called with the same argument, it returns the same value, i.e., `f` has no side effect.
- `f(e) = true`
- `0 ≤ l ≤ n`

**Complexity**

- `O(log n)`

## min_left

```swift
let l: Int = seg.min_left(r, predicate)
```

Pass a pure predicate (S) -> Bool as the second argument.

It returns an index `l` that satisfies both of the following.

- `l = r` or `f(op(a[l], a[l + 1], ..., a[r - 1])) = true`
- `l = 0` or `f(op(a[l - 1], a[l], ..., a[r - 1])) = false`

If `f` is monotone, this is the minimum `l` that satisfies `f(op(a[l], a[l + 1], ..., a[r - 1])) = true`.

**Constraints**

- if `f` is called with the same argument, it returns the same value, i.e., `f` has no side effect.
- `f(e) = true`
- `0 ≤ r ≤ n`

**Complexity**

- `O(log n)`

## Example

```swift
import AtCoder

enum RangeSum: SegTreeOperator {
    static func op(_ a: Int, _ b: Int) -> Int { a + b }
    static var e: Int { 0 }
}
var tree = SegTree<RangeSum>([1, 2, 3, 4])
print(tree.prod(1, 3)) // 5
tree.set(2, 10)
print(tree.all_prod()) // 17
print(tree.max_right(0) { $0 <= 3 }) // 2
print(tree.min_left(4) { $0 <= 4 }) // 3
```

## Source

Adapted from [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_en/segtree.md), CC0-1.0.
