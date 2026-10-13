# Quality continuation local contract — 2026-10-14

## Goal

品質モデル暫定試験から生じた残作業を分類し、製品判断を先取りせずに実施できる技術調査を進め、性質の異なる一対象へ追加適用した結果をレビュー可能な状態で残す。

## Authority and role

- Receiverが直接実施し、Workerへの委任は行わない。
- ユーザーの最新指示は、残作業と横展開を可能な範囲で自走することである。
- `Maintanance/User/`、製品source、上位品質要求は変更しない。
- 2026-10-14の追加指示により、調査testは棚卸し用の
  `Tests/AtCoderTests/EtcTests.swift` と `Tests/AtCoderTests/DeathTest.swift` に残してよい。
- branch操作、commit、push、merge、rebaseは行わない。commitは別途ユーザー指示を待つ。

## Scope

- FenwickTreeのgenericゼロ初期化について、現行toolchainと既存証拠で説明できる範囲を技術調査する。
- SCCGraphのdeep recursionとCSRについて、現物からrisk、未確認事項、必要な追加検証を切り分ける。
- 品質モデルの適用原則候補を、製品品質要求と混同しない下位文書案として整理する。
- ModIntへ追加の暫定適用を行い、global modulus state、型別契約、並行性を観測する。
- 横断要約は、新しい証拠に必要な範囲だけ更新する。

## Out of scope

- 個別moduleの品質合否と受入判定
- 公開契約、対応環境、本家基準版、性能水準の決定
- 技術調査候補を理由とする製品実装修正、または棚卸し用以外の既存test変更
- 上位品質モデルの正本化または直接改訂
- Linux、Sanitizer、Release、外部benchmarkの本試験

## Evidence and stopping conditions

- 観測commit、環境、選択test、結果、artifact限界を記録する。
- 事実、解釈、候補、未確認、製品判断を分ける。
- 公開契約またはrisk受容の判断が必要なら、決定せず判断事項として返す。
- 現行sourceと実行結果が矛盾する場合は、記録作成より切り分けを優先する。

## Deliverables

- 残作業の分類記録
- FenwickTree／SCCGraph技術調査記録
- 品質モデル適用原則のdraft
- ModInt暫定モデル試験
- 必要に応じて更新した横断要約
