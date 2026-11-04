# swift-ac-library

[English](README.md) | 日本語
[既知の制限事項](KNOWN_LIMITATIONS.md)


[AtCoder][ac] の競技プログラミング向けライブラリである [AC(AtCoder) Library][ac-library] の Swift 移植版


[![Swift](https://github.com/narumij/swift-ac-library/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/narumij/swift-ac-library/actions/workflows/swift.yml)
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

## ドキュメント

- [英語APIドキュメント（DocC）](https://narumij.github.io/swift-ac-library/documentation/atcoder/)
- [日本語ガイド](Documentation/ja/README.md)

Swiftでの使い方・制約・計算量・使用例をまとめています。
同梱ガイドは同じソースの版に対応し、公開サイトはmainに追従します。

## 公式情報

[AtCoder Library (ACL) - AtCoder][acl]

## 利用の仕方

SwiftPMで swift-ac-libraryを利用する場合は、

以下をPackage.swift に追加してください。
```swift
dependencies: [
  .package(
    url: "https://github.com/narumij/swift-ac-library",
    branch: "compatible/AtCoder/2025"),
],
```

ビルドターゲットに以下を追加します。

```swift
  dependencies: [
    .product(name: "AtCoder", package: "swift-ac-library")
    ]
```

ソースコードに以下を追加します。
```
import AtCoder
```

## Branch Strategy

| Branch | Recommended | Status | Description |
|----------|----------|----------|----------|
| `compatible/AtCoder/2025` | ⭐ | Maintained | AtCoder 2025 互換の推奨版 |
| `release/AtCoder/2025` | | Frozen | AtCoder 2025 搭載版 |
| `main` | | Active Development | 次期リリース開発版 |

### Which branch should I use?

通常は `compatible/AtCoder/2025` を利用してください。

`release/AtCoder/2025` は AtCoder に搭載されている状態をそのまま保存するためのブランチです。原則として変更されません。

`compatible/AtCoder/2025` は AtCoder 2025 との互換性を維持しながら、ドキュメント補強、deprecated 指定、注意喚起の追加などの保守を行うブランチです。

`main` は次期リリースに向けた開発ブランチです。

## ベンチマーク

製品リビジョン `0166ab4` で計測した、Swift版とC++版AtCoder Libraryの比較です。
Apple M1、Swift 6.4 Release -O、C++ -O3 -DNDEBUG、サニタイザーなし。
値は構築・実行・破棄を含むバッチ全体の計測です。これらの入力での結果であり、一般的な性能の優劣を示すものではありません。
帯は信頼区間ではありません。
[結果の要約](Benchmarks/Results/20261104-current/README.md)、[計測方法](Benchmarks/README.md)、[ワークロードの定義](Benchmarks/Extended.md)（いずれも英語）も参照してください。

### DSU merge and size

![DSU merge and size](Benchmarks/Results/20261104-current/charts/01%20DSU%20merge%20and%20size.png)

### SegTree random updates

![SegTree random updates](Benchmarks/Results/20261104-current/charts/02%20SegTree%20random%20updates.png)

### SegTree range sums

![SegTree range sums](Benchmarks/Results/20261104-current/charts/03%20SegTree%20range%20sums.png)

### Fenwick add and prefix sum

![Fenwick add and prefix sum](Benchmarks/Results/20261104-current/charts/04%20Fenwick%20add%20and%20prefix%20sum.png)

### LazySegTree range add and sum

![LazySegTree range add and sum](Benchmarks/Results/20261104-current/charts/05%20LazySegTree%20range%20add%20and%20sum.png)

### SCC grouped cycles

![SCC grouped cycles](Benchmarks/Results/20261104-current/charts/06%20SCC%20grouped%20cycles.png)

### TwoSAT planted clauses

![TwoSAT planted clauses](Benchmarks/Results/20261104-current/charts/07%20TwoSAT%20planted%20clauses.png)

### MaxFlow sparse network

![MaxFlow sparse network](Benchmarks/Results/20261104-current/charts/08%20MaxFlow%20sparse%20network.png)

### MinCostFlow sparse network

![MinCostFlow sparse network](Benchmarks/Results/20261104-current/charts/09%20MinCostFlow%20sparse%20network.png)

### Convolution modulo 998244353

![Convolution modulo 998244353](Benchmarks/Results/20261104-current/charts/10%20Convolution%20modulo%20998244353.png)

### Suffix array alphabet 26

![Suffix array alphabet 26](Benchmarks/Results/20261104-current/charts/11%20Suffix%20array%20alphabet%2026.png)

### Z algorithm alphabet 26

![Z algorithm alphabet 26](Benchmarks/Results/20261104-current/charts/12%20Z%20algorithm%20alphabet%2026.png)

### ModInt multiply and add

![ModInt multiply and add](Benchmarks/Results/20261104-current/charts/13%20ModInt%20multiply%20and%20add.png)

## 関連

[ac-library-csharp] - C#版

[ac-library-python] - Python版

[ac-library-swift] - 元祖Swift版

## ライセンス

[CC0]



[ac]: https://atcoder.jp/

[acl]: https://atcoder.jp/posts/517

[ac-library]: https://github.com/atcoder/ac-library

[ac-library-swift]: https://github.com/kyomuei/ac-library-swift

[ac-library-python]: https://github.com/not522/ac-library-python

[ac-library-csharp]: https://github.com/kzrnm/ac-library-csharp

[CC0]: https://creativecommons.org/public-domain/cc0/
