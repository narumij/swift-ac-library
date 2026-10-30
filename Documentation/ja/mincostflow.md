# MinCostFlow

MinCostFlowのSwift版リファレンスです。

## Swift版の使い方

整数容量・費用ではMCFGraph<Int, Int>(count:)を使います。非コピー型です。戻り値のタプルは.0が流量、.1が費用です。Costは符号付きで、総量だけでなく中間計算も型に収まる必要があります。64bit環境のIntは64bitです。Int32費用には下記32bit上限、Int64/64bit Intには64bit上限を適用します。浮動小数点オーバーロードや数値変換visitorもありますが、整数版と同じ数値的保証を意味しません。flowLimitは非負で、1グラフへのflow/slopeは合計1回としてください。

[Minimum-cost flow problem](https://en.wikipedia.org/wiki/Minimum-cost_flow_problem)を扱うライブラリです。

## コンストラクタ

```swift
var graph = MCFGraph<Int, Int>(count: n)
```

$n$ 頂点 $0$ 辺のグラフを作る。`Cap`は容量の型、`Cost`はコストの型

**制約**

- $0 \leq n \leq 10^8$
- 整数の容量・費用にはInt・Int32・Int64を使います。

**計算量**

- $O(n)$

## add_edge

```swift
let edgeID: Int = graph.add_edge(from, to, cap, cost)
```

`from`から`to`へ最大容量`cap`, コスト`cost`の辺を追加する。何番目に追加された辺かを返す。

**制約**

- $0 \leq \mathrm{from}, \mathrm{to} \lt n$
- $0 \leq \mathrm{cap}, \mathrm{cost}$

**計算量**

- ならし $O(1)$

## flow

```swift
// (1)
let (amount, cost) = graph.flow(s, t)
// (2), on a separate unsolved graph
let (limitedAmount, limitedCost) = otherGraph.flow(s, t, flowLimit)
```

$s$ から $t$ へ流せるだけ流し、その流量とコストを返す。

- (1) $s$ から $t$ へ流せるだけ流す
- (2) $s$ から $t$ へ流量`flow_limit`まで流せるだけ流す

**制約**

- `slope`と同じ

**計算量**

- `slope`と同じ

## slope

```swift
// (1)
let points: [(Int, Int)] = graph.slope(s, t)
// (2), on a separate unsolved graph
let limitedPoints = otherGraph.slope(s, t, flowLimit)
```

返り値に流量とコストの関係の折れ線が入る。全ての $x$ について、流量 $x$ の時の最小コストを $g(x)$ とすると、$(x, g(x))$ は返り値を折れ線として見たものに含まれる。

- 返り値の最初の要素は $(0, 0)$
- 返り値の`.0` は狭義単調増加、`.1`は広義単調増加
- 3点が同一線上にあることはない
- (1) 返り値の最後の要素は最大流量 $x$ として $(x, g(x))$
- (2) 返り値の最後の要素は $y = \min(x, \mathrm{flow\\_limit})$ として $(y, g(y))$

**制約**

辺のコストの最大を $x$ として

- $s \neq t$
- $0 \leq s, t \lt n$
- `slope`や`flow`を合わせて複数回呼んだときの挙動は未定義
- `s`から`t`へ流したフローの流量が `Cap` に収まる。
- 流したフローのコストの総和が `Cost` に収まる。
- (Cost : `Int32`): $0 \leq nx \leq 2 \times 10^9 + 1000$
- (Cost : `Int64`): $0 \leq nx \leq 8 \times 10^{18} + 1000$

**計算量**

$F$ を流量、$m$ を追加した辺の本数として

- $O(F (n + m) \log (n + m))$

## edges

```swift
// (1)
let edge: MCFGraph<Int, Int>.Edge = graph.get_edge(i)
// (2)
let edges = graph.edges()
// Edge fields: from, to, cap, flow, cost
```

- 今の内部の辺の状態を返す
- 辺の順番はadd_edgeで追加された順番と同一

$m$ を追加された辺数として

**制約**

- (1): $0 \leq i \lt m$

**計算量**

- (1): $O(1)$
- (2): $O(m)$

## 使用例

```swift
import AtCoder

var graph = MCFGraph<Int, Int>(count: 3)
_ = graph.add_edge(0, 1, 2, 3)
_ = graph.add_edge(1, 2, 2, 4)
let result = graph.flow(0, 2, 2)
print(result.0, result.1) // 2 14
```

## 出典

以下の日英原稿をSwift向けに改編： [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_ja/mincostflow.md), CC0-1.0.

[目次](README.md) · [共通事項](usage.md)
