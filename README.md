# swift-ac-library

swift-ac-libraryは、[AC(AtCoder) Library][ac-library]のSwift移植版です。

## 公式情報

[AtCoder Library (ACL) - AtCoder][acl]

## 関連

[ac-library-csharp] - C#版

[ac-library-python] - Python版

[ac-library-swift] - Swift版

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

ファイルに以下を追加します。
```
import AtCoder
```

## 提出時

一例ですが、全部連結しています。連結は以下のスクリプトで行うことができます。
あとは各々の提出のオペレーションに併せてアレンジしてください。

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

