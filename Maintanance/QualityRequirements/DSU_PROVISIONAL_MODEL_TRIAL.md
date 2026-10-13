# DSU Quality Model Provisional Trial

> **文書状態:** 第二回の暫定試験記録。品質の本試験、品質アセスメント、適合判定、受入判定ではない。
>
> **実施日:** 2026-10-13
>
> 本試験の目的は、`QUALITY_REQUIREMENTS_DRAFT.md` の上位品質モデルを比較的単純な対象へ適用し、過剰な要求や管理負荷を生まないか、適用不要な領域を適切に扱えるかを反証することである。DSUの品質を合格・不合格と判定しない。

## 1. 対象と境界

### 対象

- `Sources/AtCoder/dsu.swift`
- `Tests/AtCoderTests/dsuTests.swift`
- `Tests/5.8.1/DSU/dsu.swift`
- 現行の `Package.swift`、README、CHANGELOGから読み取れる提供構成

### 境界確認のため観測するが、core DSUの評価対象には含めないもの

- `Tests/ExtraTests/DSU/weighted.swift`
- `Tests/ExtraTests/weightedTests.swift`

これらは `ExtraTests` target内のweighted DSU別実装である。名称が同じ `DSU` でも、`AtCoder` productのcore DSUと同一の製品対象または品質証拠とはみなさない。

### 対象外

- DSUの品質合否
- 本家ac-libraryの製品基準版を選定した網羅的な仕様照合
- weighted DSUの品質評価
- benchmark設計および外部性能比較
- Sanitizer、Linux、異なるSwift toolchain、Release、`-Ounchecked`での検証
- API文書の完成度評価
- 実装またはtestの修正

対象外とした品質判定についても、品質モデルの適用可能性と下位要求候補を調べるため、証拠の存在・不在は観測する。その観測を完成度評価または適合判定へ読み替えない。

本家ac-libraryの製品基準版は選定していない。由来整理とモデル適用の予備確認として、後述する本家repositoryの一commitへtest、公開実装、英語文書を固定して限定照合した。このcommitを本製品の基準版とはみなさない。

## 2. 観測時点と実行環境

### Repository

- commit: `d76c42b96226059ad4f9810fe1dcbf758f45ec7d`
- branch: `develop/after2025/1`
- upstreamとの差: `origin/develop/after2025/1` より10 commit先行
- worktree: 対象確認とtest実行の開始時点でclean
- 対象source、test、fixtureはすべて上記commitの内容

### Toolchainと実行構成

- macOS: 27.0.1 (Build 26A434)
- architecture: arm64
- Xcode: 27.0 (Build 27A266a)
- Swift: Apple Swift 6.2 (`swift-6.2-RELEASE`)
- Swift CLI target: `arm64-apple-macosx28.0`
- scheme: `swift-ac-library-Package`
- test plan: `swift-ac-library-Package`
- test target: `AtCoderTests`
- `dsuTests/test0()` は `#if DEBUG` 内で列挙・実行されたため、この実行では `DEBUG` 条件が真だった。
- configuration名と最適化levelは独立した設定値として固定できていない。

### 選択testと証拠

実行したtest identifierは次の6件である。

- `dsuTests/test0()`
- `dsuTests/testSimple()`
- `dsuTests/testLine()`
- `dsuTests/testLineReverse()`
- `dsuTests/testPerformance()`
- `dsuTests/testClone()`

実行結果は6件成功、失敗0件、skip 0件、not run 0件だった。

- summary: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/B126F90A-6D40-4B67-863A-046670ECB7DF/RunSomeTests/315C312C-6B81-45DD-B711-D6CB2639BFFF.txt`
- xcresult: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/B126F90A-6D40-4B67-863A-046670ECB7DF/RunSomeTests/Test-swift-ac-library-Package-2026.10.13_15-37-41-+0900.xcresult`

これらは一時領域上のartifactであり、repository内の永続証拠ではない。品質適合の証拠へ昇格させる場合は、永続logまたは再実行可能な検証経路が別途必要になる。

## 3. 観測した事実

### 公開APIと実装

- `DSU` は `~Copyable` で、`Int`要素の状態を `UnsafeMutablePointer<Int>` に保持する。
- union by sizeとpath compressionを実装する旨、および参考文献がfile冒頭に記載されている。
- 空または要素数を指定して初期化できる。
- `merge`、`unite`、`same`、`leader`、`size`、`groups`、`clone`、`reset` を公開する。
- queryに見える `same`、`leader`、`size`、`groups` もpath compressionのため `mutating` である。
- `deinit` は `_n` 個をdeinitializeしてpointerを解放する。
- `clone()` は別領域へ `_n` 個の `Int` を複製する。
- `DSU` は `@unchecked Sendable` に適合する。
- index条件は `assert` で検査する。
- `init(_ n:)` には、SegTreeの `_count` initializerにあったような非負assertが見当たらない。

