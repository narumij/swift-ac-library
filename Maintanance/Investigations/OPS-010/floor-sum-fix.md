## floor_sum修正結果 — 2026-10-30
主要な境界確認を一巡した後、ユーザー指示に従って修正。元実装は#if falseに保持。負係数の補正・中間和・最終加算をUIntのラップ演算にそろえ、最後にInt(bitPattern:)へ戻す。本家ACLと同じ2^64剰余の意味を維持する。
追加数学/フロー316ケース×4構成=1,264実行は全成功（従来のSwift各37失敗を解消）。通常比較3,486ケースもC++/Swift Debug/Releaseで全成功。性能比較は実施していない。製品全テストターゲットの成功や他環境の保証とは区別する。
修正前の詳細はextended-boundary-summary.json、修正後の要約はfloor-sum-fixed-summary.json。KNOWN_LIMITATIONS.mdを修正済み・未リリースとして更新。
