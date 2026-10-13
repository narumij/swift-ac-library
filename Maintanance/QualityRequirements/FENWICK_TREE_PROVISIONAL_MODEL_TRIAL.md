# FenwickTree Quality Model Provisional Trial

> **文書状態:** 第三回の暫定試験記録。品質の本試験、品質アセスメント、適合判定、受入判定ではない。
>
> **実施日:** 2026-10-13
>
> 本試験は、`QUALITY_REQUIREMENTS_DRAFT.md` の上位品質モデルを、小さなAPI表面を持ちながら数値型変換、overflow、直接メモリ管理を含む対象へ適用する。FenwickTreeの品質を合格・不合格と判定せず、DSU試験で得た比例性の候補と、test由来・現在の役割を分離できるかを反証する。

## 1. 対象と境界

### 対象

- `Sources/AtCoder/fenwicktree.swift`
- `Sources/AtCoder/internal_type_trait.swift` の `ToUnsignedType` 関連部分
- `Tests/AtCoderTests/fenwickTreeTests.swift`
- `Tests/AtCoderTests/deathTests/fenwickTreeDeathTests.swift`
- `Tests/5.8.1/Fenwick/fenwichtree.swift`
- 現行の `Package.swift`、README、CHANGELOGから読み取れる提供構成

### 境界確認だけに用いるもの

- `Tests/ExtraTests/FenwickTree/fenwichtree.swift`
- `Tests/ExtraTests/fenwickTreeTests.swift`

`ExtraTests` targetのFenwickTreeは、`FixedWidthInteger`に限定した差し替え検討版である。core `AtCoder` targetの実装・testとは別の対象として扱い、そこでの成功をcore実装の品質証拠へ合算しない。

### 対象外

- FenwickTreeの品質合否
- 本家ac-libraryの製品基準版の選定と網羅的な仕様照合
- 実装またはtestの修正
- benchmark設計と外部性能比較
- Sanitizer、Linux、Release、`-Ounchecked`、異なるtoolchainでの検証
- 数値protocol設計の確定
- API文書の完成度評価

対象外領域でも、モデルの適用可能性と下位要求候補を調べるため、証拠の存在・不在は観測する。この観測を品質判定へ読み替えない。

## 2. 観測時点と実行環境

### Repository

- commit: `5543a63a3ebf5187966a9d07b3e21ea260dae70c`
- branch: `develop/after2025/1`
- 観測開始時のworktree: clean
- 対象sourceとtest: 上記commitの内容

### Toolchainと実行構成

- macOS: 27.0.1 (Build 26A434)
- architecture: arm64
- Xcode: 27.0 (Build 27A266a)
- Swift: Apple Swift 6.2 (`swift-6.2-RELEASE`)
- scheme／test plan: `swift-ac-library-Package`
- test target: `AtCoderTests`
- build for testing: 成功
- `DEATH_TEST` と `DEBUG` のcompile条件: death testの列挙・成功から、この実行ではともに真だった
- configuration名と最適化level: 独立した設定値としては未固定

### 選択testと結果

次の14件を選択実行した。

- `fenwickTreeDeathTests/testInvalid()`
- `fenwickTreeTests/testEmpty()`
- `fenwickTreeTests/testZero()`
- `fenwickTreeTests/testOverFlowULL()`
- `fenwickTreeTests/testNaiveTest()`
- `fenwickTreeTests/testSMintTest()`
- `fenwickTreeTests/testMintTest()`
- `fenwickTreeTests/testBound()`
- `fenwickTreeTests/testBoundll()`
- `fenwickTreeTests/testOverFlow()`
- `fenwickTreeTests/testInt128()`
- `fenwickTreeTests/testInt()`
- `fenwickTreeTests/testSum()`
- `fenwickTreeTests/testHandleUnsigned()`

結果は14件成功、失敗0件、skip 0件、not run 0件だった。

