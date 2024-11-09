# swift-ac-library

swift-ac-libraryは、[AC(AtCoder) Library][ac-library]のSwift移植版です。

[![Swift](https://github.com/narumij/swift-ac-library/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/narumij/swift-ac-library/actions/workflows/swift.yml)
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

## お知らせ

[現在のAtCoderの提出に使う場合は、こちらをご利用ください。](https://github.com/narumij/swift-ac-library/tree/release/swift-5.8.1)

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
  .package(url: "https://github.com/narumij/swift-ac-library.git", from: "0.0.5"),
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
提出する際、上記import文は削除する必要があります。

## 提出時

一例ですが、全部連結しています。連結は以下のスクリプトで行うことができます。
あとは各々の提出のオペレーションに合わせてアレンジしてください。

```
#!/bin/zsh

# 対象ディレクトリのパス
TARGET_DIR="<クローンしたディレクトリ>/swift-ac-library/Sources/AtCoder"

# 指定されたディレクトリ内のSwiftファイルを検索し、連結して標準出力に表示
find "$TARGET_DIR" -type f -name "*.swift" -exec cat {} +
```

## ライセンス

[CC0]

[acl]: https://atcoder.jp/posts/517

[ac-library]: https://github.com/atcoder/ac-library

[ac-library-swift]: https://github.com/kyomuei/ac-library-swift

[ac-library-python]: https://github.com/not522/ac-library-python

[ac-library-csharp]: https://github.com/kzrnm/ac-library-csharp

[CC0]: https://creativecommons.org/public-domain/cc0/

