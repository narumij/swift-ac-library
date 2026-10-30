# SCC

SCCのSwift版リファレンスです。

## Swift版の使い方

SCCGraphは非コピー型です。成分間はトポロジカル順ですが、成分内の頂点順序は未規定です。辺を追加した後にscc()を再計算でき、グラフを消費しません。Swift版の探索は再帰DFSではなく明示的なスタックです。

有向グラフを強連結成分分解します。

## コンストラクタ

```swift
var graph = SCCGraph(n)
```

$n$ 頂点 $0$ 辺の有向グラフを作る。

**制約**

- $0 \leq n \leq 10^8$

**計算量**

- $O(n)$

## add_edge

```swift
graph.add_edge(from, to)
```

頂点 `from` から頂点 `to` へ有向辺を足す。

**制約**

- $0 \leq \mathrm{from} \lt n$
- $0 \leq \mathrm{to} \lt n$

**計算量**

- ならし $O(1)$

## scc

```swift
let components: [[Int]] = graph.scc()
```

以下の条件を満たすような、「頂点のリスト」のリストを返します。

- 全ての頂点がちょうど1つずつ、どれかのリストに含まれます。
- 内側のリストと強連結成分が一対一に対応します。リスト内での頂点の順序は未定義です。
- リストはトポロジカルソートされています。異なる強連結成分の頂点 $u, v$ について、$u$ から $v$ に到達できる時、$u$ の属するリストは $v$ の属するリストよりも前です。

**計算量**

追加した辺の本数を $m$ として

- $O(n + m)$

## 使用例

```swift
import AtCoder

var graph = SCCGraph(3)
graph.add_edge(0, 1)
graph.add_edge(1, 0)
graph.add_edge(1, 2)
let groups = graph.scc()
print(groups.map { $0.sorted() }) // [[0, 1], [2]]
```

## 出典

以下の日英原稿をSwift向けに改編： [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_ja/scc.md), CC0-1.0.

[目次](README.md) · [共通事項](usage.md)
