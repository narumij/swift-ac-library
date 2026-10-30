## CRT・整数畳み込みの境界確認 — 2026-10-30

379ケース×C++/SwiftのDebug/Release＝1,516実行、すべて独立期待値と一致。製品コード変更なし。

- CRT：複数条件、空条件、法1、同一法、共通因子あり・解なし、Int.min/maxの剰余、Int.maxに近い最小公倍数。最小公倍数はInt.max以内。さらにseed 2026103003で法2つと64bit全域の剰余を200ケース生成。Python任意精度整数の逐次CRTで期待値を算出。
- convolution_ll：長さ1/2/60/61/64、Int.min/maxとその隣接値、ゼロ・±1を含む疎な入力65ケース。Int.min×-1は契約外として除外。長さ2/60/61/64で大きな値と交互符号を使う相殺16ケースも追加。Python任意精度の直接積和で各結果がInt内に収まることと出力を確認。NTT切替の両側を通過。

再実行：既存build.shの後にpython3 Maintanance/Investigations/OPS-010/crt-convolution-boundaries.py。入力と全結果はcrt-convolution-boundary-results.json。固定C++参照版は864245a00b00dd008d1abfdc239618fdb7d139da。

今回新しい不一致はなし。先に記録したfloor_sumの37ケースは未修正。フローの複雑経路・全容量型、構造系の巨大サイズ、任意monoid、Linuxなどは保証しない。
