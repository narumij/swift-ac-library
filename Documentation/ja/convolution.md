# Convolution

ConvolutionのSwift版リファレンスです。

## Swift版の使い方

整数配列にはconvolution(mod_998_244_353.self,a,b)を使います。法を省略する整数配列2引数版は非推奨です。剰余結果が要素型に収まる必要があるので、狭い整数型よりIntを使ってください。ModInt配列は要素型から固定法を推論し、動的modintには対応しません。固定ModInt向けにはUnsafeBufferPointer・Sequence版もあります。convolution_llは[Int]で64bit環境を前提にします。内部FFTキャッシュは共有され、直列サニタイザーテストの成功は並行安全の保証ではありません。

畳み込みを行います。数列 $a_0, a_1, \cdots, a_{N - 1}$ と数列 $b_0, b_1, \cdots, b_{M - 1}$ から、長さ $N + M - 1$ の数列

`c[i] = Σ a[j] × b[i-j]` (valid array indices only)

を計算します。

## convolution

```swift
// (1): [Int] -> [Int], explicit modulus
let c = convolution(mod_998_244_353.self, a, b)
// (2): [modint998244353] -> [modint998244353]
let modularC = convolution(modularA, modularB)
```

畳み込みを $\bmod m$ で計算します。$a, b$ の少なくとも一方が空配列の場合は空配列を返します。

**制約**

- $2 \leq m \leq 2 \times 10^9$
- $\mathrm{m}$ は素数
- $2^c | (\mathrm{m} - 1)$ かつ $|a| + |b| - 1 \leq 2^c$ なる $c$ が存在する
- (1) TはFixedWidthIntegerで、出力の剰余がTに収まる必要があります。

**計算量**

$n = |a| + |b|$ として

- $O(n\log{n} + \log{\mathrm{mod}})$

## convolution_ll

```swift
let c: [Int] = convolution_ll(a, b)
```

畳み込みを計算します。$a, b$ の少なくとも一方が空配列の場合は空配列を返します。

**制約**

- $|a| + |b| - 1 \leq 2^{24}$
- 畳み込んだ後の配列の要素が全て`Int64`に収まる

**計算量**

$n = |a| + |b|$ として

- $O(n\log{n})$

## 使用例

```swift
import AtCoder

let a = [1, 2, 3]
let b = [4, 5]
print(convolution(mod_998_244_353.self, a, b)) // [4, 13, 22, 15]
print(convolution_ll(a, b)) // [4, 13, 22, 15]
```

## 出典

以下の日英原稿をSwift向けに改編： [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_ja/convolution.md), CC0-1.0.

[目次](README.md) · [共通事項](usage.md)
