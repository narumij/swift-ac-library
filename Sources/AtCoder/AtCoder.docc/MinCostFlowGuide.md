# MinCostFlow

A Swift reference for MinCostFlow.

## Swift usage

Use MCFGraph<Int, Int>(count:) for integral capacities and costs. The graph is noncopyable. Tuple fields are .0 (flow) and .1 (cost). Cost must be signed; both the total and intermediate arithmetic must fit the chosen types. Int is 64-bit on supported 64-bit hosts. For Int32 costs use the original 32-bit bound below; for Int64/64-bit Int use the 64-bit bound. Floating-point overloads and numeric-cast visitors exist, but are not a promise of the integral algorithm’s numerical guarantees. Use nonnegative flowLimit and solve each graph only once with flow or slope.

It solves [Minimum-cost flow problem](https://en.wikipedia.org/wiki/Minimum-cost_flow_problem).

## Constructor

```swift
var graph = MCFGraph<Int, Int>(count: n)
```

It creates a directed graph with `n` vertices and `0` edges. `Cap` and `Cost` are the type of the capacity and the cost, respectively.

**Constraints**

- `0 ≤ n ≤ 10^8`
- Integral Cap and Cost can use Int, Int32 or Int64.

**Complexity**

- `O(n)`

## add_edge

```swift
let edgeID: Int = graph.add_edge(from, to, cap, cost)
```

It adds an edge oriented from `from` to `to` with capacity `cap` and cost `cost`. It returns an integer `k` such that this is the `k`-th edge that is added.

**Constraints**

- `0 ≤ (from), (to) < n`
- `0 ≤ (cap), (cost)`

**Complexity**

- `O(1)` amortized

## flow

```swift
// (1)
let (amount, cost) = graph.flow(s, t)
// (2), on a separate unsolved graph
let (limitedAmount, limitedCost) = otherGraph.flow(s, t, flowLimit)
```

- It augments the flow from `s` to `t` as much as possible. It returns the amount of the flow and the cost.
- (1) It augments the `s-t` flow as much as possible.
- (2) It augments the `s-t` flow as much as possible, until reaching the amount of `flow_limit`.

**Constraints**

- same as `slope`.

**Complexity**

- same as `slope`.

## slope

```swift
// (1)
let points: [(Int, Int)] = graph.slope(s, t)
// (2), on a separate unsolved graph
let limitedPoints = otherGraph.slope(s, t, flowLimit)
```

Let `g` be a function such that `g(x)` is the cost of the minimum cost `s-t` flow when the amount of the flow is exactly `x`. `g` is known to be piecewise linear.
It returns `g` as the list of the changepoints, that satisfies the followings.

- The first element of the list is `(0, 0)`.
- `.0` is strictly increasing and `.1` is non-decreasing.
- No three changepoints are on the same line.
- (1) The last element of the list is `(x, g(x))`, where `x` is the maximum amount of the `s-t` flow.
- (2) The last element of the list is `(y, g(y))`, where `y = min(x, (flow_limit))`.

**Constraints**

Let `x` be the maximum cost among all edges.

- `s ≠ t`
- `0 ≤ s, t < n`
- You can't call `slope` or `flow` multiple times.
- The total amount of the flow is in `Cap`.
- The total cost of the flow is in `Cost`.
- (Cost : `Int32`): `0 ≤ nx ≤ 2 × 10^9 + 1000`
- (Cost : `Int64`): `0 ≤ nx ≤ 8 × 10^(18) + 1000`

**Complexity**

- `O(F (n + m) log (n + m))`, where `F` is the amount of the flow and `m` is the number of added edges.

## edges

```swift
// (1)
let edge: MCFGraph<Int, Int>.Edge = graph.get_edge(i)
// (2)
let edges = graph.edges()
// Edge fields: from, to, cap, flow, cost
```

- It returns the current internal state of the edges.
- The edges are ordered in the same order as added by `add_edge`.

**Constraints**

- (1): `0 ≤ i < m`

**Complexity**

- (1): `O(1)`
- (2): `O(m)`, where `m` is the number of added edges.

## Example

```swift
import AtCoder

var graph = MCFGraph<Int, Int>(count: 3)
_ = graph.add_edge(0, 1, 2, 3)
_ = graph.add_edge(1, 2, 2, 4)
let result = graph.flow(0, 2, 2)
print(result.0, result.1) // 2 14
```

## Source

Adapted from [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_en/mincostflow.md), CC0-1.0.
