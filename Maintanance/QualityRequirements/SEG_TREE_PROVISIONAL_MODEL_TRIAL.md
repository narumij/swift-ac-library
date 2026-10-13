# SegTree Quality Model Provisional Trial

> **文書状態:** 暫定試験記録。品質の本試験、品質アセスメント、適合判定、受入判定ではない。
>
> **実施日:** 2026-10-13
>
> 本試験の目的は、`QUALITY_REQUIREMENTS_DRAFT.md` の上位品質モデルを現物へ試験適用し、区分の重複、不足、評価不能箇所、および下位要求候補を発見することである。SegTreeの品質を合格・不合格と判定しない。

## 1. 対象と境界

### 対象

- `Sources/AtCoder/segtree.swift`
- `Tests/AtCoderTests/segtreeTests.swift`
- `Tests/AtCoderTests/etc/SegTreeOperationTests.swift`
- `Tests/AtCoderTests/deathTests/segTreeDeathTests.swift`
- `Tests/5.8.1/SegTree/segtree.swift`
- `Tests/TopLevel/main.swift` のSegTree関連部分
- 現行の `Package.swift`、README、CHANGELOGから読み取れる提供構成

### 対象外

- SegTreeの品質合否
- 本家ac-libraryとの行単位または仕様単位の照合
- benchmark設計および性能比較
- Sanitizer、Linux、異なるSwift toolchain、Release、`-Ounchecked`での検証
- API文書の完成度評価
- 実装またはテストの修正

対象外とした品質判定についても、品質モデルの適用可能性と下位要求候補を調べるため、証拠の存在・不在は観測する。その観測を完成度評価または適合判定へ読み替えない。

本家ac-libraryの基準版、原典の実装、および原典テストは今回照合していない。そのため、コードやコメントが本家に由来して見える場合でも、出所と対応範囲は未確認とする。

## 2. 観測時点と実行環境

### Repository

- commit: `c7b20bc5873530be3fcc3ea0506a1dbf1cb6d5c6`
- branch: `develop/after2025/1`
- upstreamとの差: `origin/develop/after2025/1` より5 commit先行
- worktree: cleanではない
- 対象とした `Sources/AtCoder/segtree.swift` および列挙したテスト・fixtureには、再実行時点でHEADとの差分はなかった。
- 未コミット変更はmaintenance文書群と `AGENTS.md` に存在した。品質要求原案と本暫定試験記録も未コミット変更に含まれる。

最初の限定実行より後にmaintenance文書の編集が続いたため、最初の実行時点のworktree全体を完全には遡及固定できない。本節の環境と証拠は、レビュー後に同じ11件を再実行した時点のsnapshotである。対象ソースおよび対象テストに差分がないことは再実行前に確認したが、これを最初の実行時点の完全な再現とは扱わない。

### Toolchainと実行構成

- macOS: 27.0.1 (Build 26A434)
- architecture: arm64
- Xcode: 27.0 (Build 27A266a)
- Swift: Apple Swift 6.2 (`swift-6.2-RELEASE`)
- Swift CLI target: `arm64-apple-macosx28.0`
- scheme: `swift-ac-library-Package`
- test plan: `swift-ac-library-Package`
- test target: `AtCoderTests`
- test actionで `segTreeDeathTests/testInvalid()` が列挙・実行されたことから、`#if DEATH_TEST && DEBUG` はこの実行で有効だった。
- `DEATH_TEST` は `Package.swift` によりmacOSで定義される。
- Xcode toolからtargetのbuild settingsを取得できず、configuration名と最適化levelは独立した設定値として固定できなかった。death testのコンパイル・成功は `DEBUG` 条件が真だった証拠だが、設定記録の代替にはしない。

### 選択試験と証拠

再実行したtest identifierは次の11件である。

- `segTreeDeathTests/testInvalid()`
- `SegTreeOperationTests/testExample()`
- `SegTreeOperationTests/testPerformanceExample()`
- `segtreeTests/test0()`
- `segtreeTests/testInvalid()`
- `segtreeTests/testOne()`
- `segtreeTests/testCompareNaive()`
- `segtreeTests/testClone()`
- `segtreeTests/test0_0()`
- `segtreeTests/testOne_0()`
- `segtreeTests/testCompareNaive_0()`

