# swift-ac-library

swift-ac-libraryは、[AC(AtCoder) Library][ac-library]のSwift移植版です。

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

## 公式情報

[AtCoder Library (ACL) - AtCoder][acl]

## 関連

[ac-library-swift] - Swift版。128bitの乗算部分など、いくつか参考にさせていただきました。

[ac-library-csharp] - C#版。命名等に関して、今後参考にさせていただこうと思っています。

[ac-library-python] - Python版。こちらも参考にさせていただこうと思っています。

## 方針

ac-libraryとの目視照らし合わせで間違いを発見しやすいこと。

このため、実装部分に関しては、Swiftらしい書き方よりも、C++そのままに近い方を優先します。

命名規則関連は、Python版やC#版を参考に、ガチガチにC++に似せていたのを、緩めていきます。

## その他

無保証です。破壊的変更の可能性があります。
不具合等ありましたら、教えてくれると喜びます。

### 命名規則

Swiftの命名規則には反していますが、メソッド名に関してはPython版の名前に寄せることにしました。
理由は、Pythonの解説コードがSwiftに有用な場合が多く、upsolveでのめんどくささを軽減したかったからです。

### 雑感

メソッドシグネチャ等は気の迷いでまだ修正する可能性がありますが、内容に関しては安定してきています。

## ライセンス

[CC0]

[acl]: https://atcoder.jp/posts/517

[ac-library]: https://github.com/atcoder/ac-library

[ac-library-swift]: https://github.com/kyomuei/ac-library-swift

[ac-library-python]: https://github.com/not522/ac-library-python

[ac-library-csharp]: https://github.com/kzrnm/ac-library-csharp

[CC0]: https://creativecommons.org/public-domain/cc0/