最後の点は不具合判定ではない。負の値を公開契約でどう扱うか、assertが無効な構成でどうなるかを確認する問いである。

### 通常test

- 空DSUの内部buffer、2要素の基本操作、50万要素の順方向・逆方向merge、`groups()`、`clone()` の独立性、10万要素のrandom pair merge測定を含む。
- `testPerformance()` は測定closure内でDSU構築とmergeを実行する。random pairの生成は測定closure外である。
- `unite()` と `reset()` を直接呼ぶtestは、確認した `dsuTests.swift` には見当たらない。
- 不正indexまたは負の要素数に対するdeath testは、確認したDSU test群には見当たらない。
- `groups()` は大規模line testでgroup数1を確認するが、複数groupの要素構成や順序の契約は直接観測していない。
- repository履歴では、`unite()` と `reset()` はcommit `c7b20bc5873530be3fcc3ea0506a1dbf1cb6d5c6` で追加された。同commitに `Tests/AtCoderTests/dsuTests.swift` の変更は含まれていない。

最後の履歴は、両APIにtestが存在しないことや品質が不足することを単独で証明しない。少なくとも、public API追加と同時に対応testが追加されたとは確認できない、という範囲の証拠である。

### 本家testとの限定照合

本家ac-libraryの `test/unittest/dsu_test.cpp` を、masterのcommit `864245a00b00dd008d1abfdc239618fdb7d139da` に固定して比較した。

- 参照先: `https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/test/unittest/dsu_test.cpp`
- Swiftの `testSimple()` は、入力、操作列、主要assertが本家の `Simple` と対応する。
- Swiftの `testLine()` と `testLineReverse()` は、要素数、merge順、sizeとgroup数のassertが本家の同名testと対応する。
- 本家の `Zero` と `Empty` は `groups()` の空結果を確認する。Swiftの `test0()` は `#if DEBUG` で内部bufferの空を確認しており、観測対象が同じではない。
- 本家の `Assign` は代入を確認する。現行Swift `DSU` は `~Copyable` であり、確認した通常testに同等の代入testはない。
- Swiftの `testPerformance()` と `testClone()` に対応するtestは、固定した本家file内にはない。

この照合はtest内容の直接対応を確認するもので、Swift testがどのcommitでどの原典から移植されたかという履歴上の由来までは証明しない。また、本家masterのこのcommitを互換性基準として採用する判断でもない。

### 本家公開実装・文書との限定照合

同じcommitの `atcoder/dsu.hpp` と `document_en/dsu.md` を固定して、公開API表面と記載された契約を限定比較した。

- 実装: `https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/atcoder/dsu.hpp`
- 文書: `https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_en/dsu.md`
- 固定した本家実装には、constructor、`merge`、`same`、`leader`、`size`、`groups` がある。Swift側にも対応候補となる公開操作がある。
- 固定した本家実装・文書には、Swift側の `unite`、`reset`、`clone` に対応する公開APIはない。したがって、これらは少なくともこの比較点に対するSwift側追加APIである。
- 本家文書はconstructorに `0 <= n <= 10^8` の制約を置き、各操作の計算量を記載する。Swift側の `init(_ n:)` には明示的な非負assertが見当たらないが、基準版とSwift側契約を未決のまま不具合とは判定しない。
- 本家文書は `groups()` のcomponent順と各component内の要素順を未定義とする。現在のSwift testも複数groupの順序契約を確立していない。

この比較によりAPI差異と下位要求候補は具体化できるが、製品基準版の採用、全仕様の一致、計算量の実測、Swift固有契約の妥当性は確認しない。本家文書の制約や計算量を、そのままSwift製品の採用済み要求へ昇格させない。

### Swift 5.8.1向け別実装

- 現行実装と異なりコピー可能なstructで、`deinit`を持たず、利用者が `dispose()` を呼ぶ必要がある。
- `unite()`、`clone()`、`reset()` は含まれない。
- `_leader` は再帰実装であり、現行実装は反復処理でpath compressionを行う。
- このfileが製品系列、互換性fixture、配布用source、または別の検証資産のどれに当たるかは未確認である。