実行結果は10件成功、1件skip、失敗0件、not run 0件だった。

- summary: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/E996884C-6ED3-451F-9254-9500C1D5D3AB/RunSomeTests/A5655891-F51E-4790-B900-1DC1479966B2.txt`
- xcresult: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/E996884C-6ED3-451F-9254-9500C1D5D3AB/RunSomeTests/Test-swift-ac-library-Package-2026.10.13_15-00-13-+0900.xcresult`

これらは一時領域上の実行artifactであり、repository内の永続証拠ではない。将来の再検証で同じpathが利用できることを保証しない。

## 3. 観測した事実

### 公開APIと実装

- `SegTreeOperator` は要素型、二項演算、単位元を要求する。
- `SegTreeOperation` は `@Sendable (S, S) -> S` の関数プロパティから演算を提供するSwift固有の表現を持つ。
- `SegTree` は `~Copyable` で、内部要素を `UnsafeMutablePointer` へ直接保持する。
- `deinit` は確保した全要素をdeinitializeしてから領域を解放する。
- 空、要素数、配列、任意の `Collection`、一部のrange、および要素生成closureから初期化できる。
- `set`、`get`、`prod`、`all_prod`、`max_right`、`min_left` を公開する。
- 明示的な複製操作として `clone()` を公開する。
- `SegTree` は `@unchecked Sendable` に適合する。
- 引数条件は主に `assert` で検査する。
- 要素生成closureを使う初期化には「ベンチマーク用」というコメントがあるが、public APIとして公開されている。

### 旧Swift向け別実装

- `Tests/5.8.1/SegTree/segtree.swift` には、現行実装とは別のコピー可能な型が置かれている。
- 同実装には `deinit` がなく、利用者による `dispose()` が必要で、二回以上呼べない旨が記載されている。
- このファイルが製品系列、互換性fixture、配布物、または単なる検証資産のどれに当たるかは、今回確認した文書だけでは確定できない。

### テスト

- 通常テストは、空・単一要素、更新、区間積、境界探索、naive実装との比較、`clone()` 後の独立性、要素生成closureを確認する。
- 通常テストの不正入力試験は `Swift Testingで実施` としてskipされる。
- macOSで `DEATH_TEST` と `DEBUG` のcompile条件が有効な場合、Swift Testingのprocess exit確認によるdeath testが有効になる。今回の実行では対象testの列挙・成功から両条件が真だったと確認したが、configuration名と最適化levelは独立には固定できなかった。
- `TopLevel` ターゲットは、operator定義を含む利用コードがトップレベルでコンパイルできることを確認する。
- `SegTreeOperationTests.testExample` は型の構築のみを行う。
- `SegTreeOperationTests.testPerformanceExample` の測定closureは空であり、性能特性を観測していない。

### 今回の限定再実行

Xcodeの `swift-ac-library-Package` schemeでSegTree関連11件を選択して実行した。

- 成功: 10件
- 失敗: 0件
- skip: 1件
- not run: 0件

skipは通常側の `segtreeTests.testInvalid()` で、対応する条件付きdeath testは今回の構成では成功した。

この結果は、選択したテストが現在の一構成で記録どおり終了したことだけを示す。性能、安全性、他環境との互換性、またはSegTree全体の品質適合を示さない。特に空のperformance testの成功を性能証拠として扱わない。

## 4. 上位品質モデルへの暫定適用

### QR-01 ACL適合性

名称とAPI表面から本家との対応候補と推定される操作が存在する。ただし基準版と原典を照合していないため、対応関係、事前条件の一致、および適合性は未確認である。

この適用から、少なくとも次の下位情報が必要だと分かる。

- 基準とする本家の版またはcommit
- 対応する本家の型、操作、事前条件、計算量
- Swift固有に追加・変更・除外したAPI
- range初期化、closure初期化、`clone()`、非コピー性などの位置づけ

