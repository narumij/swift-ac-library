# Test inventory local contract — 2026-10-14

## Goal

現行test資産を、由来と現在の品質上の役割を混同せず、後日の採用・移動・統合・削除判断ができる粒度で棚卸しする。

## Authority and scope

- Receiverが直接実施する。
- `Tests/AtCoderTests`、`Tests/ExtraTests`、`Tests/TopLevel`と関連するsource・既存品質記録を読む。
- 原則としてfileまたは同一根拠を持つtest群単位で分類する。
- 必要ならmaintenance内に棚卸しdraftを作成する。
- `Maintanance/User/`の変更は観測・編集・commit対象から除外する。

## Out of scope

- test、製品source、Package manifestの移動・削除・意味変更
- 歴史的由来を内容対応だけから断定すること
- test成功を品質適合または公開契約へ昇格すること
- 製品基準版、保証範囲、受入条件の決定
- branch操作、commit、push

## Classification axes

### Origin

- upstream content correspondence confirmed
- upstream correspondence candidate／unverified
- Swift port／language-specific difference
- project-specific scenario
- exploratory／inventory
- unknown

### Current role

- public behavior example
- implementation／internal invariant
- invalid-input／death behavior
- compile／API availability
- stress／large input
- performance observation
- consumer／top-level integration
- alternative implementation experiment

## Evidence rule

test名、コメント、過去文書だけで由来を確定せず、固定した本家比較点または履歴がある場合だけ確認済みとする。未照合の対象は候補またはunknownに保つ。

## Deliverables

- test資産の横断棚卸しdraft
- 由来確認が必要な群、役割が重複する群、実行不能・無効化・skip群の一覧
- 後日の採否判断に必要な製品判断と技術調査の分離