- summary: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/B126F90A-6D40-4B67-863A-046670ECB7DF/RunSomeTests/7584AD24-6755-4935-8CE2-E1950CD2F9A2.txt`
- xcresult: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/B126F90A-6D40-4B67-863A-046670ECB7DF/RunSomeTests/Test-swift-ac-library-Package-2026.10.13_15-51-14-+0900.xcresult`
- build log: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/B126F90A-6D40-4B67-863A-046670ECB7DF/BuildProject/BuildProject-Log-20261013-155215.txt`

一時領域のartifactは永続証拠ではない。品質証拠へ昇格させる場合は、再実行可能な経路または永続logが必要である。

Xcodeのtest一覧には、source上で `#if false` に囲まれた `testAssign()` と通常側の `testInvalid()` も表示された。これらは今回の選択実行へ含めず、実行可能testの証拠として数えない。列挙結果だけでcompile条件下のtest存在を断定できない例として扱う。

## 3. 観測した事実

### 公開APIと実装

- `FenwickTree<T>` は `~Copyable` で、`T` に `AdditiveArithmetic & ToUnsignedType` を要求する。
- 実storageは `T.Unsigned` の `UnsafeMutablePointer` である。
- 公開操作は空／要素数指定initializer、`add`、区間`sum`、`clone` である。
- prefix sum helperはinternalである。
- `deinit` が `_n` 個をdeinitializeしてpointerを解放する。
- `@unchecked Sendable` に適合する。
- 要素数とindex／rangeの条件は `assert` で検査する。
- 加算・減算はstorage上でwrapping演算を用い、戻り値は `T(bitPattern:)` で復元する。

### 非自明なゼロ初期化

現行initializerはstorageを `.zero` ではなく、次で初期化する。

```swift
data.initialize(repeating: -1, count: n)
```

Swift 6.2で同じ制約を持つ最小式を実行すると、次は `0` を出力した。

```swift
func f<U: FixedWidthInteger & UnsignedInteger>() -> U { -1 }
let x: UInt = f()
print(x) // 0
```

また、現行sourceをbuild for testingした後も、ゼロ初期状態を前提とするnaive、Int、境界testは成功した。したがって、この観測だけから誤初期化とは判定しない。

一方、`-1` がこのgeneric文脈でゼロを生成することはAPI表面から明白ではない。次を未確認事項として残す。

- 対応toolchain全体で同じ意味が保証されるか
- modintを含む各 `Unsigned` 具体型でゼロ初期化になる根拠
- `.zero` ではなく `-1` を使う設計理由
- この前提を実装不変条件、回帰test、または文書のどこで保持するか

これは現時点では反証候補であり、不具合判定でも変更提案でもない。

### 通常testとdeath test

- 空、要素数0、naive range sum、static／dynamic modint、符号付き・符号なしoverflow、Int128、internal prefix sum、unsigned変換を観測する。
- death testは負の要素数、不正なadd index、不正なsum rangeの6条件をprocess exitで観測する。
- 通常fileの無効化された `testInvalid()` コメントと、death testの各条件には直接対応がある。
- core通常testには `clone()` の独立性を直接観測するtestが見当たらない。
- `ExtraTests`側にはclone独立性testがあるが、別実装・別targetのためcoreの証拠へ移さない。
- 性能測定testは確認できない。

### Swift 5.8.1向け別実装

- copyable structで、利用者が `dispose()` を呼ぶ手動解放方式である。
- `T: FixedWidthInteger` で、storage型も `T` である。
- storageは `.zero` で初期化する。
- `clone()` はない。
- 現行package targetには含まれず、製品系列、fixture、配布用sourceのどれかは未確認である。

## 4. 本家との限定照合

本家ac-libraryのmaster commit `864245a00b00dd008d1abfdc239618fdb7d139da` にtest、公開実装、英語文書を固定した。このcommitを製品基準版として採用しない。

- test: `https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/test/unittest/fenwicktree_test.cpp`
- implementation: `https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/atcoder/fenwicktree.hpp`
- documentation: `https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_en/fenwicktree.md`

限定照合で次を確認した。

