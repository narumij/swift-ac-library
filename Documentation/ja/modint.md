# ModInt：剰余演算

固定法・実行時に決める法で、剰余を値として保持して演算します。

## 型を選ぶ

- `modint998244353` は `static_modint<mod_998_244_353>`。
- `modint1000000007` は `static_modint<mod_1_000_000_007>`。
- `modint` は `dynamic_modint<mod_dynamic>`。問題の値を作る前に `modint.set_mod(m)` を呼びます。Swift版の初期値は998244353ですが、他の処理が変更し得るので既定値に依存しないでください。

ModIntはコピー可能な値型です。他の機能でModIntを使わないなら、この章を先に読む必要はありません。

## 構築と値の取得

| Swift式 | 意味 | 計算量 |
| --- | --- | --- |
| `Mint()` | ゼロ | O(1) |
| `Mint(value)` | 符号付き・符号なし整数またはBoolを法mで正規化し0..<mにする | 固定幅入力でO(1) |
| `Mint.mod` | 法をIntで返す | O(1) |
| `value.val` | 剰余をIntで返す | O(1) |
| `value.uval` | 剰余をUIntで返す | O(1) |
| `Mint(rawValue: x)` | UIntのxを剰余計算せず格納。0 ≤ x < mが必要 | O(1) |

`mod`・`val`・`inv`はC++版のメソッドではなくプロパティです。
整数リテラルも使えます：`let x: Mint = 10`。
rawValueは正規化済みと分かっている値のための高速化で、任意の整数に使ってはいけません。

## 演算子

単項 `+`・`-`、二項 `+`・`-`・`*`・`/`、複合代入
`+=`・`-=`・`*=`・`/=`、等値比較 `==`・`!=` が使えます。
`1 + x`・`x * 1234`のような整数との演算も可能です。
SwiftにはC++の `++`・`--` がないので `x += 1`・`x -= 1` を使います。

除算 `a / b`・`a /= b` は gcd(b.val,m)=1 が条件です。
加減乗算・比較はO(1)、除算はO(log m)です。
固定法が異なればSwiftの型も異なります。同じ動的型でも、異なる法の設定中に作った値を混ぜないでください。

## 累乗と逆元

- `x.pow(n)`：n ≥ 0。xのn乗をO(log n)で返します。指数0は法mにおける1。
- `x.inv`：gcd(x.val,m)=1が必要。逆元をO(log m)で返します。
- 法が素数なら非ゼロは逆元を持ちます。合成数では非ゼロというだけでは不十分です。

## 別の固定法

`static var umod: UInt`を持つ `static_mod` 適合型を定義し、
`static_modint<YourModulus>` を使います。本家の制約は1 ≤ m ≤ 2×10^9+1000。
Swift実装の記載上限はUInt32.maxですが、内部格納がUIntだからといって64bitの法全域が使えるわけではありません。
別途検証した拡張を使うのでなければ、本家の範囲を基本にしてください。

既定の `isPrime` はtrueを返し、Debugでだけ素数のassertを行います。
合成数では `static let isPrime = false` を必ず定義してください。
Releaseで自動的に素数判定する機能ではなく、誤った指定は逆元の誤答につながります。

## 動的な法・複数の法

`Mint.set_mod(m)` はO(1)。本家の制約は1 ≤ m ≤ 2×10^9+1000です。
その型の古い値を使っている間に法を変えないでください。
動的法の型ごとに独立したBarrett状態を持たせられます。

```swift
enum RuntimeModA: dynamic_mod {
    nonisolated(unsafe) static var bt: barrett = .default
}
enum RuntimeModB: dynamic_mod {
    nonisolated(unsafe) static var bt: barrett = .default
}
typealias MintA = dynamic_modint<RuntimeModA>
typealias MintB = dynamic_modint<RuntimeModB>
MintA.set_mod(11)
MintB.set_mod(13)
```

この状態は共有可変状態です。`nonisolated(unsafe)`は同期処理ではありません。
set_modと構築・演算を競合させず、必要に応じて独立した型や外部の同期を使ってください。

## 版による違い

現行ソースでは、法がInt8などの入力型に収まらない場合の構築不具合を修正済みです。
古い版ではゼロでも停止する場合があり、`Mint(Int(smallValue))`のように先に広げて回避します。
本家C++の制約ではなくSwift移植側の問題です。

## 使用例

```swift
import AtCoder

typealias Mint = modint998244353
let a = Mint(10)
let b = Mint(3)
print((a + b).val) // 13
print((a / b * b).val) // 10
print(b.pow(4).val) // 81
print((b * b.inv).val) // 1

modint.set_mod(11)
let x = modint(10)
print((x + 3).val) // 2

enum Mod17: static_mod {
    static let umod: UInt = 17
}
typealias Mint17 = static_modint<Mod17>
print((Mint17(16) + 2).val) // 1
```

## 出典

Swift向けに改編：[AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_ja/modint.md), CC0-1.0.

[目次](README.md) · [共通事項](usage.md)
