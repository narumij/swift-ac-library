# swift-ac-library 進捗一覧

最終更新: 2026-10-08 / Codex

> このファイルを別projectへコピーしたら、山括弧のplaceholderと「例」行を置き換える。
> Task Registryを残taskの唯一の入口とし、会話や古いchecklistを正本にしない。

Codexはsession開始時に、まずこの文書のTask Registryだけを読む。taskを選択した後、その行が示す
詳細正本だけを追加で読む。完了済みの長い記録は必要に応じて
`Maintanance/Archived/PROGRESS_OVERVIEW_HISTORY.md`へ移す。

## Task Registry

**現在の律速:** なし。現在の`ACTIVE` taskはなく、次の具体的な作業要求待ち。

**一時運用:** なし

### 中間ゴール

中間ゴールは、複数taskをまたぐ到達状態である。taskではないためIDや状態を持たず、Registryの担当、
依存、凍結、再開条件を上書きしない。「何をするか」ではなく「何が判断・引き渡し可能になるか」で書く。

**現在の中間ゴール:**

- 公開API、契約、test根拠、必要な判断点を整理し、ユーザードキュメント作業へ渡せる状態にする。

**後続の中間ゴール:**

- ユーザードキュメント作業後、1.0品質ゲートを実施し、1.0として採用できるか判断可能な状態にする。

### taskの型

- `DISCOVERY`: 事実、選択肢、依存、判断task候補を発見する。仕様や方針を決定しない。
- `DECISION`: ユーザー判断を一つだけ閉じ、結論を後続taskの入力にする。
- `EXECUTION`: 必要な判断が確定した範囲で、実装、文書反映、検証を行う。

複数のユーザー判断を一つのtaskへ束ねない。`DISCOVERY`が判断点を見つけたら、一判断ごとの
`DECISION`へ分ける。`EXECUTION`中に新しい判断が必要になったら、agentは推測で埋めずに停止して
task分割へ戻す。

### 推奨順と今回扱わない判断

**soft order:** なし

soft orderは、同時に着手可能なtask間の推奨順であり、Task precedenceの必須依存ではない。

**現在の作業へ含めない判断:**

- 次期releaseのscope、優先順位、公開API方針は、新しいユーザー要求なしには決めない。

### Tasks

| ID | 状態 | 担当 | 項目 | 再開・完了条件 | 詳細正本 |
| --- | --- | --- | --- | --- | --- |
| `OPS-002` | `DONE` | Codex | [EXECUTION] task履歴の退避先を作る | 退避先fileと保存規則を作成し、Registryから参照可能にする | `Maintanance/Archived/PROGRESS_OVERVIEW_HISTORY.md` |
| `GREET-001` | `DONE` | Codex | [EXECUTION] 次の新しいconversationで挨拶する | 新しいconversationの最初の応答で簡潔に挨拶し、この行を`DONE`へ更新する | `Maintanance/PROGRESS_OVERVIEW.md#greet-001` |
| `OPS-001` | `DONE` | Codex | [EXECUTION] Task Registryのbootstrap | checklist、Registry、startup規則を実データ化し、既知の未完了作業を確認する | `Maintanance/PROGRESS_OVERVIEW.md#bootstrap-checklist` |
| `DOC-001` | `FROZEN` | Codex | [DISCOVERY] GitHub Pagesによるユーザードキュメント公開方式を整理する | `DOC-002`完了後、ユーザーの明示的な再開指示を受け、必要な判断と後続taskを分離する | `Maintanance/PROGRESS_OVERVIEW.md#doc-001` |
| `DOC-002` | `FROZEN` | Codex | [DISCOVERY] ユーザードキュメント方針の判断点を整理する | ユーザーの明示的な再開指示後、対象読者、範囲、構成、保守方法などの判断点を一判断ごとの後続taskへ分離する | `Maintanance/PROGRESS_OVERVIEW.md#doc-002` |

## Task precedence

内部task間の必須AND依存だけを書く。便利な実施順、同じfileを触ること、同じgoalに属することだけを
理由に辺を追加しない。外部条件やユーザーの明示的再開はRegistryの状態・条件欄で表す。

| 後続task | 前提task | 制約 |
| --- | --- | --- |
| `DOC-001` | `DOC-002` | ユーザードキュメント方針の判断点を整理した後に、GitHub Pagesでの公開方式を調査する |

> 必須依存がなければ、見出しとtable headerを残してデータ行を空にする。

## Registry rules

### 状態

- `ACTIVE`: 着手可能または進行中。
- `WAITING_USER`: ユーザーの判断または操作待ち。必要な問いを明示する。
- `WAITING_EXTERNAL`: 外部条件待ち。解消確認方法を明示する。
- `FROZEN`: 明示的な再開指示まで着手しない。
- `USER_ONLY`: ユーザー専任。agentは着手、代行、催促をしない。
- `EXCLUDED`: 実施しないと確定。理由を残し、IDを再利用しない。
- `DONE`: 完了条件を証拠付きで満たし、正本とRegistryの同期を確認済み。
- `ARCHIVED`: 現行Registryから`Maintanance/Archived/PROGRESS_OVERVIEW_HISTORY.md`へ移した。移動先anchorを残す。

### ID

- `<領域>-<連番3桁>`を基本とする。例: `CORE-001`、`DOC-001`。
- IDは永続的に扱い、状態、担当、分類が変わってもrename、renumber、reuseしない。
- IDはagent向け座標であり、通常のユーザー報告では人間が読めるtask名を優先する。

### 更新と完成判定