- SwiftのEmpty、Zero、OverFlowULL、NaiveTest、SMintTest、MintTest、Bound、Boundll、OverFlow、Int128は、本家同名testと入力・操作・主要assertが対応する。
- Swift death testの6条件は、本家Invalidの条件と対応する。
- 本家Assignは、現行Swiftの `~Copyable` 設計には直接移植されていない。
- SwiftのInt、internal Sum、HandleUnsignedに対応するtestは、固定した本家test file内にはない。
- 本家の公開操作はconstructor、`add`、区間`sum` であり、Swift `clone` はこの比較点に対する追加APIである。
- 本家実装はzero-initialized `std::vector<U>` を使う。Swiftは観測上ゼロとなるgenericな `-1` でpointer領域を初期化するため、結果だけでなく実装上の根拠が異なる。
- 本家文書は、初期値0、対象型、`0 <= n <= 10^8`、各事前条件、integer overflow時のmodulo semantics、構築O(n)、add／sum O(log n)を記載する。

対応するtest内容は確認できるが、歴史的な移植元までは証明しない。本家文書の契約と計算量を、Swift製品の採用済み要求へ自動的に昇格させない。

## 5. 上位品質モデルへの暫定適用

### QR-01 ACL適合性

小さなAPIでも、本家対応操作、Swift追加の `clone`、型制約、overflow実現方法、非コピー性を分ける必要があった。testの直接対応が広くても、Swift実装の適合全体は証明しない。

### QR-02 正確性

既存testは対応型とoverflowを含む広い出力例を観測する。一方、公開契約の正本と保証範囲が未確定なため、成功を契約適合とは判定しない。特にclone、対応する具体型集合、初期値0、wrapping semanticsは下位契約候補である。

### QR-03 性能効率性

実装構造から対数時間を意図していると読めるが、性能test、比較対象、受入水準は確認できない。本家記載の計算量をSwift実装の成立証拠へ置き換えない。APIが小さいため、必要なら構築、add、sumの代表workloadに限定できる。

### QR-04 Swift上の安全性

pointer寿命、`~Copyable`、clone独立性、`@unchecked Sendable`、assert無効時の境界に加え、bitPattern変換とgenericなゼロ初期化の不変条件がある。任意要素の破棄はないが、DSUより数値表現上の論点が増えた。

### QR-05 理解可能性

利用者には少なくとも対応型、overflow、range、非コピー性、clone、Sendable境界の意味が必要になり得る。概念が単純でも、Swift固有の数値実現は型宣言だけから十分明白とは限らない。

### QR-06 利用可能性

現行targetはbuild・testできた。Int128 testにはplatform availability分岐があり、対応型と提供環境の境界が接続する。5.8.1版とExtraTests版を現行productへ合算しない。

### QR-07 持続可能性

本家由来と直接対応するtest、Swift固有test、death testへの移行、coreとは異なる代替実装を分離できた。ゼロ初期化のような非自明な不変条件は、短い対象でも変更影響を追跡する理由になる。ただし新しい台帳やID体系が必要とは判断しない。

## 6. 品質モデルへの反証と比例性

- QR-01〜QR-07は今回も異なる問いを扱ったが、各QRへ同量の証拠は不要だった。
- 小さなAPIでも、generic数値表現により正確性・安全性・理解可能性の論点は小さくならない場合がある。
- test件数の多さは、追加APIのclone、性能、公開契約の完成を意味しなかった。
- 本家testとの高い直接対応は由来整理に有用だが、Swift固有実装の根拠を代替しない。
- compile条件で無効なtestが一覧へ現れたため、列挙、実行、skip、not run、source上の無効化を区別する必要がある。
- 代替実装のtestは、同名型であっても対象scopeを確認してから証拠として扱う必要がある。

今回、新しい上位QRを要求する分類不能領域は得られなかった。非自明な言語挙動はQR-02、QR-04、QR-05、QR-07から異なる問いとして扱える。

## 7. 結論

- FenwickTreeの品質判定: **未実施**
- 品質要求への適合判定: **未実施**
- 上位品質モデルの改訂: **未実施**
- 第三暫定モデル試験: **レビュー候補**
- 主な反証候補: 小さなAPIでも、型変換と言語依存の不変条件により、test成功だけでは保守可能な品質根拠にならない
- 次の扱い: 他の性質を持つ対象にも横展開し、複数記録をまとめてレビューする
