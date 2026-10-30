# SCC

A Swift reference for SCC.

## Swift usage

SCCGraph is noncopyable. Component order is topological, but vertex order within each component is unspecified. scc() can be recomputed after adding edges; it does not consume the graph. The Swift implementation uses an explicit traversal stack, not recursive DFS.

It calculates the strongly connected components of directed graphs.

## Constructor

```swift
var graph = SCCGraph(n)
```

It creates a directed graph with `n` vertices and `0` edges.

**Constraints**

- `0 ≤ n ≤ 10^8`

**Complexity**

- `O(n)`

## add_edge

```swift
graph.add_edge(from, to)
```

It adds a directed edge from the vertex `from` to the vertex `to`.

**Constraints**

- `0 ≤ (from) < n`
- `0 ≤ (to) < n`

**Complexity**

- `O(1)` amortized

## scc

```swift
let components: [[Int]] = graph.scc()
```

It returns the list of the "list of the vertices" that satisfies the following.

- Each vertex is in exactly one "list of the vertices".
- Each "list of the vertices" corresponds to the vertex set of a strongly connected component. The order of the vertices in the list is undefined.
- The list of "list of the vertices" are sorted in topological order, i.e., for two vertices `u, v` in different strongly connected components, if there is a directed path from `u` to `v`, the list containing `u` appears earlier than the list containing `v`.

**Complexity**

- `O(n + m)`, where `m` is the number of added edges.

## Example

```swift
import AtCoder

var graph = SCCGraph(3)
graph.add_edge(0, 1)
graph.add_edge(1, 0)
graph.add_edge(1, 2)
let groups = graph.scc()
print(groups.map { $0.sorted() }) // [[0, 1], [2]]
```

## Source

Adapted from [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_en/scc.md), CC0-1.0.
