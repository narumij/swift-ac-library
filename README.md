# swift-ac-library

swift-ac-libraryは、[AtCoder Library][ac-library]のSwift移植版です。

## 利用の仕方

SwiftPM パッケージで swift-ac-libraryを利用する場合は、以下をPackage.swift に追加してください。

```
dependencies: [
  .package(url: "https://github.com/narumij/swift-ac-library.git", from: "0.0.5"),
],
```

提出時は、コピペで頑張ってください。

## 公式情報

[AtCoder Library (ACL) - AtCoder][acl]

## 関連

[ac-library-swift] - Swift版。128bitの乗算部分など、いくつか参考にさせていただきました。

[ac-library-csharp] - C#版。命名等に関して、今後参考にさせていただこうと思っています。

[ac-library-python] - Python版。こちらも参考にさせていただこうと思っています。

## その他

無保証です。破壊的変更の可能性があります。

## 方針

ac-libraryとの目視照らし合わせで間違いを発見しやすいこと。

このため、Swiftらしい書き方よりも、C++そのままに近い方を優先します。

命名規則関連は、C#版やPython版を参考に、ガチガチにC++に似せていたのを、緩めていきます。

## ライセンス

[CC0]

[acl]: https://atcoder.jp/posts/517

[ac-library]: https://github.com/atcoder/ac-library

[ac-library-swift]: https://github.com/kyomuei/ac-library-swift

[ac-library-python]: https://github.com/not522/ac-library-python

[ac-library-csharp]: https://github.com/kzrnm/ac-library-csharp

[CC0]: https://creativecommons.org/public-domain/cc0/

