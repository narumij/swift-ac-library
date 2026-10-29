# Codexの作業入口 — swift-ac-library

この文書が通常のCodex作業の現行入口であり、DB内のタスク正本が個別の依頼・受入条件となる。旧Receiver実験用bootstrapの復元や、別途の役割任命は必要ない。任された作業の結果記録も作業範囲に含む。OPS-006／OPS-007では、正本に定めた調査結果を同じ正本へ追記してよい。

## まず実行する

リポジトリ直下で `Maintanance/Studio/work-status` を実行する。サーバー起動は不要。専用DBの最新状態を読む。表示された対象名・DBパスが違えば、書き込まず接続先を確認する。DBを推測したり空DBを作り直したりしない。

現在の方向は、実装開発を原則凍結し、DocCとテストを中心に整えること。品質方針は、その作業で必要になる判断を一つずつ相談する。

## 選ぶ・読む・進める

1. 現在のユーザー依頼を優先する。依頼から任された範囲で、一覧の「現在の作業対象」から一件を選ぶ。
2. `Maintanance/Studio/registry task show TASK-ID` で状態・担当・完了条件を確認し、`Maintanance/Studio/registry doc show TASK-ID --mainline` で正本を読む。必要な関連資料だけ追加で読む。
3. 同じ仕事が他の会話で進行していないか直近の記録を確認する。状態だけで独占・作業中とは判断しない。
4. 正本の範囲内で実施する。判断待ちが生じたら、事実・選択肢・止めた範囲を正本に記録し、ユーザーへ相談する。
5. 結果・根拠のパス・検証範囲・残件を、そのタスクの正本に追記する。完了条件を満たした後に状態を更新する。候補を作っただけでDONEにしない。

ACTIVEの恒久タスクは整理の入口。完了対象の個別作業とは区別する。PROPOSEDは未採用案、ARCHIVEDは過去の記録であり、一覧にあるだけでは作業許可にならない。

## 再開時の具体的な入口

- OPS-006：DocC・公開API説明の現在地を棚卸しする（親 PERM-002）。
- OPS-007：テスト棚卸し案を現行構成と照合する（親 PERM-003）。
- PERM-001：品質方針と根拠の継続整理。

これは入口の案内であり、進捗の写しではない。最新の状態・依頼範囲・結果は必ずDBから読む。

## 記録の方法

自分の実際のConversation IDを使う。`user`や以前のあすとらのIDを名乗らない。未登録なら、起動中サーバーに対する待機入口で登録できる。登録のためだけに待機終了を無視して再待機しない。操作前に `registry waiting --help` で利用可能な入口を確認する。

追記は `Maintanance/Studio/registry doc append TASK-ID --actor CONVERSATION-UUID --lang ja --file RESULT_FILE`。まずファイルを書き終えてから実行する。共同編集時には `doc state` と `--expected-state` を使う。必要な権限がなければ勝手に自分へ付与しない。

状態更新は `task apply --help` の既存経路を使い、`Maintanance/Studio/registry task generation` で現在のgenerationを取得し、既存値を確認する。DBへの直接SQL更新、独自採番はしない。不明な操作はヘルプを確認し、成功した書込みの再送に注意する。

## 接続先

- CLI: `Maintanance/Studio/registry`（専用DBを既定指定）
- DB: `Maintanance/Studio/data/registry.sqlite3`
- Web: http://127.0.0.1:8089/
- 起動: `Maintanance/Studio/start.sh`
- HTTP系の待機・ホワイトボード: `--port 8089` を明示。既定8088は別プロジェクト。

この入口は既存AGENTS.mdの権限を増やさない。製品コード変更、品質要求の採用、公開保証、commit・pushは、現在の指示と既存の取り決めに従う。
