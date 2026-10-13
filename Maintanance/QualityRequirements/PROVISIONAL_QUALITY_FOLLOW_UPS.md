# Provisional Quality Follow-ups

> **文書状態:** 暫定試験から生じた残作業の分類。製品roadmap、優先順位の決定、品質判定ではない。

## 1. 製品判断が必要な事項

- 基準とする本家ac-libraryのversionまたはcommit
- 本家との差異、Swift追加API、返却順等を保証する方針
- 一般Swift利用へ与える保証強度
- assert、precondition、Release、`-Ounchecked`の境界
- `@unchecked Sendable`とdynamic ModInt stateのconcurrency契約
- performance比較対象、workload、受入水準
- Swift 5.8.1向けsource、ExtraTests、互換系列の位置づけ
- QR-07の運用能力を製品品質要求へ含めるか

これらは実装または既存testから逆算して決めない。

## 2. 独立した技術調査

| 対象 | 現在の反証・問い | 状態 |
|---|---|---|
| FenwickTree | genericな`-1`によるunsigned storage初期化 | Swift 6.4の対応4型でゼロを観測。設計理由と他構成は未確認 |
| SCCGraph | chain形状の再帰DFS | 隔離実行で850成功、875失敗。原因、通常processとの差、他構成・環境は未確認 |
| SCCGraph／CSR | 複数回評価と評価後の変更 | 小規模caseで成功。メモリ安全性全体は未検証 |
| ModInt | dynamic modulusとconcurrency | modulus変更をまたぐ逐次挙動を観測。並行実験と契約は未実施 |

詳細は`TECHNICAL_INVESTIGATIONS_2026-10-14.md`と`MODINT_PROVISIONAL_MODEL_TRIAL.md`を参照する。

## 3. 下位文書・試験設計へ置く候補

- scope固定とinternal実行経路の境界
- QRごとの証拠量を公開契約、risk、差異、保証強度へ比例させる原則
- testの由来、現在の役割、実行状態、証拠限界の分離
- 棚卸し用testの置き場所、disabledの意味、採否判断
- 公開前の代理Validationと公開後の実利用Validationの区別

`QUALITY_MODEL_APPLICATION_PRINCIPLES_DRAFT.md`をまとめレビューの対象とし、上位品質要求へ直接書き戻さない。

## 4. 棚卸し用test

- Fenwick generic literal test: active、選択実行成功
- SCC repeated evaluation／mutation test: active、選択実行成功
- SCC 850-chain isolation test: active、選択実行成功
- SCCの小規模成功probeと875以上の失敗probe: disabled、観測結果を技術調査記録へ保存
- Dynamic ModInt modulus-change test: active、選択実行成功
- Death Testひな形: file自体を維持するためactive

棚卸し時に、module固有testへ昇格、条件付き検証、fixture化、disabled継続、削除のいずれかを判断する。現時点の配置だけで製品契約または品質証拠へ昇格しない。

## 5. 次のレビュー単位

対象数をさらに増やす前に、次をまとめてレビューする価値がある。

1. 五つの暫定適用でQR-01〜QR-07の重複・不足が反証されたか
2. 適用原則を上位モデルと下位手順のどちらへ置くか
3. SCCのsignalを優先調査またはrisk判断へ上げるか
4. ModInt concurrencyを製品契約策定前に実験するか
5. 棚卸し用testの常時実行負荷と失敗時の扱い