QR-01は「本家と同じ結果になるか」だけでなく、「どの公開面を対応対象とするか」を先に必要とする。

### QR-02 正確性

naive実装との比較は `prod`、`max_right`、`min_left` の結果を広く観測している。`clone()` の独立性も個別に観測されている。

一方、公開契約の正本と保証範囲が確定・集約されておらず、現存するpublic宣言、型制約、コメント、検査、README、テスト、および互換性方針がどの契約を構成するか確認できないため、テスト成功を契約適合と判定できない。独立した契約文書の作成を、契約成立の必須条件として先取りしない。特に次が未確定である。

- monoidに要求する法則と、その違反を誰の責任とするか
- predicateに要求する単調性など、境界探索の前提条件
- range初期化が受理する具体的な型と、その他の `RangeExpression & Collection` をassertで拒否する契約
- 不正入力時にDebugでtrapし、assertが無効な構成では検査されない可能性をどう公開するか
- 「ベンチマーク用」のpublic initializerを製品APIとして保証するか

QR-01とQR-02の区別は今回の対象でも有効だった。本家との差異候補を見つけることと、Swift側が自ら定めた契約を満たすことは別に評価する必要がある。

### QR-03 性能効率性

実装は配列状の連続領域と反復処理を使い、基本操作の計算量を意識した構造に見える。しかし、今回確認した資産には受入可能な性能証拠がない。

空のperformance testは、性能評価の存在を示す名前を持つが性能を観測しない。この事例から、テスト名や成功状態ではなく、workloadと測定内容を確認する必要性が裏付けられた。

下位要求では、少なくとも構築、`set`、`prod`、境界探索、メモリ使用量、allocation、および入力規模を区別する必要がある。

### QR-04 Swift上の安全性

SegTreeでは、直接メモリ管理、`~Copyable`、明示的な `clone()`、`@unchecked Sendable` が同時に存在し、QR-02の出力上の正確性だけでは扱えない所有権、寿命、複製、およびconcurrencyの論点をQR-04によって分離できた。今回の適用では、QR-04を他の区分へ統合できる根拠は得られなかった。

ただし、コードレビューだけでは次を確認済みとできない。

- すべての初期化経路で全capacityの要素寿命が正しく開始・終了すること
- 各initializerで、初期化済み要素数とdeinitialize対象が一致すること
- 初期化途中で正常完了しない経路が存在する場合、その経路で初期化済み要素が適切に破棄されること
- `clone()` が任意の `S` で正しい独立性を持つこと
- `@unchecked Sendable` を正当化する不変条件
- concurrency domain間で値を受け渡す条件
- mutable storageへのaliasまたは共有が成立し得るか
- 同一instanceへの並行アクセスを公開契約として許可するか
- 並行アクセスを許可しない場合、型・所有権・利用者事前条件のどこで防ぐか
- assertが無効な構成で、不正入力がメモリ安全性へ与える影響
- 現行実装とSwift 5.8.1向け別実装で異なる所有権・解放契約を、利用者へどう分離して提示するか

今回の適用により、QR-04の下位要求は「メモリ安全性」だけでなく、所有権、複製、並行性、構成別事前条件、および互換系列別の寿命管理へ分解する必要があると分かった。

### QR-05 理解可能性

公開APIの多くには利用者向けdoc commentがなく、READMEにもSegTree固有の契約、計算量、使用例、および本家との差異は記載されていない。

`TopLevel`のコードは利用可能な記述例を含むが、コンパイルfixtureであり、そのまま利用者向け文書とはみなせない。

次の説明単位が必要になる可能性がある。

- operator型の二つの定義方法
- 非コピー型と `clone()`
- 各initializerの使い分け
- indexと半開区間
- `max_right`、`min_left` のpredicate条件
- 計算量
- 事前条件違反の扱い
- `@unchecked Sendable` の意味と利用条件
- 本家と異なるSwift固有API

### QR-06 利用可能性

現行SwiftPM target、トップレベルのcompile fixture、およびSwift 5.8.1向け別コードは、複数の利用環境を意識した資産と観測できる。

