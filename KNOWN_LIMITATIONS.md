# Known limitations / 既知の制限事項

Confirmed on 2026-10-30 with Apple Swift 6.4, macOS arm64, in Debug and Release. These notes describe observed restrictions, not a guarantee for every other input or platform.

2026-10-30、Apple Swift 6.4・macOS arm64のDebug／Releaseで確認した制限です。記載のない型・入力・環境がすべて安全という意味ではありません。

## ModInt construction from narrow integer types — fixed

**Status:** Fixed on 2026-10-30; not yet released. Narrow inputs are widened before reduction, while the existing 64-/128-bit paths are retained. The behavior below describes the pre-fix implementation. All 624 boundary runs and the 3,486-case differential corpus passed after the fix.

Before this fix, when constructing `modint` or `modint998244353` from `Int8`, `UInt8`, `Int16`, or `UInt16`, construction traps if the modulus cannot be represented by the input type. This happens even when the input value is zero. The implementation converts the modulus to the input type before taking the remainder.

For example, `modint998244353(Int8(0))` traps. Widen the input first:

```swift
let input: Int8 = 0
let value = modint998244353(Int(input))
```

For dynamic `modint`, the same restriction depends on the current modulus. In the boundary checks, modulus 127 worked for `Int8`, while 128 trapped; modulus 255 worked for `UInt8`, while 256 trapped. The corresponding 16-bit boundaries were also confirmed.

This is a Swift-port restriction: the equivalent C++ constructors in the compared ACL revision accepted these inputs. The workaround remains useful for versions without this fix.

### 日本語

**状態：2026-10-30に修正済み（未リリース）。** 小さい入力だけを先にIntへ広げ、内部の64bit表現と既存の64/128bit入力経路を維持しています。以下は修正前の制限です。修正後は境界624実行と既存比較3,486ケースが成功しました。

`Int8`・`UInt8`・`Int16`・`UInt16`から`modint`／`modint998244353`を生成するとき、**法が入力の整数型に収まらないと、値がゼロでも実行時エラーになります**。内部で剰余計算より先に、法を入力の型へ変換するためです。

回避方法は、上の例のように小さい整数型を先に`Int`へ変換することです。`modint`の場合は現在の法に依存します。確認した境界はInt8の127/128、UInt8の255/256、Int16の32767/32768、UInt16の65535/65536です（前者は成功、後者は失敗）。

これは本家C++の入力制約ではなく、Swift版固有の制限です。修正が入っていない版では、上記の回避方法を使用してください。

## Comparison scope / 比較範囲

The reference ACL revision was `864245a00b00dd008d1abfdc239618fdb7d139da`. Integer constructors were checked at zero and each input type's minimum/maximum, including 8-, 16-, 32-, 64-, and 128-bit integers. FenwickTree was also checked at its supported 32-, 64-, and 128-bit integer extrema with one further addition. Those Fenwick cases matched the C++ results, including modular overflow behavior; this is not a promise that the mathematical sum always fits the result type.

比較対象は上記の固定リビジョンです。ModIntの各整数型のゼロ・最小値・最大値と、FenwickTreeの32〜128ビット型の境界での加算を確認しました。Fenwickは今回C++と一致していますが、型幅を超える和は数学的な整数和のまま保持されるわけではありません。

Internal evidence / 内部調査記録: OPS-010, `Maintanance/Investigations/OPS-010/boundaries/`.

## floor_sum: negative coefficients at integer boundaries

Confirmed on macOS arm64, Swift 6.4, Debug and Release. The Swift implementation can return a wrong value or trap for valid boundary inputs. Examples:

| Call | Expected (also observed in C++ ACL) | Swift |
| --- | --- | --- |
| `floor_sum(1, 2, 0, Int.min)` | `-4611686018427387904` | `4611686018427387904` |
| `floor_sum(1, 1, 0, Int.min)` | `Int.min` | runtime trap |
| `floor_sum(4294967295, 4294967295, -1, -1)` | `-4294967295` | `9223372032559808513` |

The port uses signed intermediate arithmetic where ACL uses unsigned arithmetic. Wrapping a multiplication before signed division does not preserve ACL's result. A result fitting in `Int` is therefore not a sufficient workaround. Avoid these boundary combinations until corrected; no general safe range is established here.

### 日本語

`floor_sum`は負の係数と整数境界の組合せで、誤答または実行時停止になります。上表は最終結果がIntに収まる再現例です。本家の符号なし中間計算を符号付きで処理しており、乗算のラップ後の除算などで意味が変わります。最終結果が収まるだけでは回避できません。現段階では修正せず制限として記録し、安全な入力範囲を一律には保証しません。

追加調査316ケース×4構成のうち、C++は全件一致、Swiftは各構成37件不一致（誤答22件・停止15件）。不一致はすべてfloor_sum。最大流15件、最小費用流48件は型に収まる容量・総費用かつ小さいグラフの範囲で一致しました。pow_mod・inv_mod・単一条件CRTも今回の範囲で一致。複数条件CRTの境界、フロー全型・複雑な経路の限界は未確認です。

再実行：`bash Maintanance/Investigations/OPS-010/build.sh` の後に `python3 Maintanance/Investigations/OPS-010/extended-boundaries.py`。Pythonの任意精度整数で期待値を計算し、floor_sumは本家に合わせ64bit剰余として比較。入力・結果は同ディレクトリの `extended-boundary-summary.json` に保存。
