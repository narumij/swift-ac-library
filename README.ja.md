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
