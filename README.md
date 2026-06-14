# swift-ac-library

[AtCoder][ac] の競技プログラミング向けライブラリである [AC(AtCoder) Library][ac-library] の Swift 移植版


[![Swift](https://github.com/narumij/swift-ac-library/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/narumij/swift-ac-library/actions/workflows/swift.yml)
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

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
| Branch | Recommended | Description |
|----------|----------|----------|
| `compatible/AtCoder/2025` | ⭐ | AtCoder 2025 互換の推奨版 |
| `release/AtCoder/2025` | | AtCoder 2025 搭載版 |
| `main` | | 開発版 |

### Which branch should I use?

通常は `compatible/AtCoder/2025` の利用をおすすめします。

 `compatible/AtCoder/2025` ブランチでは AtCoder 2025 との互換性を維持したまま、ドキュメント補強、deprecated 指定、注意喚起の追加などの保守を行っています。

`release/AtCoder/2025` は AtCoder に搭載されている状態をそのまま保持するためのブランチです。

`main` は開発中のブランチです。API や実装が変更される可能性があります。

---

## アンダースコア付き宣言について

「アンダースコア付き宣言」は、完全修飾名のどこかにアンダースコア (`_`) で始まる部分が含まれる宣言のことを指します。たとえば、以下のような名前は技術的に `public` として宣言されていても、パブリックAPIには含まれません：

- `FooModule.Bar._someMember(value:)`（アンダースコア付きのメンバー）
- `FooModule._Bar.someMember`（アンダースコア付きの型）
- `_FooModule.Bar`（アンダースコア付きのモジュール）
- `FooModule.Bar.init(_value:)`（アンダースコア付きの引数を持つイニシャライザ）

さらに、コードベース全般についても同様に、互換性が保証されることは期待しないでください。これらの宣言は必要に応じて変更される可能性があり、非互換な修正が加えられる場合があります。

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