### weighted DSUという隣接資産

- `ExtraTests` target内に、weight差を保持する別の `DSU` 実装と6件のtestがある。
- AtCoder contest submissionへのURLがコメントにある。
- core DSUとはAPIと内部storageが異なり、`AtCoder` targetのsourceではない。
- 今回は存在と境界だけを観測し、core DSUの品質証拠へ合算しない。

## 4. 上位品質モデルへの暫定適用

### QR-01 ACL適合性

固定した一commitとの限定照合により、`Simple`、`Line`、`LineReverse` のtest内容には直接対応が確認できた。また、constructor、`merge`、`same`、`leader`、`size`、`groups` は公開API上の対応候補、`unite`、`reset`、`clone` はこの比較点に対するSwift側追加APIと確認できた。一方、製品基準版は未確定であり、全仕様、Swift固有の事前条件、計算量の成立、およびtest由来全体の対応関係は未確認である。

DSUでは、少なくとも次を区別する必要がある。

- 固定した比較点で本家対応候補と確認した操作
- 固定した比較点に対するSwift側追加と確認した `unite()`、`reset()`、`clone()`
- mutating queryや非コピー性などSwift型としての差異
- Swift 5.8.1向け別実装との差異

SegTreeよりAPIは小さいが、QR-01の問いを省略できる根拠は得られなかった。一方、APIごとの短い対応表で扱える可能性があり、同じ量の記録を要求する必要もない。

### QR-02 正確性

基本的なmerge、leader、same、size、単一group、clone独立性はtestで観測されている。大規模な直線mergeは、単純な小入力以外の動作も観測する。

公開契約の正本と保証範囲は確定・集約されていないため、test成功を契約適合とは判定しない。下位では次の問いが残る。

- `merge()` が返すleaderと、同サイズmerge時のroot選択を保証するか
- `unite()` のBool結果と状態遷移
- `reset()` 後の全操作
- `groups()` のgroup順・要素順を保証するか
- 空、負の要素数、不正indexの契約
- path compressionによりqueryがmutatingであることを公開契約としてどう説明するか

単純な対象でも、存在する全public APIを同じtestが覆うわけではない。ただし各APIへ個別の大規模testを機械的に要求する根拠もなく、契約上の差とriskに応じた粒度が必要である。

### QR-03 性能効率性

50万要素のline testと10万要素の測定testがある。測定testは空ではなく、DSU構築とrandom pairのmergeを測定する。

ただし比較対象、環境固定、入力seed、受入水準、回帰baselineが定まっていないため、QR-03適合は評価不能である。union by sizeとpath compressionという実装方針や大入力testの成功を、実用性能または本家相当性能の証拠へ直接置き換えない。

DSUの下位性能要求は、構築、merge／unite、leader／same、groups、およびmemory使用量を区別し得る。ただし製品利用上重要でない操作へ同じ測定強度を課すと過剰になるため、代表workloadの選定が先に必要である。

### QR-04 Swift上の安全性

DSUでも直接メモリ管理、`~Copyable`、`clone()`、`@unchecked Sendable`、assertによる事前条件があり、出力上の正確性と別の問いを処理できた。

一方、storage要素は固定された `Int` であり、任意のgeneric要素を保持するSegTreeより要素寿命の論点は限定される。SegTreeで列挙した安全性確認をそのまま全件複製する必要はない。

確認候補は次の通りである。

- `_n` とallocation、初期化数、deinitialize数の一致
- `clone()` のstorage独立性
- `@unchecked Sendable` を正当化する不変条件
- concurrency domain間の受渡しと、同一instanceの共有・並行アクセスの区別
- assertが無効な構成での負の要素数と不正index
- Swift 5.8.1向け実装の手動解放とコピーalias

今回の適用では、安全性領域を対象外にはできなかったが、対象の型と実装に応じて問いを減らす必要があると分かった。

### QR-05 理解可能性

file冒頭にはアルゴリズム方式と参考文献があるが、各public APIの利用者向けdoc comment、計算量、事前条件、順序保証、非コピー性、`clone()`、`reset()`、Sendable境界の説明は確認できない。

完成度評価は行わない。下位要求候補を得るため、情報の所在と不在だけを観測した。

DSUは概念が単純なため、SegTreeほど長いAPI説明を当然には要求しない。一方、Swift固有の所有権、mutating query、追加API、失敗境界は、概念の単純さだけでは利用者に伝わらない。

### QR-06 利用可能性

