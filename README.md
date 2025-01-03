# swift-ac-library

swift-ac-libraryは、[AC(AtCoder) Library][ac-library]のSwift移植版です。

[![Swift](https://github.com/narumij/swift-ac-library/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/narumij/swift-ac-library/actions/workflows/swift.yml)
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

## お知らせ

[現在のAtCoderの提出に使う場合は、こちらをご利用ください。](https://github.com/narumij/swift-ac-library/tree/release/swift-5.8.1)

- tagは0.0.13までがSwift 5.8.1対応です。

## 公式情報

[AtCoder Library (ACL) - AtCoder][acl]

## 関連

[ac-library-csharp] - C#版

[ac-library-python] - Python版

[ac-library-swift] - 元祖Swift版

## 利用の仕方

SwiftPMで swift-ac-libraryを利用する場合は、

以下をPackage.swift に追加してください。
```
dependencies: [
  .package(url: "https://github.com/narumij/swift-ac-library.git", from: "0.1.0"),
],
```

ビルドターゲットに以下を追加します。

```
    dependencies: [
            .product(name: "AtCoder", package: "swift-ac-library")
    ]
```

ソースコードに以下を追加します。
```
import AtCoder
```

## アンダースコア付き宣言について

「アンダースコア付き宣言」は、完全修飾名のどこかにアンダースコア (`_`) で始まる部分が含まれる宣言のことを指します。たとえば、以下のような名前は技術的に `public` として宣言されていても、パブリックAPIには含まれません：

- `FooModule.Bar._someMember(value:)`（アンダースコア付きのメンバー）
- `FooModule._Bar.someMember`（アンダースコア付きの型）
- `_FooModule.Bar`（アンダースコア付きのモジュール）
- `FooModule.Bar.init(_value:)`（アンダースコア付きの引数を持つイニシャライザ）

さらに、コードベース全般についても同様に、互換性が保証されることは期待しないでください。これらの宣言は必要に応じて変更される可能性があり、非互換な修正が加えられる場合があります。

## ライセンス

[CC0]

[acl]: https://atcoder.jp/posts/517

[ac-library]: https://github.com/atcoder/ac-library

[ac-library-swift]: https://github.com/kyomuei/ac-library-swift

[ac-library-python]: https://github.com/not522/ac-library-python

[ac-library-csharp]: https://github.com/kzrnm/ac-library-csharp

[CC0]: https://creativecommons.org/public-domain/cc0/