- 優先順位は、ユーザーの最新指示、Task Registry、選択taskの詳細正本、Archived・旧logの順とする。
- Task Registryの確定更新は統合担当のCodexが行う。
- 担当agentの完了報告だけで`DONE`にしない。diff、test、根拠、完了条件を照合する。
- 新しい判断点、前提との衝突、scope逸脱を見つけたら実装を止め、task分割または状態更新へ戻る。
- `EXCLUDED`は失敗の隠蔽ではない。前提誤りや方針変更の理由を保存する完了状態として扱う。
- 完了taskがRegistryを読みにくくしたら、ID、結果、commit、元の詳細正本を
  `Maintanance/Archived/PROGRESS_OVERVIEW_HISTORY.md`へ記録し、Registryには`ARCHIVED`行と移動先anchorを残す。

## Session restart procedure

Codexは新しいsessionで次の順に再開する。

1. このRegistryだけを読む。
2. ユーザーの最新指示に合うtaskを選ぶ。
3. 状態、担当、再開条件、必須依存を確認する。
4. 選択taskの詳細正本だけを読む。
5. worktreeと直近commitを確認する。
6. 着手可能なら小さな単位で進め、判断不足なら停止してユーザーへ返す。

`FROZEN`、`USER_ONLY`、`WAITING_EXTERNAL`を、古い文書の未完了記述だけで開始しない。

## Current summary

この節は人間向けの短いsnapshotであり、Registryを上書きしない。古くなったら更新または削除する。

- `develop/after2025/1`は次期releaseへ向けた開発branchである。
- Task Registryのbootstrap、新しいconversation用の挨拶task、履歴退避先の作成は完了済み。
- ユーザードキュメント方針とGitHub Pages公開方式の調査は、明示的な再開指示まで凍結している。

## Task details

### DOC-002

- 目的: ユーザードキュメント方針の策定に必要な事実と判断点を整理する。
- 対象範囲: 対象読者、扱うAPI、文書の範囲と構成、既存コメントとの役割分担、保守方法の調査。個別方針の決定や本文作成は含めない。
- 状態: `FROZEN`。ユーザーの明示的な再開指示なしに着手しない。
- 停止条件: 方針上の選択が必要になった場合は、agentが決めず、一判断ごとの`DECISION`候補として分離する。
- 完了条件: 方針策定に必要な判断を重複なく整理し、独立した`DECISION`と、その結論を使う`EXECUTION`を提案できる。

### DOC-001

- 目的: GitHub Pagesによるユーザードキュメント公開に必要な事実、選択肢、判断点、後続taskを整理する。
- 対象範囲: 現状の文書資産、Package構成、生成・配置・更新方式の調査。公開方式の決定や公開作業は含めない。
- 状態: `FROZEN`。`DOC-002`の完了とユーザーの明示的な再開指示が揃うまで着手しない。
- 停止条件: 文書形式、公開元、更新方法などの判断が必要になった場合は、一判断ごとの`DECISION`候補として分離する。
- 完了条件: 確認した事実と選択肢を記録し、必要な`DECISION`と`EXECUTION`を独立した後続taskとして提案できる。

### GREET-001

- 目的: 新しいconversationでstartup規則によりTask Registryからtaskを復元できることを確認する。
- 対象範囲: 新しいconversationの最初の応答での簡潔な挨拶と、挨拶後の`GREET-001`の`DONE`更新。
- 既に決まっていること: 挨拶の文面に追加の確認事項や作業提案を含める必要はない。
- 実行条件: 新しいconversationの開始時にCodex所有の唯一の`ACTIVE` taskとして直ちに実行する。
- 完了証拠: 新しいconversationで挨拶を返し、RegistryとCurrent summaryを同期する。

## Bootstrap checklist

別projectへ導入するときに一度だけ確認する。

- [x] project名、日付、更新者を置き換えた。
- [x] 例示taskとplaceholderを実データへ置き換えた。
- [x] 現在の中間ゴールを到達状態として書いた。
- [x] 既存の未完了作業を重複なしでRegistryへ登録した（open issue 0件、code内TODOのissue #8はClosedを確認）。
- [x] 凍結、ユーザー専任、外部待ちを明示した（該当なし）。
- [x] 各taskから詳細正本へ辿れる。
- [x] 複数判断を含むtaskを分割した（該当なし）。
- [x] 必須依存とsoft orderを分けた（いずれも該当なし）。
- [x] AGENTS.mdなどのsession開始規則から、このRegistryを唯一の入口として参照した。
- [x] RegistryとGitだけから、現在は次の具体的な作業要求待ちであると判定できることを確認した。

## AGENTS.md startup snippet

projectの`AGENTS.md`へ導入済みのstartup規則を、参照用に再掲する。

```markdown
## Task management startup

1. Read only the Task Registry at the top of `Maintanance/PROGRESS_OVERVIEW.md`
   to establish the current task state.
2. Treat that Registry as the sole source of truth for remaining tasks, status,
   ownership, restart conditions, and required task dependencies.
3. After selecting a task, read only the detailed canonical document linked
   from that task row.
4. Do not scan all planning documents or archived records at session start.
   Do not revive tasks from old checklists, handoffs, or logs.
5. Priority order is: the user's latest instruction, the Task Registry, the
   selected task's canonical document, then archived records and old logs.
6. Never start `FROZEN`, `USER_ONLY`, or `WAITING_EXTERNAL` tasks unless their
   explicit restart condition has been satisfied.
7. Codex owns final Registry updates and completion acceptance unless the
   Registry explicitly assigns that responsibility elsewhere.
```
