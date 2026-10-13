# SCCGraph Quality Model Provisional Trial

> **文書状態:** 第四回の暫定試験記録。品質の本試験、品質アセスメント、適合判定、受入判定ではない。
>
> **実施日:** 2026-10-13
>
> 本試験は、公開APIが小さく、公開wrapper、内部algorithm、内部CSRへ実装責任が分かれるSCCGraphへ上位品質モデルを適用する。SCCGraphの品質合否を判定せず、内部実装の安全性を製品品質へどう接続するか、適用強度を比例させられるかを反証する。

## 1. 対象と境界

### 対象

- `Sources/AtCoder/scc.swift`
- `Sources/AtCoder/internal_scc.swift`
- `Sources/AtCoder/internal_csr.swift` のSCCから利用される経路
- `Tests/AtCoderTests/sccTests.swift`
- `Tests/AtCoderTests/deathTests/sccDeathTests.swift`
- 現行packageの提供構成

### 対象外

- SCCGraphの品質合否
- 本家ac-libraryの製品基準版の選定と網羅的照合
- SCC以外から使われるCSR経路の品質評価
- 実装またはtestの修正
- benchmark設計と外部性能比較
- stack上限、Sanitizer、Linux、Release、`-Ounchecked`、異なるtoolchainでの実験
- API文書の完成度評価

対象外領域でも、モデルの問いと下位要求候補を得るため、証拠の存在・不在を観測する。観測を適合判定へ読み替えない。

## 2. 観測時点と実行環境

- repository commit: `5543a63a3ebf5187966a9d07b3e21ea260dae70c`
- branch: `develop/after2025/1`
- 対象観測開始時の既存file: 上記commitの内容
- macOS: 27.0.1 (Build 26A434)、arm64
- Xcode: 27.0 (Build 27A266a)
- Swift: Apple Swift 6.2 (`swift-6.2-RELEASE`)
- scheme／test plan: `swift-ac-library-Package`
- test target: `AtCoderTests`
- `DEATH_TEST` と `DEBUG`: death testの列挙・成功から、今回の実行では真
- configuration名と最適化level: 独立した設定値として未固定

### 選択test

- `sccDeathTests/testInvalid()`
- `sccTests/testEmpty()`
- `sccTests/testSimple()`
- `sccTests/testSelfLoop()`
- `sccTests/testPractice2()`
- `sccTests/testPractice2Performanc()`

結果は6件成功、失敗0件、skip 0件、not run 0件だった。

- summary: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/B126F90A-6D40-4B67-863A-046670ECB7DF/RunSomeTests/0A6B2DD2-425F-4CD6-9195-9F5F990E0397.txt`
- xcresult: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/B126F90A-6D40-4B67-863A-046670ECB7DF/RunSomeTests/Test-swift-ac-library-Package-2026.10.13_15-55-09-+0900.xcresult`

artifactは一時領域にあり、品質適合の永続証拠ではない。source上で `#if false` のAssignと通常側InvalidもXcodeの一覧には現れたが、実行可能testとして数えない。

## 3. 観測した事実

### 公開wrapper

- `SCCGraph` は `~Copyable` で、空または頂点数指定initializer、`add_edge`、`scc` を公開する。
- 内部graphを保持し、`scc()` は内部algorithmの結果を返す。
- `add_edge` のindex assertは `#if DEBUG` 内にある。
- `init(_ n:)` 自体には非負assertが見当たらない。
- internalな `clone()` はあるが、公開APIではない。
- `@unchecked Sendable` に適合する。

### 内部algorithmとstorage

- internal SCCはedgeをSwift Arrayへ蓄積し、`scc()` ごとにCSRを構築する。
- Tarjan型のDFSは再帰関数として実装される。
- `scc_ids()` は `unsafeUninitializedCapacity`、temporary allocation、pointer初期化・deinitializeを使う。
- CSRは`start`と`elist`を手動allocate／initializeし、`deinit`で破棄・解放する。
- SCCの公開型自身がpointerを直接保持しなくても、公開操作の実行経路は低レベルstorageと再帰処理を含む。
- `scc()` は非mutatingで、保持edgeから局所的なCSRとwork bufferを作る。

### testの現在の観測範囲

- 空graph、2頂点cycle、self-loop、6頂点の具体例を観測する。
- 6頂点例ではcomponent構成だけでなく返却順もassertする。
- death testは `add_edge(0, 10)` のto上限違反を観測する。
- 負の頂点数、負のfrom／to、from上限違反は直接観測していない。
- internal clone、同じgraphへの複数回scc、scc後のedge追加、deep graphの再帰、large graphは直接観測していない。
- performance testは6頂点の `testPractice2()` をmeasure内で繰り返す。外部比較、受入水準、代表規模はない。

## 4. 本家との限定照合

