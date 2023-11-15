# swift-ac-library

ac-libraryのSwiftポートの一つです。

## 動機

解説を読んで実装を試したかった。

## 目的

Swiftに欠けてるライブラリを、ac-libraryを参考に補填すること。

## 方針

ac-libraryとの目視照らし合わせで間違いを発見しやすいこと。

このため、Swiftらしい書き方よりも、C++そのままに近い方を優先します。

バグが無いことを保証する力量は残念ながらないため、せめてバグが少ないことを目指す。

## 利用の仕方

SwiftPM パッケージで swift-ac-libraryを利用する場合は、以下をPackage.swift に追加してください。

```
dependencies: [
  .package(url: "https://github.com/narumij/swift-ac-library.git", from: "0.0.4"),
],
```

提出時用のエキスパンダーの用意はいまのところありません。コピペで頑張ってください。

## その他

無保証です。

modintは構造の違いによる使い方の差異があります。具体的にはbarrettをプロトコルでインジェクションするカタチになっています。
通常利用の範囲ではmodint998244353等がありますので、問題ないかと考えてます。

## ライセンス

ac-libraryにならい、CC0です。

