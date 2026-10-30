# Lazy Segtree

A Swift reference for Lazy Segtree.

## Swift usage

Define LazySegTreeOperator with S, F, op, e, mapping, composition and id. composition(f, g) must apply g first, then f; reversing this breaks noncommuting updates. The complete RangeAddSum example below stores segment length as well as sum. Construct real elements with length 1; constructing by count instead fills with e (length 0). get/prod/search are mutating, so use var. The tree is noncopyable; clone() costs O(n). Collection and initializer-closure constructors are also available.

It is the data structure for the pair of a [monoid](https://en.wikipedia.org/wiki/Monoid) `(S, ·: S × S → S, e ∈ S)` and a set `F` of `S → S` mappings that satisfies the following properties.

- `F` contains the identity map `(id)`, where the identity map is the map that satisfies `(id)(x) = x` for all `x ∈ S`.
- `F` is closed under composition, i.e., `f ∘ g ∈ F` holds for all `f, g ∈ F`.
- `f(x · y) = f(x) · f(y)` holds for all `f ∈ F` and `x, y ∈ S`.

Given an array `S` of length `N`, it processes the following queries in `O(log N)` time (see [Appendix](<doc:Usage>) for further details).

- Acting the map `f∈ F` (cf. `x = f(x)`) on all the elements of an interval
- Calculating the product of the elements of an interval

For simplicity, in this document, we assume that the oracles `op`, `e`, `mapping`, `composition`, and `id` work in constant time. If these oracles work in `O(T)` time, each time complexity appear in this document is multipled by `O(T)`.

## Constructor

```swift
// (1)
var seg = LazySegTree<RangeAddSum>(n)
// (2)
var fromValues = LazySegTree<RangeAddSum>(values)
```

The following should be defined.

- The type `S` of the monoid
- The binary operation `static func op(_ a: S, _ b: S) -> S`
- The function `static var e: S` that returns `e`
- The type `F` of the map
- The function `static func mapping(_ f: F, _ x: S) -> S` that returns `f(x)`
- The function `static func composition(_ f: F, _ g: F) -> F` that returns `f ∘ g`
- The function `static var id: F` that returns `(id)`

See the complete example below.

- (1): It creates an array `a` of length `n`. All the elements are initialized to `e`.
- (2): It creates an array `a` of length `n = values.count`, initialized to `v`.

**Constraints**

- `0 ≤ n ≤ 10^8`

**Complexity**

- `O(n)`

## set

```swift
seg.set(p, x)
```

`a[p] = x`

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

- `O(log n)`

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

## apply

```swift
// (1)
seg.apply(p, f)
// (2)
seg.apply(l, r, f)
```

- (1) It applies `a[p] = f(a[p])`.
- (2) It applies `a[i] = f(a[i])` for all `i = l..r-1`.

**Constraints**

- (1) `0 ≤ p < n`
- (2) `0 ≤ l ≤ r ≤ n`

**Complexity**

- `O(log n)`

## max_right

```swift
let r: Int = seg.max_right(l, predicate)
```

Pass a pure predicate (S) -> Bool as the second argument.

It returns an index `r` that satisfies both of the followings.

- `r = l` or `g(op(a[l], a[l + 1], ..., a[r - 1])) = true`
- `r = n` or `g(op(a[l], a[l + 1], ..., a[r])) = false`

If `g` is monotone, this is the maximum `r` that satisfies `g(op(a[l], a[l + 1], ..., a[r - 1])) = true`.

**Constraints**

- if `g` is called with the same argument, it returns the same value, i.e., `g` has no side effect.
- `g(e) = true`
- `0 ≤ l ≤ n`

**Complexity**

- `O(log n)`

## min_left

```swift
let l: Int = seg.min_left(r, predicate)
```

Pass a pure predicate (S) -> Bool as the second argument.

It returns an index `l` that satisfies both of the following.

- `l = r` or `g(op(a[l], a[l + 1], ..., a[r - 1])) = true`
- `l = 0` or `g(op(a[l - 1], a[l], ..., a[r - 1])) = false`

If `g` is monotone, this is the minimum `l` that satisfies `g(op(a[l], a[l + 1], ..., a[r - 1])) = true`.

**Constraints**

- if `g` is called with the same argument, it returns the same value, i.e., `g` has no side effect.
- `g(e) = true`
- `0 ≤ r ≤ n`

**Complexity**

- `O(log n)`

## Example

```swift
import AtCoder

struct Segment {
    var sum: Int
    var length: Int
}
enum RangeAddSum: LazySegTreeOperator {
    static var e: Segment { Segment(sum: 0, length: 0) }
    static func op(_ a: Segment, _ b: Segment) -> Segment {
        Segment(sum: a.sum + b.sum, length: a.length + b.length)
    }
    static var id: Int { 0 }
    static func mapping(_ f: Int, _ x: Segment) -> Segment {
        Segment(sum: x.sum + f * x.length, length: x.length)
    }
    static func composition(_ f: Int, _ g: Int) -> Int { f + g }
}
var tree = LazySegTree<RangeAddSum>(
    [1, 2, 3].map { Segment(sum: $0, length: 1) }
)
tree.apply(0, 2, 5)
print(tree.prod(0, 3).sum) // 16
print(tree.get(1).sum) // 7
```

## Source

Adapted from [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_en/lazysegtree.md), CC0-1.0.
