# DSU

A Swift reference for DSU.

## Swift usage

DSU is noncopyable. Queries same, leader, size and groups require var because path compression changes storage. unite(a, b) returns true only when two previously separate components merge (amortized O(α(n))). reset() restores n singleton components in O(n); clone() makes an independent O(n) copy. No edge deletion is provided.

Given an undirected graph, it processes the following queries in `O(α(n))` time (amortized).

- Edge addition
- Deciding whether given two vertices are in the same connected component

Each connected component internally has a representative vertex.

When two connected components are merged by edge addition, one of the two representatives of these connected components becomes the representative of the new connected component.

## Constructor

```swift
var d = DSU(n)
```

- It creates an undirected graph with `n` vertices and `0` edges.

**Constraints**

- `0 ≤ n ≤ 10^8`

**Complexity**

- `O(n)`

## merge

```swift
let representative: Int = d.merge(a, b)
```

It adds an edge `(a, b)`.

If the vertices `a` and `b` were in the same connected component, it returns the representative of this connected component. Otherwise, it returns the representative of the new connected component.

**Constraints**

- `0 ≤ a < n`
- `0 ≤ b < n`

**Complexity**

- `O(α(n))` amortized

## same

```swift
let connected: Bool = d.same(a, b)
```

It returns whether the vertices `a` and `b` are in the same connected component.

**Constraints**

- `0 ≤ a < n`
- `0 ≤ b < n`

**Complexity**

- `O(α(n))` amortized

## leader

```swift
let representative: Int = d.leader(a)
```

It returns the representative of the connected component that contains the vertex `a`.

**Constraints**

- `0 ≤ a < n`

**Complexity**

- `O(α(n))` amortized

## size

```swift
let count: Int = d.size(a)
```

It returns the size of the connected component that contains the vertex `a`.

**Constraints**

- `0 ≤ a < n`

**Complexity**

- `O(α(n))` amortized

## groups

```swift
let components: [[Int]] = d.groups()
```

It divides the graph into connected components and returns the list of them.

More precisely, it returns the list of the "list of the vertices in a connected component".
Both of the orders of the connected components and the vertices are undefined.

**Complexity**

- `O(n)`

## Example

```swift
import AtCoder

var components = DSU(4)
_ = components.merge(0, 1)
print(components.same(0, 1)) // true
print(components.size(0)) // 2
print(components.same(0, 2)) // false
```

## Source

Adapted from [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_en/dsu.md), CC0-1.0.
