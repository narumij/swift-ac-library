# MaxFlow

MaxFlowのSwift版リファレンスです。

## Swift版の使い方

通常はMFGraph<Int>(count:)を使います。Capは宣言された数値型制約を満たす必要があり、整数ではInt32・Int64も使えます。浮動小数点型も実装上受け取れますが、以下の整数容量の計算量・正確さ・終了をそのまま保証するものではありません。辺番号は0始まり。flowLimitは非負です。グラフは非コピー型です。change_edgeは他の辺を修復しないため、フロー保存則を呼出側で保ってください。再度flowを呼ぶと追加分が返り、累積量ではありません。

[最大フロー問題](https://ja.wikipedia.org/wiki/%E6%9C%80%E5%A4%A7%E3%83%95%E3%83%AD%E3%83%BC%E5%95%8F%E9%A1%8C) を解くライブラリです。

## コンストラクタ

```swift
var graph = MFGraph<Int>(count: n)
```

`n` 頂点 $0$ 辺のグラフを作る。`Cap`は容量の型。

**制約**

- $0 \leq n \leq 10^8$
- 整数容量にはInt・Int32・Int64を使います。

**計算量**

- $O(n)$

## add_edge

```swift
let edgeID: Int = graph.add_edge(from, to, cap)
```

`from`から`to`へ最大容量`cap`、流量 $0$ の辺を追加し、何番目に追加された辺かを返す。

**制約**

- $0 \leq \mathrm{from}, \mathrm{to} \lt n$
- $0 \leq \mathrm{cap}$

**計算量**

- ならし $O(1)$

## flow

```swift
// (1)
let amount = graph.flow(s, t)
// (2)
let limitedAmount = graph.flow(s, t, flowLimit)
```

- (1) 頂点 $s$ から $t$ へ流せる限り流し、流せた量を返す。
- (2) 頂点 $s$ から $t$ へ流量 `flow_limit` に達するまで流せる限り流し、流せた量を返す。
- 複数回呼ぶことも可能で、その時の挙動は [Appendix](usage.md) を参照してください。

**制約**

- $s \neq t$
- $0 \leq s, t \lt n$
- 返り値が `Cap` に収まる

**計算量**

$m$ を追加された辺数として

- $O((n + m) \sqrt{m})$ (辺の容量がすべて $1$ の時)
- $O(n^2 m)$
- 返り値を $F$ として $O(F(n + m))$

## min_cut

```swift
let reachable: [Bool] = graph.min_cut(s)
```

長さ $n$ のArrayを返す。$i$ 番目の要素には、頂点 $s$ から $i$ へ残余グラフで到達可能なとき、またその時のみ `true` を返す。`flow(s, t)`をflow_limitなしでちょうど一回呼んだ後に呼ぶと、返り値は $s$, $t$ 間のmincutに対応します。詳細な挙動は [Appendix](usage.md) を参照してください。

**計算量**

$m$ を追加された辺数として

- $O(n + m)$

## get_edge / edges

```swift
// (1)
let edge: MFGraph<Int>.Edge = graph.get_edge(i)
// (2)
let edges: [MFGraph<Int>.Edge] = graph.edges()
// Edge fields: from, to, cap, flow
```

- 今の内部の辺の状態を返す
- 辺の順番はadd_edgeで追加された順番と同一

**制約**

- (1): $0 \leq i \lt m$

**計算量**

$m$ を追加された辺数として

- (1): $O(1)$
- (2): $O(m)$

## change_edge

```swift
graph.change_edge(i, newCap, newFlow)
```

$i$ 番目に追加された辺の容量、流量を`new_cap`, `new_flow`に変更する。他の辺の容量、流量は変更しない。詳細は [Appendix](usage.md) を参照してください

**制約**

- $0 \leq \mathrm{newflow} \leq \mathrm{newcap}$

**計算量**

- $O(1)$

## 使用例

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

## 出典

以下の日英原稿をSwift向けに改編： [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_ja/maxflow.md), CC0-1.0.

[目次](README.md) · [共通事項](usage.md)
