# Lazy Segtree

Lazy SegtreeのSwift版リファレンスです。

## Swift版の使い方

LazySegTreeOperatorにS・F・op・e・mapping・composition・idを定義します。composition(f,g)はgの後にfを適用します。逆順では非可換な更新が壊れます。末尾のRangeAddSum例は区間長も保持し、実要素のlengthを1で初期化します。個数だけの構築ではe（length 0）が入る点に注意。get/prod/探索もmutatingなのでvarを使います。非コピー型でclone()はO(n)。Collection・初期化クロージャによる構築も可能です。

[モノイド](https://ja.wikipedia.org/wiki/%E3%83%A2%E3%83%8E%E3%82%A4%E3%83%89) $(S, \cdot: S \times S \to S, e \in S)$と、$S$ から $S$ への写像の集合 $F$ であって、以下の条件を満たすようなものについて使用できるデータ構造です。

- $F$ は恒等写像 $\mathrm{id}$ を含む。つまり、任意の $x \in S$ に対し $\mathrm{id}(x) = x$ をみたす。
- $F$ は写像の合成について閉じている。つまり、任意の $f, g \in F$ に対し $f \circ g \in F$ である。
- 任意の $f \in F, x, y \in S$ に対し $f(x \cdot y) = f(x) \cdot f(y)$ をみたす。

長さ $N$ の $S$ の配列に対し、

- 区間の要素に一括で $F$ の要素 $f$ を作用($x = f(x)$ )
- 区間の要素の総積の取得

を $O(\log N)$ で行うことが出来ます。詳細な要件は [Appendix](usage.md) を参照してください。

また、このライブラリはオラクルとして`op, e, mapping, composition, id`を使用しますが、これらが定数時間で動くものと仮定したときの計算量を記述します。オラクル内部の計算量が $O(f(n))$ である場合はすべての計算量が $O(f(n))$ 倍となります。

## コンストラクタ

```swift
// (1)
var seg = LazySegTree<RangeAddSum>(n)
// (2)
var fromValues = LazySegTree<RangeAddSum>(values)
```

- モノイドの型 `S`
- $\cdot: S \times S \to S$ を計算する関数 `static func op(_ a: S, _ b: S) -> S`
- $e$ を返すプロパティ `static var e: S`
- 写像の型 `F`
- $f(x)$ を返す関数 `static func mapping(_ f: F, _ x: S) -> S`
- $f \circ g$ を返す関数 `static func composition(_ f: F, _ g: F) -> F`
- $id$ を返すプロパティ `static var id: F`

を定義する必要があります。
末尾の使用例を参照してください。

- (1): 長さ `n` の数列 `a` を作ります。初期値は全部`e`です。
- (2): 長さ `n = values.count` の数列 `a` を作ります。`v` の内容が初期値となります。

**制約**

- $0 \leq n \leq 10^8$

**計算量**

- $O(n)$

## set

```swift
seg.set(p, x)
```

`a[p] = x`

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

- $O(\log n)$

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

`op(a[0], ..., a[n-1])` を計算します。$n = 0$ のときは `e` を返します。

**計算量**

- $O(1)$

## apply

```swift
// (1)
seg.apply(p, f)
// (2)
seg.apply(l, r, f)
```

- (1) `a[p] = f(a[p])`
- (2) `i = l..r-1`について`a[i] = f(a[i])`

**制約**

- (1) $0 \leq p < n$
- (2) $0 \leq l \leq r \leq n$

**計算量**

- $O(\log n)$

## max_right

```swift
let r: Int = seg.max_right(l, predicate)
```

第2引数に副作用のない述語(S) -> Boolを渡します。

以下の条件を両方満たす `r` を(いずれか一つ)返します。

- `r = l` もしくは `g(op(a[l], a[l + 1], ..., a[r - 1])) = true`
- `r = n` もしくは `g(op(a[l], a[l + 1], ..., a[r])) = false`

`g`が単調だとすれば、`g(op(a[l], a[l + 1], ..., a[r - 1])) = true` となる最大の `r`、と解釈することが可能です。

**制約**

- `g`を同じ引数で呼んだ時、返り値は等しい(=副作用はない)
- `g(e) = true`
- $0 \leq l \leq n$

**計算量**

- $O(\log n)$

## min_left

```swift
let l: Int = seg.min_left(r, predicate)
```

第2引数に副作用のない述語(S) -> Boolを渡します。

以下の条件を両方満たす `l` を(いずれか一つ)返します。

- `l = r` もしくは `g(op(a[l], a[l + 1], ..., a[r - 1])) = true`
- `l = 0` もしくは `g(op(a[l - 1], a[l], ..., a[r - 1])) = false`

`g`が単調だとすれば、`g(op(a[l], a[l + 1], ..., a[r - 1])) = true` となる最小の `l`、と解釈することが可能です。

**制約**

- `g`を同じ引数で呼んだ時、返り値は等しい(=副作用はない)
- `g(e) = true`
- $0 \leq r \leq n$

**計算量**

- $O(\log n)$

## 使用例

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

## 出典

以下の日英原稿をSwift向けに改編： [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_ja/lazysegtree.md), CC0-1.0.

[目次](README.md) · [共通事項](usage.md)
