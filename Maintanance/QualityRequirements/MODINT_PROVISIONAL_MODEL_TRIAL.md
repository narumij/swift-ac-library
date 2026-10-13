# ModInt Quality Model Provisional Trial

> **文書状態:** 第五回の暫定試験記録。品質の本試験、品質アセスメント、適合判定、受入判定ではない。
>
> **実施日:** 2026-10-14
>
> static型と、型ごとの可変modulusを持つdynamic型へ品質モデルを適用し、値の`Sendable`適合と共有状態、test isolation、Swift固有APIを分離できるか反証する。

## 1. 対象と境界

### 対象

- `Sources/AtCoder/modint.swift`
- `Sources/AtCoder/internal_mod.swift`
- `Sources/AtCoder/internal_mod_value.swift`
- `Sources/AtCoder/internal_math.swift` の演算経路
- `Tests/AtCoderTests/modintTests.swift`
- `Tests/AtCoderTests/deathTests/modintDeathTests.swift`
- 現行packageの提供構成

### 対象外

- ModIntの品質合否
- 本家基準版の採用と網羅的照合
- global modulus stateの公開契約またはconcurrency方針の決定
- 実装修正、benchmark、Sanitizer、Linux、Release、`-Ounchecked`
- 全演算組合せと全modulusの検証
- API文書の完成度評価

対象外領域でも、品質モデルの適用可能性と下位要求候補を調べるため証拠の存在・不在を観測する。

## 2. 観測時点と実行環境

- repository HEAD: `dfa1381babee15b6c5786c5616fdd027189cf94f`
- worktree: 棚卸し用testとmaintenance文書に未コミット変更あり
- 対象ModInt source／既存test: HEADとの差分なし
- macOS 27.0.1 (26A434)、arm64
- Xcode 27.0 (27A266a)
- Swift 6.4 (`swiftlang-6.4.0.34.1`)
- scheme／test plan: `swift-ac-library-Package`
- test target: `AtCoderTests`
- configuration名と最適化level: 独立には固定していない

23件を選択実行し、22件成功、1件skip、失敗0件、not run 0件だった。skipは`modintTests/testStress()`で、DEBUG条件による。

- summary: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/DE84379B-09F4-478B-AF89-E3AB2504E739/RunSomeTests/F171796D-1490-4FA9-B275-442D5E23EF1B.txt`
- xcresult: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/DE84379B-09F4-478B-AF89-E3AB2504E739/RunSomeTests/Test-swift-ac-library-Package-2026.10.14_02-58-26-+0900.xcresult`

一時artifactは永続証拠ではない。選択対象はstatic／dynamic usage、modulus境界、constructor、Int128、inverse、演算、Numeric適合、negative exponent death testを含む。

追加の棚卸し用test `EtcTests/testInventoryDynamicModIntValueAcrossModulusChange()` も選択実行し、1件成功した。このtestはmodulus 7で生成した値6について、modulusを5へ変えた後も`val`は6を返し、その値と0の加算結果は現在のmodulusにより1となる現行挙動を観測する。

- inventory summary: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/DE84379B-09F4-478B-AF89-E3AB2504E739/RunSomeTests/266AAE90-E292-486E-B712-9EB21B46989E.txt`
- inventory xcresult: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/DE84379B-09F4-478B-AF89-E3AB2504E739/RunSomeTests/Test-swift-ac-library-Package-2026.10.14_03-04-53-+0900.xcresult`

この観測は、変更後の演算意味が型の現在状態に依存することを具体化するが、その挙動を望ましい公開契約として採用しない。

## 3. 観測した事実

### static型とdynamic型

- `static_modint<m>`は型parameterから固定modulusを得る値型で、`Sendable`に適合する。
- `dynamic_modint<bt>`は型parameterごとの可変modulusを`set_mod`で設定する値型で、同じく`Sendable`に適合する。
- dynamic側の演算は、値自身の`_v`だけでなく`bt`が保持する現在のbarrett／modulusへ依存する。
- `mod_dynamic.bt`は`nonisolated(unsafe) public static var`である。
- testは各case後に`dynamic_mod.reset()`を呼び、型に属する状態がtest scopeを越えて残ることへ対処する。

### Sendableと並行性

値型の`Sendable`適合は、その値をconcurrency domain間で受け渡せるという主張に関係する。一方、dynamic型の演算意味は型ごとの可変static stateへ依存する。

したがって、少なくとも次を分けて具体化する必要がある。