しかし、Swift 5.8.1向けファイルが現在の製品提供範囲にどう接続するか、現行の推奨系列と同じAPI・安全性を保証するかは不明である。現行 `Package.swift` のSwift tools versionは6.2であり、対象ファイルは通常のpackage targetには含まれていない。

このため、Git branchそのものより、提供する版・互換系列ごとにtoolchain、導入方法、API差異、安全性、および検証経路を定めるという原案の明確化が有効だった。

### QR-07 持続可能性

本家との対応候補と推定される操作、Swift固有API、旧Swift向け別実装、naive比較、death test、compile fixtureが複数箇所に分散している。変更影響を追跡するには、原典照合後に由来と役割を識別する必要がある。

一方、識別情報をどの文書またはコードへ置くべきかは製品コードの保守可能性だけでは決まらない。これは品質情報を次工程へ接続する運用能力に属する部分があるため、QR-07の二層化は今回の対象でも有効だった。

運用能力を製品品質要求に含めるかは、この暫定試験では決定しない。

## 5. 品質モデルへの反証と不足候補

### 現時点で維持できた区分

- QR-01とQR-02は、本家との差異とSwift側の自己契約という別々の問いを扱った。今回の適用では、一方を他方へ統合できる根拠は得られなかった。
- QR-03は計算量上の対応だけでは代替できず、実測性能を別に扱う必要があった。
- QR-04は、正しい出力だけでは扱えない所有権、寿命、並行性、および構成差を受け持った。
- QR-05とQR-06は、APIと保証境界の理解可能性と、実際の導入・build可能性という別々の問いを扱った。今回の適用では、一方を他方へ統合できる根拠は得られなかった。
- QR-07の製品保守可能性と運用能力の区別は、分散した品質資産を扱う際に有効だった。

### 不足または分解が必要な候補

上位QRを直ちに追加すべきという結論ではないが、下位要求では次の観点が必要になる。

- 公開API面と保証対象API面の識別
- 本家由来と確認された部分、Swift固有部分、互換系列固有部分の差異管理
- 非コピー性、明示的複製、および要素型 `S` の所有権要件
- `@unchecked Sendable` の根拠、domain間の受渡し、storage共有、および並行アクセス契約の区別
- assert、death test、最適化構成の関係
- publicだが用途限定とされるAPIの保証範囲
- API単位の計算量と性能workload
- toolchain系列ごとに異なる解放・寿命契約
- 文書、compile fixture、正確性試験、性能試験を証拠種別として区別する方法

これらを上位品質要求へ追加するか、SegTreeの下位品質プロファイルまたは公開仕様へ置くかは未決とする。

## 6. Validationへの暫定適用

SegTreeには、公開前の代理Validationとして利用できる可能性がある材料がある。

- `TopLevel`による利用記述のcompile確認
- 本家との対応確認後に代理Validation候補となり得るoperator型
- Swift固有の関数プロパティ型によるoperator定義
- Swift Package consumer fixture候補
- 競技提出による実環境確認候補

今回実施したのは既存テストの限定再実行であり、これらのValidationは実施していない。特にcompile成功、単体テスト成功、実際の競技利用、および一般Swift Package利用は互いの代替証拠ではない。

## 7. 暫定試験の結果

上位品質モデルは、SegTreeの現物を複数の異なる品質問題へ分解するために利用できた。QR-01〜QR-07のいずれかを、この一回の適用だけで不要または統合可能とは判断できなかった。

同時に、上位QRだけでは適合判定できず、公開契約、基準とする本家、提供系列、構成別保証、安全性根拠、性能workload、および証拠種別を下位で具体化する必要があることが確認された。

この結果は品質モデルの正しさを証明しない。SegTreeという一対象で明白な破綻を発見できなかったことと、下位要求候補を抽出できたことだけを示す。

### 結論

- SegTreeの品質判定: **未実施**
- 品質要求への適合判定: **未実施**
- 上位品質モデルの正本化判断: **対象外**
- 暫定モデル試験: **継続可能**
- 次に必要な判断: この観測を踏まえて原案をさらに改訂するか、別の機能へ暫定適用して反証範囲を広げるか
