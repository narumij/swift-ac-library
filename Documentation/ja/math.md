# Math

MathのSwift版リファレンスです。

## Swift版の使い方

引数・戻り値はすべてIntで、ビット幅の記載は64bit環境を前提にします。pow_modの法はSwift Int全域ではなく本家C++ intの範囲（1...Int32.max）を使います。inv_modは互いに素、crtは最小公倍数がIntに収まることが必要です。floor_sumは符号なし中間計算を使い、64bitでラップした結果をIntとして返します。a,bは負でも構いません。現行ソースでは負係数の境界不具合を修正済みですが、古い搭載版は最終結果がInt内でも誤答・停止することがあります。

数論的アルゴリズム詰め合わせです。

## pow_mod

```swift
let value: Int = pow_mod(x, n, m)
```

$x^n \bmod m$ を返します。

**制約**

- $0 \le n$
- $1 \le m$

**計算量**

- $O(\log n)$

## inv_mod

```swift
let inverse: Int = inv_mod(x, m)
```

$xy \equiv 1 \pmod m$ なる $y$ のうち、$0 \le y < m$ を満たすものを返します。

**制約**

- $\gcd(x, m) = 1$
- $1 \leq m$

**計算量**

- $O(\log m)$

## crt

```swift
let result: (rem: Int, mod: Int) = crt(remainders, moduli)
```

同じ長さの配列 $r, m$ を渡します。この配列の長さを $n$ とした時、

`x ≡ r[i] (mod m[i]), i = 0..<n`

を解きます。答えは(存在するならば) $y, z (0 \leq y < z = \mathrm{lcm}(m[i]))$ を用いて $x \equiv y \pmod z$ の形で書けることが知られており、この $(y, z)$ をタプルとして返します。答えがない場合は $(0, 0)$ を返します。$n=0$ の時は $(0, 1)$ を返します。

**制約**

- $|r| = |m|$
- $1 \le m[i]$
- $\mathrm{lcm}(m[i])$ が `Int64` に収まる。

**計算量**

- $O(n \log{\mathrm{lcm}(m[i])})$

## floor_sum

```swift
let total: Int = floor_sum(n, m, a, b)
```

`Σ(i = 0..<n) floor((a × i + b) / m)`

を返します。答えがオーバーフローしたならば $\bmod 2^{\mathrm{64}}$ で等しい値を返します。

**制約**

- $0 \leq n \lt 2^{32}$
- $1 \leq m \lt 2^{32}$

**計算量**

- $O(\log m)$

## 使用例

```swift
import AtCoder

print(pow_mod(2, 10, 1_000)) // 24
print(inv_mod(3, 7)) // 5
let solution = crt([2, 3], [3, 5])
print(solution.rem, solution.mod) // 8 15
print(floor_sum(4, 10, 6, 3)) // 3
```

## 出典

以下の日英原稿をSwift向けに改編： [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_ja/math.md), CC0-1.0.

[目次](README.md) · [共通事項](usage.md)
