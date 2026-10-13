# Provisional Quality Technical Investigations — 2026-10-14

> **文書状態:** 品質モデル暫定試験から分離した技術調査記録。品質判定、仕様決定、不具合判定、受入判定ではない。

## 1. 観測境界

- repository HEAD: `dfa1381babee15b6c5786c5616fdd027189cf94f`
- worktree: 棚卸し用testとmaintenance文書に未コミット変更あり
- 製品sourceと既存module test: HEADとの差分なし
- macOS 27.0.1 (26A434)、arm64
- Xcode 27.0 (27A266a)
- Swift 6.4 (`swiftlang-6.4.0.34.1`)
- scheme／test plan: `swift-ac-library-Package`
- configuration名と最適化level: 独立には固定していない

実行artifactはXcodeの一時領域にあり、永続的な品質証拠ではない。ここでは現物調査の再開点として、条件、識別子、結果、限界を本文に残す。

Fenwick／SCC棚卸し用test追加後の全件実行は213件中190件成功、9件skip、14件not run、失敗0件だった。100,000頂点probeは意図どおりskipとなった。not runにはsource上で無効化されたtestが含まれるため、実行失敗とは合算しない。この実行後に追加したModInt棚卸し用testは個別実行で成功したが、214件としての全件再実行は行っていない。

- full summary: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/DE84379B-09F4-478B-AF89-E3AB2504E739/RunAllTests/83F70BC4-A790-49D2-94BD-A965CE86514F.txt`
- xcresult: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/DE84379B-09F4-478B-AF89-E3AB2504E739/RunAllTests/Test-swift-ac-library-Package-2026.10.14_03-02-30-+0900.xcresult`

ModInt testとSCC境界probeを整理した後に全件を再実行し、230件中192件成功、24件skip、14件not run、失敗0件だった。skip増加分には、結果を保持しつつ常時実行しないSCC境界probeが含まれる。

- latest full summary: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/DE84379B-09F4-478B-AF89-E3AB2504E739/RunAllTests/B236FD9B-F8BE-4F3C-8BD4-CBB4886EEA4E.txt`
- latest xcresult: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/DE84379B-09F4-478B-AF89-E3AB2504E739/RunAllTests/Test-swift-ac-library-Package-2026.10.14_03-14-13-+0900.xcresult`

## 2. FenwickTreeのgenericゼロ初期化

### 問い

`FenwickTree` は `T.Unsigned` のstorageを `-1` で初期化する。generic制約
`FixedWidthInteger & UnsignedInteger` のもとで、この式が対応storage型をゼロにするという非自明な挙動を、現行toolchainで再観測できるか。

### 保存した調査test

`EtcTests/testInventoryFenwickGenericNegativeOneInitializesUnsignedStorageToZero()` は、`UInt32`、`UInt64`、`UInt`、利用可能な場合の`UInt128`についてgenericな`-1`と`.zero`を比較する。

2026-10-14の選択実行では成功した。これはSwift 6.4の今回の実行における観測であり、次を証明しない。

- Swiftの対応toolchain全体で同じ意味になること
- `-1`を採用する設計理由
- この言語挙動を公開契約または実装不変条件として維持すべきこと
- Releaseまたは`-Ounchecked`で同じ結果になること

現時点では不具合とも仕様とも判定しない。棚卸し時に、実装を明示的な`.zero`へ変えるか、この回帰testを残すか、対応toolchain別に確認するかを製品判断へ返す。

## 3. SCCGraphのCSR再構築と再帰深さ

### CSRと再利用

`EtcTests/testInventorySCCRepeatedEvaluationAndMutationAfterEvaluation()` を追加した。同じgraphへの連続した`scc()`が同じ結果となり、その後の`add_edge`を反映した再評価が行えることを観測する。選択実行は成功した。

このtestは、呼出しごとに構築・破棄されるCSR経路を実行するが、allocator障害、全要素型、Sanitizer、並行実行、全graph形状を検証しない。返却順や再利用を公開契約へ含める判断とも分ける。

### deep recursion

一方向chainを構築し、`scc()`が頂点数と同数のcomponentを返して子processが正常終了することを、process isolation付きの棚卸しtestで段階的に観測した。

最初の100,000頂点では期待した`.success`ではなく **`.signal(SIGBUS)`** だった。その後の境界調査では次を観測した。

- 成功: 100、500、600、700、800、825、850頂点
- `SIGBUS`: 875、900、1,000、2,500、5,000、10,000、25,000、50,000、75,000、100,000頂点

今回のprocess-isolated実行では、成功した最大が850、失敗した最小が875だった。これは製品の最大規模ではなく、今回のtoolchain、build条件、Swift Testingの子process環境を含む観測境界である。

- failed run summary: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/DE84379B-09F4-478B-AF89-E3AB2504E739/RunSomeTests/B9222426-904E-4636-B899-BCF233DE1C9F.txt`
- failed run xcresult: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/DE84379B-09F4-478B-AF89-E3AB2504E739/RunSomeTests/Test-swift-ac-library-Package-2026.10.14_02-55-44-+0900.xcresult`
- 10,000〜75,000 summary: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/DE84379B-09F4-478B-AF89-E3AB2504E739/RunSomeTests/C315EB88-2551-4113-AFB0-C7B70F77C75F.txt`
- 100〜5,000 summary: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/DE84379B-09F4-478B-AF89-E3AB2504E739/RunSomeTests/8D7D5C4F-D8E3-4796-807C-F66C1913897B.txt`
- 600〜900 summary: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/DE84379B-09F4-478B-AF89-E3AB2504E739/RunSomeTests/BCB602B0-66CB-4BED-A8B2-2597D3024D98.txt`
- 825〜875 summary: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/DE84379B-09F4-478B-AF89-E3AB2504E739/RunSomeTests/723E3415-6A7E-446E-8DF6-82FC1D92A2FB.txt`

この結果は再帰DFSとstack上限の関係を疑う反証であるが、signalだけから原因を確定しない。実装上の再帰、入力形状、stack、最適化構成、toolchainの寄与を分離する調査が必要である。

毎回のsuiteを失敗させず調査test数も実行負荷へ直結させないため、850頂点だけを代表成功probeとして有効にした。成功済みの小規模probeと、875以上の失敗probeは理由付きでdisabledとして棚に残した。850と875の選択実行では1件成功、1件skipだった。`SIGBUS`を恒久的な期待値へ固定していない。

- representative summary: `/var/folders/x9/2p70phpx3_xdvwx9s6gp35rm0000gn/T/ActionArtifacts/DE84379B-09F4-478B-AF89-E3AB2504E739/RunSomeTests/96C751B9-DAEA-4F72-8C17-46A557601AD3.txt`

### 次に必要な証拠

- 頂点数を段階的に変えた境界観測
- Debug、Release、`-Ounchecked`の分離
- macOSとLinuxの分離
- backtraceまたはSanitizer等によるsignal原因の確認
- 製品が保証する最大規模と、再帰実装のriskを受容するかの判断

この調査は品質モデルの欠陥ではなく、QR-03、QR-04、QR-06へ接続するSCC固有の下位論点である。

## 4. 現時点の状態

- Fenwick generic literal: 現行Swift 6.4の4型で成功を観測
- SCC repeated evaluation／mutation: 成功を観測
- SCC chain: process-isolated実行で850成功、875以上の観測点で`SIGBUS`
- 製品source修正: 未実施
- 品質判定、不具合判定、risk受容: 未実施
