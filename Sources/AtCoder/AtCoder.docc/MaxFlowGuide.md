# MaxFlow

A Swift reference for MaxFlow.

## Swift usage

MFGraph<Int>(count:) is the usual Swift form. Cap must satisfy the declared numeric constraints; Int32 and Int64 are also suitable integer choices. Floating-point types are accepted by the generic implementation, but the integral-capacity bounds below do not establish floating-point accuracy or termination. Edge IDs are zero-based. Use nonnegative flowLimit. Graphs are noncopyable. Keep flow conservation when using change_edge: it only changes that edge and does not repair a flow. A later flow call returns additional flow, not the previous total.

It solves [maximum flow problem](https://en.wikipedia.org/wiki/Maximum_flow_problem).

## Constructor

```swift
var graph = MFGraph<Int>(count: n)
```

It creates a graph of `n` vertices and `0` edges. `Cap` is the type of the capacity.

**Constraints**

- `0 ≤ n ≤ 10^8`
- Use Int, Int32 or Int64 for integral capacities.

**Complexity**

- `O(n)`

## add_edge

```swift
let edgeID: Int = graph.add_edge(from, to, cap)
```

It adds an edge oriented from the vertex `from` to the vertex `to` with the capacity `cap` and the flow amount `0`. It returns an integer `k` such that this is the `k`-th edge that is added.

**Constraints**

- `0 ≤ (from), (to) < n`
- `0 ≤ (cap)`

**Complexity**

- `O(1)` amortized

## flow

```swift
// (1)
let amount = graph.flow(s, t)
// (2)
let limitedAmount = graph.flow(s, t, flowLimit)
```

- (1) It augments the flow from `s` to `t` as much as possible. It returns the amount of the flow augmented.
- (2) It augments the flow from `s` to `t` as much as possible, until reaching the amount of `flow_limit`. It returns the amount of the flow augmented.
- You may call it multiple times. See [Appendix](<doc:Usage>) for further details.

**Constraints**

- `s ≠ t`
- `0 ≤ s, t < n`
- The answer should be in `Cap`.

**Complexity**

- `O((n + m) √(m))` (if all the capacities are `1`),
- `O(n^2 m)` (general), or
- `O(F(n + m))`, where `F` is the returned value

where `m` is the number of added edges.

## min_cut

```swift
let reachable: [Bool] = graph.min_cut(s)
```

It returns a Array of length `n`, such that the `i`-th element is `true` if and only if there is a directed path from `s` to `i` in the residual network.
The returned Array corresponds to a `s-t` minimum cut after calling `flow(s, t)` exactly once without `flow_limit`. See [Appendix](<doc:Usage>) for further details.

**Complexity**

- `O(n + m)`, where `m` is the number of added edges.

## get_edge / edges

```swift
// (1)
let edge: MFGraph<Int>.Edge = graph.get_edge(i)
// (2)
let edges: [MFGraph<Int>.Edge] = graph.edges()
// Edge fields: from, to, cap, flow
```

- It returns the current internal state of the edges.
- The edges are ordered in the same order as added by `add_edge`.

**Constraints**

- (1): `0 ≤ i < m`

**Complexity**

- (1): `O(1)`
- (2): `O(m)`, where `m` is the number of added edges.

## change_edge

```swift
graph.change_edge(i, newCap, newFlow)
```

It changes the capacity and the flow amount of the `i`-th edge to `new_cap` and `new_flow`, respectively. It doesn't change the capacity or the flow amount of other edges. See [Appendix](<doc:Usage>) for further details.

**Constraints**

- `0 ≤ (newflow) ≤ (newcap)`

**Complexity**

- `O(1)`

## Example

```swift
import AtCoder

var graph = MFGraph<Int>(count: 4)
_ = graph.add_edge(0, 1, 2)
_ = graph.add_edge(0, 2, 1)
_ = graph.add_edge(1, 3, 2)
_ = graph.add_edge(2, 3, 1)
print(graph.flow(0, 3)) // 3
print(graph.min_cut(0)) // [true, false, false, false]
```

## Source

Adapted from [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_en/maxflow.md), CC0-1.0.
