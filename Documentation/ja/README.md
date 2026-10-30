# swift-ac-library 日本語ガイド

Swift版だけで使い方・制約・計算量・使用例を読めるリファレンスです。
同じリポジトリの開発中ソースに対応します。AtCoder搭載の凍結版とは異なる場合があります。

まず[共通事項](usage.md)で、導入・添字・所有権・数値の前提を確認してください。

## 機能別

- [Fenwick Tree](fenwicktree.md)
- [Segment Tree](segtree.md)
- [Lazy Segment Tree](lazysegtree.md)
- [DSU](dsu.md)
- [Maximum Flow](maxflow.md)
- [Minimum-Cost Flow](mincostflow.md)
- [SCC](scc.md)
- [2-SAT](twosat.md)
- [Math](math.md)
- [Convolution](convolution.md)
- [String Algorithms](string.md)
- [ModInt](modint.md)

## 関連資料

- [英語DocCの原稿](../../Sources/AtCoder/AtCoder.docc/AtCoder.md)
- [公開英語DocC](https://narumij.github.io/swift-ac-library/documentation/atcoder/)
- [版ごとの既知の制限・修正](../../KNOWN_LIMITATIONS.md)
- [リポジトリREADME](../../README.ja.md)

## 出典と維持方針

原文はAtCoder Libraryの日英文書（CC0-1.0）で、固定リビジョンは
`864245a00b00dd008d1abfdc239618fdb7d139da`です。
各章末尾に原文の出典を記載しています。Swiftの宣言・例・固有の注意を加えています。
英語DocCと日本語Markdownの制約・意味・例は、API変更時に両方更新します。