- ModInt値そのものの受渡し条件
- `set_mod`と同型値の生成・演算を並行実行できるか
- modulus変更前に作られた値を変更後に使う意味
- 異なる`dynamic_mod`型parameter間のstate分離
- 利用者事前条件、型設計、同期のどこで不変条件を維持するか

`Sendable`適合だけから、`set_mod`を含む自由な並行アクセスが安全とは判定しない。現時点でdata raceまたは不具合を実証したとも判定しない。

### testの範囲

- static／dynamicの主要演算、constructor、inverse、境界modulus、Int128、Swiftの整数overload、Numeric適合を観測する。
- negative exponentはprocess exitで観測する。
- `testStress`は今回skipであり、列挙されたことやsource上の存在を実行成功へ読み替えない。
- `testIncrement`はsource上で`#if false`にあり、実行証拠へ数えない。
- 既存値とmodulus変更後の逐次的な演算は棚卸し用testで観測したが、並行変更とtask間受渡しは直接観測していない。

## 4. 本家との限定照合

本家ac-libraryのmaster commit `864245a00b00dd008d1abfdc239618fdb7d139da` を比較点に固定した。製品基準版として採用しない。

- implementation: `https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/atcoder/modint.hpp`
- test: `https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/test/unittest/modint_test.cpp`
- documentation: `https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_en/modint.md`

限定照合では、DynamicBorder、ULL、Mod1、ModIntMax、Int128、Inv、ConstUsage、StaticUsage、DynamicUsage、Constructor系に内容上の対応候補がある。Swift側にはDynamicBorderAlt、Numeric、整数overload等の追加観測がある。一部の本家test blockはSwift側で無効化されている。

本家dynamic_modintもIDごとの可変static modulusを持つが、Swiftの`Sendable`とstrict concurrencyに関する意味はSwift製品固有に具体化する必要がある。内容対応から歴史的由来やSwift上の適合を自動的に証明しない。

## 5. 上位品質モデルへの暫定適用

### QR-01 ACL適合性

演算、static／dynamic区分、`set_mod`、複数IDという対応候補を扱える。一方、Swiftのprotocol適合、整数overload、`Sendable`、strict concurrencyは差異として別に説明する必要がある。

### QR-02 正確性

既存testは広い演算例を観測するが、dynamic値とmodulus変更の時間的関係、raw value、invalid input、公開する型集合の契約は未確定である。test isolationの`reset`を利用者契約へ自動昇格しない。

### QR-03 性能効率性

barrett reduction等の実装構造は観測できるが、比較可能なbenchmark、workload、受入水準はない。stress testの存在と今回のskipは性能適合を示さない。

### QR-04 Swift上の安全性

直接pointer storageより、整数overflow、raw value、不正なinverse／pow条件、型ごとの可変static state、concurrencyが中心になる。値の`Sendable`と共有状態への操作安全性を分離できた。

### QR-05 理解可能性

利用者にはstatic／dynamicの違い、`set_mod`の時期と有効範囲、既存値への影響、複数型parameterによる分離、invalid operationが必要情報候補となる。

### QR-06 利用可能性

現行targetでbuild・選択testを実行できた。Int128 availability、DEBUG時のstress skip、concurrency利用条件は提供環境と接続するが未検証である。

### QR-07 持続可能性

本家対応候補、Swift追加test、無効化test、death test、test間reset、型ごとのglobal stateを追跡できる必要がある。個別test台帳の新設までは要求しない。

## 6. モデルへの反証

- pointerを持たない小さな値型でも、QR-04の論点は型外の共有状態から生じ得る。
- `Sendable`とthread-safeな共有操作を同一視しない区分が必要だが、既存QR-04内で扱える。
- test isolationのためのresetは、製品利用時のstate contractを代替しない。
- QR-01とQR-02は、本家のdynamic ID／modulus設計とSwift concurrency上の自己契約を別々に扱った。
- 新しい上位QRを要求する分類不能領域は得られなかった。

## 7. 結論

- ModInt品質判定: **未実施**
- 品質要求への適合判定: **未実施**
- 上位品質モデル改訂: **未実施**
- 第五暫定モデル試験: **レビュー候補**
- 主な反証候補: 値の`Sendable`適合だけでは、型に属する可変global stateを含む操作安全性を説明できない
- 製品判断へ戻す事項: dynamic modulusの時間的・並行的契約、保証する型と演算、性能水準
