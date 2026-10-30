# Segtree

SegtreeのSwift版リファレンスです。

## Swift版の使い方

SegTreeOperatorに適合する型で要素型S（op/eから推論可能）、static func op(_:_:)、static var eを定義します。クロージャを使うSegTreeOperationもあります。下のMinimumはInt.maxを単位元にします。非コピー型でclone()はO(n)。Collectionや(count, 初期化クロージャ)でも構築でき、クロージャは添字を受け取れます。メモリと要素型に収まる範囲を使ってください。

[モノイド](https://ja.wikipedia.org/wiki/%E3%83%A2%E3%83%8E%E3%82%A4%E3%83%89) $(S, \cdot: S \times S \to S, e \in S)$、つまり

- 結合律: $(a \cdot b) \cdot c$ = $a \cdot (b \cdot c)$ （すべての $a,b,c \in S$）
- 単位元の存在: $a \cdot e$ = $e \cdot a$ = $a$ （すべての $a \in S$）

を満たす代数構造に対し使用できるデータ構造です。

長さ $n$ の $S$ の配列に対し、

- 要素の $1$ 点変更
- 区間の要素の総積の取得

を $O(\log n)$ で行うことが出来ます。詳細な要件は [Appendix](usage.md) を参照してください。

また、このライブラリはオラクルとして`op, e`の2種類を使用しますが、これらが定数時間で動くものと仮定したときの計算量を記述します。オラクル内部の計算量が $O(f(n))$ である場合はすべての計算量が $O(f(n))$ 倍となります。

## コンストラクタ

```swift
// (1)
var seg = SegTree<Minimum>(n)
// (2)
var fromValues = SegTree<Minimum>(values)
```

- 型 `S`
- 二項演算 `static func op(_ a: S, _ b: S) -> S`
- 単位元 `static var e: S`

を定義する必要があります。例として、Range Min Queryならば

```swift
enum Minimum: SegTreeOperator {
    static func op(_ a: Int, _ b: Int) -> Int { min(a, b) }
    static var e: Int { Int.max }
}
var seg = SegTree<Minimum>(10)
```

のようになります。

- (1): 長さ `n` の数列 `a` を作ります。初期値は全部`e`です。
- (2): 長さ `n = values.count` の数列 `a` を作ります。`v` の内容が初期値となります。

末尾の使用例を参照してください。

**制約**

- $0 \leq n \leq 10^8$

**計算量**

- $O(n)$

## set

```swift
seg.set(p, x)
```

`a[p]` に `x` を代入します。

**制約**

- $0 \leq p < n$

**計算量**

- $O(\log n)$

## get

```swift
let value = seg.get(p)
```

`a[p]` を返します。

**制約**

- $0 \leq p < n$

**計算量**

- $O(1)$

## prod

```swift
let value = seg.prod(l, r)
```

`op(a[l], ..., a[r - 1])` を、モノイドの性質を満たしていると仮定して計算します。$l = r$ のときは `e` を返します。

**制約**

- $0 \leq l \leq r \leq n$

**計算量**

- $O(\log n)$

## all_prod

```swift
let value = seg.all_prod()
```

`op(a[0], ..., a[n - 1])` を計算します。$n = 0$ のときは `e` を返します。

**計算量**

- $O(1)$

## max_right

```swift
let r: Int = seg.max_right(l, predicate)
```

第2引数に副作用のない述語(S) -> Boolを渡します。

以下の条件を両方満たす `r` を(いずれか一つ)返します。

- `r = l` もしくは `f(op(a[l], a[l + 1], ..., a[r - 1])) = true`
- `r = n` もしくは `f(op(a[l], a[l + 1], ..., a[r])) = false`

`f`が単調だとすれば、`f(op(a[l], a[l + 1], ..., a[r - 1])) = true` となる最大の `r`、と解釈することが可能です。

**制約**

- `f`を同じ引数で呼んだ時、返り値は等しい(=副作用はない)
- `f(e) = true`
- $0 \leq l \leq n$

**計算量**

- $O(\log n)$

## min_left

```swift
let l: Int = seg.min_left(r, predicate)
```

第2引数に副作用のない述語(S) -> Boolを渡します。

以下の条件を両方満たす `l` を(いずれか一つ)返します。

- `l = r` もしくは `f(op(a[l], a[l + 1], ..., a[r - 1])) = true`
- `l = 0` もしくは `f(op(a[l - 1], a[l], ..., a[r - 1])) = false`

`f`が単調だとすれば、`f(op(a[l], a[l + 1], ..., a[r - 1])) = true` となる最小の `l`、と解釈することが可能です。

**制約**

- `f`を同じ引数で呼んだ時、返り値は等しい(=副作用はない)
- `f(e) = true`
- $0 \leq r \leq n$

**計算量**

- $O(\log n)$

## 使用例

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

## 出典

以下の日英原稿をSwift向けに改編： [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_ja/segtree.md), CC0-1.0.

[目次](README.md) · [共通事項](usage.md)
