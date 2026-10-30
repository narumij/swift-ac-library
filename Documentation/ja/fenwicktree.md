# Fenwick Tree

Fenwick TreeのSwift版リファレンスです。

## Swift版の使い方

Int・UInt・Int32・UInt32・Int64・UInt64が使えます。Int128/UInt128は対応環境が必要です。型制約はAdditiveArithmeticとToUnsignedTypeで、提供するModInt型も適合します。整数和は格納型のビット幅でラップします。ModIntも内部格納はUIntなので、UIntの桁あふれを超えて常に法に対する正しい累積が得られるとは限りません。非コピー型です。clone()でO(n)の独立した複製を作れます。

長さ $n$ の配列に対し、

- 要素の $1$ 点変更
- 区間の要素の総和

を $O(\log n)$ で求めることが出来るデータ構造です。

## コンストラクタ

```swift
var fw = FenwickTree<Int>(n)
```

- 長さ $n$ の配列 $a_0, a_1, \cdots, a_{n-1}$ を作ります。初期値はすべて $0$ です。

**制約**

- TはAdditiveArithmeticとToUnsignedTypeに適合する型（上記参照）。
- $0 \leq n \leq 10^8$

**計算量**

- $O(n)$

## add

```swift
fw.add(p, x)
```

`a[p] += x` を行います。

**制約**

- $0 \leq p < n$

**計算量**

- $O(\log n)$

## sum

```swift
let total: Int = fw.sum(l, r)
```

`a[l] + a[l + 1] + ... + a[r - 1]` を返します。
`T` が整数型(`int / uint / ll / ull`)の場合、答えがオーバーフローしたならば $\bmod 2^{\mathrm{bit}}$ で等しい値を返します。

**制約**

- $0 \leq l \leq r \leq n$

**計算量**

- $O(\log n)$

## 使用例

```swift
import AtCoder

var tree = FenwickTree<Int>(4)
tree.add(0, 3)
tree.add(2, 5)
print(tree.sum(0, 3)) // 8
print(tree.sum(1, 1)) // 0
```

## 出典

以下の日英原稿をSwift向けに改編： [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_ja/fenwicktree.md), CC0-1.0.

[目次](README.md) · [共通事項](usage.md)