現行SwiftPM targetのtestは実行できた。Swift 5.8.1向け別sourceも存在するが、現行package targetには含まれず、導入・解放・APIの契約が現行版と異なる。

weighted DSUが `ExtraTests` に存在することは、productがweighted DSUを提供することの証拠ではない。targetと配布物の境界を確認するだけで、隣接資産を製品scopeへ自動的に含めずに済んだ。

### QR-07 持続可能性

core実装、通常test、Swift 5.8.1向け別実装、weighted実験が分かれているため、由来と役割の識別は必要である。ただしSegTreeより公開概念とtest群が小さく、機能ごとの詳細台帳を新設する必要性は観測できなかった。

直近commitでpublic APIが追加され、同commitでは通常testが変更されていないことから、変更影響を確認する入口は必要である。ただし、commitごとの機械的なtest追加義務をここから導かず、既存test・仕様・利用例が追加APIを観測するかを確認する。

変更影響の確認には、core、互換source、実験を区別する最小限の対応関係で足りる可能性がある。QR-07の運用能力を、対象規模にかかわらず同じ文書量で要求すると過剰になる。

## 5. 品質モデルへの反証と比例性

### 今回別々に扱えた問い

- QR-01とQR-02は、本家との対応候補とSwift製品自身の公開契約を別々に扱った。今回、一方へ統合できる根拠は得られなかった。
- QR-03は、アルゴリズム方式や大入力testと、比較可能な性能評価を分けた。
- QR-04は、出力の正確性だけでは扱えないpointer、所有権、Sendable、構成別事前条件を扱った。
- QR-05とQR-06は、理解に必要な情報と、実際のtarget・toolchain・導入経路を分けた。
- QR-07は、複数の類似資産を製品scopeへ誤って合算しないための追跡可能性を扱った。

### 過剰要求を避けるために得られた候補

- すべてのQRを確認対象にはしても、すべてへ同量・同種類の証拠を要求しない。
- 「論点が少ない」「対象が単純」「対象外」「確認済み」を区別する。
- public APIのrisk、差異、利用頻度に応じてtestと文書の粒度を変え得る。
- generic要素を持たないDSUへ、SegTreeと同じ要素寿命testを機械的に要求しない。
- 隣接する実験実装を、名称だけで製品scopeまたはcore品質証拠へ含めない。
- 小さな対象のために個別台帳や新しいID体系を作らず、必要なら短い対応表またはtest群単位で管理する。

これらは上位モデルの即時修正を要求する結論ではない。今後の下位要求や試験適用で、比例性を保つ解釈として再確認する候補である。

### 分類できなかった関心

今回観測した主要な関心はQR-01〜QR-07のいずれかへ暫定的に置けた。分類不能を理由とする新しい上位QR候補は得られなかった。

ただし、どの系列・target・sourceが製品提供対象かは、各QR以前の評価scope決定でもある。QR-06とQR-07だけへ押し込まず、下位試験の入口で対象を固定する必要がある。

## 6. Validationへの暫定適用

公開前の代理Validation候補として、次が考えられる。

- core APIを使う最小consumer fixture
- 実際の競技提出
- 大入力での代表的なconnectivity workload
- Swiftの所有権制約を含む利用例

今回実施したのは既存unit／performance testの限定実行であり、上記Validationは実施していない。weighted DSUのcontest submission URLもcore DSUのValidationへ流用しない。

## 7. 暫定試験の結果

DSUへの適用では、QR-01〜QR-07の各区分が少なくとも異なる問いを扱った一方、SegTreeと同じ詳細度の証拠や記録を要求する必要はなかった。

この結果は、上位モデルが比例的に運用できる可能性を支持するが、過剰負荷がないことを証明しない。実際の下位要求作成や品質評価を行っておらず、必要作業量を測定していないためである。

隣接するweighted実装とSwift 5.8.1向けsourceの存在は、評価scopeを先に固定する必要性を示した。単純な型でも、名称だけで品質資産を合算すると誤る可能性がある。

### 結論

- DSUの品質判定: **未実施**
- 品質要求への適合判定: **未実施**
- weighted DSUの評価: **未実施**
- 上位品質モデルの改訂: **未実施**
- 第二暫定モデル試験: **レビュー可能**
- 得られた主な反証候補: QRを一律の証拠量・文書量で適用すると、小さな対象へ過剰負荷を生み得る
- 次に必要なこと: この記録の論理、証拠境界、比例性の主張についてレビューを受け、上位モデルへ反映するかはその後に別判断する