本家ac-libraryのmaster commit `864245a00b00dd008d1abfdc239618fdb7d139da` に固定した。このcommitを製品基準版として採用しない。

- public implementation: `https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/atcoder/scc.hpp`
- internal implementation: `https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/atcoder/internal_scc.hpp`
- test: `https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/test/unittest/scc_test.cpp`
- documentation: `https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_en/scc.md`

限定照合で次を確認した。

- SwiftのEmpty、Simple、SelfLoopは本家同名testと入力・操作・主要assertが対応する。
- Swift death testのto上限違反は本家Invalidと対応する。
- 本家Assignは現行Swiftの `~Copyable` 設計へ直接移植されていない。
- SwiftのPractice2とそのperformance testに対応するtestは、固定した本家unit test file内にはない。名称だけから歴史的由来を断定しない。
- 公開APIのconstructor、add_edge、sccは対応候補である。
- 固定した本家内部実装もTarjan型の再帰DFSとCSRを使い、algorithm構造は近い。
- 本家文書は頂点数とindexの制約、component内順序は未定義、component群はtopological order、構築O(n)、add amortized O(1)、scc O(n+m)を記載する。

test内容と構造上の対応は、Swiftにおけるstack安全性、メモリ安全性、Sendable、非コピー性を証明しない。本家契約をSwift製品の採用済み要求へ自動的に昇格させない。

## 5. 上位品質モデルへの暫定適用

### QR-01 ACL適合性

公開APIの対応候補は明瞭だが、戻り値のtopological order、component内順序、計算量、事前条件まで採用するかは未確定である。Practice2は現在の役割を評価できても、固定した本家unit test由来とは扱えない。

### QR-02 正確性

既存testは基本componentと具体的な返却順を観測する。ただし、現在の順序assertが採用予定の公開契約を表すか、単なる実装観測かは未確定である。複数回実行や変更後再実行も下位候補となるが、一律に大規模caseを増やす判断はしない。

### QR-03 性能効率性

線形時間を意図するalgorithm構造と小規模measureはあるが、計算量成立や実用性能の証拠には不足する。SCCでは頂点数、edge数、graph形状、再帰深さを分けた代表workloadが候補になる。

### QR-04 Swift上の安全性

公開wrapperが単純でも、内部にはunsafe uninitialized Array、temporary pointer、手動CSR storage、再帰DFS、`@unchecked Sendable` がある。安全性領域を公開型のpropertyだけ見て対象外にすると、実行経路のriskを落とす。

一方、SCC固有の確認候補は、buffer初期化数と破棄、edge index、整数演算、deep recursion、Sendableを正当化する不変条件に絞れる。SegTreeのgeneric要素寿命項目をそのまま複製する必要はない。

### QR-05 理解可能性

利用者に重要なのは、頂点とedgeの制約、component内順序、component群のtopological order、計算量、`scc()` 後もgraphを再利用できるかである。内部CSRを説明する必要はないが、その実装都合と公開契約を混同しない必要がある。

### QR-06 利用可能性

現行targetでbuild・testできた。再帰深さやassert無効構成が保証環境へ影響する可能性はあるが、今回は未検証である。Foundation importやCollections依存の要否は、今回の製品品質判定には使わない。

### QR-07 持続可能性

公開wrapper、internal SCC、共有CSR、通常test、death testの接続を追える必要がある。内部CSRの変更はSCC以外へも影響し得るため、file単位だけで変更影響を閉じない。一方、この対象だけの詳細台帳を新設する根拠は得られなかった。

## 6. 品質モデルへの反証

- 公開APIの小ささだけではQR-04を対象外にできなかった。内部実行経路の性質を見る必要がある。
- 安全性確認は必要でも、SegTreeと同じ項目数・証拠量は不要であり、対象固有のriskへ絞れる。
- test名と本家testの直接対応、Swift固有scenario、performance wrapperを由来・役割・証拠限界で分けられた。
- 返却順のassertは、正確性証拠になり得る一方、公開契約が未確定なら偶発的実装固定にもなり得る。test成功から製品判断を逆算しない原則が有効だった。
- 小規模measureの存在を性能適合へ読み替えずに扱えた。
- 今回も主要な関心はQR-01〜QR-07へ暫定配置でき、新しい上位QR候補は得られなかった。

## 7. 結論

- SCCGraphの品質判定: **未実施**
- 品質要求への適合判定: **未実施**
- 上位品質モデルの改訂: **未実施**
- 第四暫定モデル試験: **レビュー候補**
- 主な反証候補: 公開wrapperが単純でも、内部実行経路の低レベル操作と再帰性を品質scopeから落としてはならない
- 次の扱い: 複数の暫定記録をまとめ、重複、比例性、上位モデル修正候補を横断レビューする
