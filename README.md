# swift-ac-library

swift-ac-libraryは、[AC(AtCoder) Library][ac-library]のSwift移植版です。

## 利用の仕方

SwiftPM パッケージで swift-ac-libraryを利用する場合は、以下をPackage.swift に追加してください。

```
dependencies: [
  .package(url: "https://github.com/narumij/swift-ac-library.git", from: "0.0.5"),
],
```

提出時は、コピペで頑張ってください。

## セグ木の作り方

プロトコル適用をすることで、構造体をセグ木にして利用することができます。
適用の際に行う必要があるのは、単位元、二項演算、ストレージの三つを書くことです。
集合Sについては型推論が働くため書く必要がありません。

例: 集合SがInt、単位元が0、二項演算がmax関数の場合
```swift
struct segtree: SegtreeProtocol {
    static let e = 0
    static let op: (Int, Int) -> Int = max
    var storage: Storage
}
```

例: 集合SがInt、単位元が0、二項演算が加算の場合
```swift
struct segtree: SegtreeProtocol {
    static let e: Int = 0
    static let op: (Int, Int) -> Int = (+)
    var storage: Storage
}
```

例: 集合SがInt、単位元が1、二項演算が乗算の場合
```swift
struct segtree: SegtreeProtocol {
    static let e = 1
    static let op: (Int, Int) -> Int = (*)
    var storage: Storage
}
```

## 遅延セグ木の作り方

プロトコル適用をすることで、構造体をセグ木にして利用することができます。
適用の際に行う必要があるのは、単位元、二項演算、作用関数、作用の合成関数、作用の単位元、ストレージの五つを書くことです。

例: モノイドの型S、写像の型FがInt。単位元が0、二項演算がmax関数、作用関数が加算、作用の合成関数が加算、作用の単位元が0の場合。
```swift
struct lazy_segtree: LazySegtreeProtocol {
    static let op: (Int,Int) -> Int = max
    static let e: Int = Int.min
    static var mapping: (Int,Int) -> Int = (+)
    static var composition: (Int,Int) -> Int = (+)
    static let id: Int = 0
    var storage: Storage
}
```

## 公式情報

[AtCoder Library (ACL) - AtCoder][acl]

## 関連

[ac-library-swift] - Swift版。128bitの乗算部分など、いくつか参考にさせていただきました。

[ac-library-csharp] - C#版。命名等に関して、今後参考にさせていただこうと思っています。

[ac-library-python] - Python版。こちらも参考にさせていただこうと思っています。

## その他

無保証です。破壊的変更の可能性があります。
不具合等ありましたら、教えてくれると喜びます。

## 方針

ac-libraryとの目視照らし合わせで間違いを発見しやすいこと。

このため、実装部分に関しては、Swiftらしい書き方よりも、C++そのままに近い方を優先します。

命名規則関連は、C#版やPython版を参考に、ガチガチにC++に似せていたのを、緩めていきます。

## ライセンス

[CC0]

[acl]: https://atcoder.jp/posts/517

[ac-library]: https://github.com/atcoder/ac-library

[ac-library-swift]: https://github.com/kyomuei/ac-library-swift

[ac-library-python]: https://github.com/not522/ac-library-python

[ac-library-csharp]: https://github.com/kzrnm/ac-library-csharp

[CC0]: https://creativecommons.org/public-domain/cc0/

