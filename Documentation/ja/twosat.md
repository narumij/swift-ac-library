# 2-SAT

2-SATのSwift版リファレンスです。

## Swift版の使い方

TwoSATは非コピー型で、節の追加・求解にはvarを使います。単位節x[i]=fはadd_clause(i,f,i,f)で表現できます。answerはsatisfiable()がtrueだった後に読みます。節を足したら再度求解してください。返るSwift Arrayはcopy-on-writeで、全要素の複製や共有結果の変更にはO(n)かかります。

2-SATを解きます。
変数 $x_0, x_1, \cdots, x_{N - 1}$ に関して、

- $(x_i = f) \lor (x_j = g)$

というクローズを足し、これをすべて満たす変数の割当があるかを解きます。

## コンストラクタ

```swift
var ts = TwoSAT(n)
```

$n$ 変数の2-SATを作ります。

**制約**

- $0 \leq n \leq 10^8$

**計算量**

- $O(n)$

## add_clause

```swift
ts.add_clause(i, f, j, g)
```

$(x_i = f) \lor (x_j = g)$ というクローズを足します。

**制約**

- $0 \leq i \lt n$
- $0 \leq j \lt n$

**計算量**

- ならし $O(1)$

## satisfiable

```swift
let possible: Bool = ts.satisfiable
```

条件を足す割当が存在するかどうかを判定する。割当が存在するならば`true`、そうでないなら`false`を返す。

**制約**

- 複数回呼ぶことも可能。

**計算量**

足した制約の個数を $m$ として

- $O(n + m)$

## answer

```swift
let values: [Bool] = ts.answer()
```

最後に呼んだ `satisfiable` の、クローズを満たす割当を返す。`satisfiable` を呼ぶ前や、`satisfiable` で割当が存在しなかったときにこの関数を呼ぶと、中身が未定義の長さ $n$ の Arrayを返す。

**計算量**

- $O(n)$

## 使用例

```swift
import AtCoder

var formula = TwoSAT(2)
formula.add_clause(0, true, 0, true)
formula.add_clause(0, false, 1, true)
if formula.satisfiable() {
    print(formula.answer()) // [true, true]
}
```

## 出典

以下の日英原稿をSwift向けに改編： [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_ja/twosat.md), CC0-1.0.

[目次](README.md) · [共通事項](usage.md)
