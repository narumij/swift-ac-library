# DSU

DSUのSwift版リファレンスです。

## Swift版の使い方

DSUは非コピー型です。経路圧縮で内部を書き換えるため、same・leader・size・groupsにもvarが必要です。追加API unite(a,b)は異なる成分を併合した場合だけtrue（ならしO(α(n))）。reset()はO(n)で全頂点を独立に戻し、clone()はO(n)で独立した複製を作ります。辺の削除は提供しません。

無向グラフに対して、

- 辺の追加
- $2$ 頂点が連結かの判定

をならし $O(\alpha(n))$ 時間で処理することが出来ます。

また、内部的に各連結成分ごとに代表となる頂点を $1$ つ持っています。辺の追加により連結成分がマージされる時、新たな代表元は元の連結成分の代表元のうちどちらかになります。

## コンストラクタ

```swift
var d = DSU(n)
```

- $n$ 頂点 $0$ 辺の無向グラフを作ります。

**制約**

- $0 \leq n \leq 10^8$

**計算量**

- $O(n)$

## merge

```swift
let representative: Int = d.merge(a, b)
```

辺 $(a, b)$ を足します。

$a, b$ が連結だった場合はその代表元、非連結だった場合は新たな代表元を返します。

**制約**

- $0 \leq a < n$
- $0 \leq b < n$

**計算量**

- ならし $O(\alpha(n))$

## same

```swift
let connected: Bool = d.same(a, b)
```

頂点 $a, b$ が連結かどうかを返します。

**制約**

- $0 \leq a < n$
- $0 \leq b < n$

**計算量**

- ならし $O(\alpha(n))$

## leader

```swift
let representative: Int = d.leader(a)
```

頂点 $a$ の属する連結成分の代表元を返します。

**制約**

- $0 \leq a < n$

**計算量**

- ならし $O(\alpha(n))$

## size

```swift
let count: Int = d.size(a)
```

頂点 $a$ の属する連結成分のサイズを返します。

**制約**

- $0 \leq a < n$

**計算量**

- ならし $O(\alpha(n))$

## groups

```swift
let components: [[Int]] = d.groups()
```

グラフを連結成分に分け、その情報を返します。

返り値は「「一つの連結成分の頂点番号のリスト」のリスト」です。
(内側外側限らず)Array内でどの順番で頂点が格納されているかは未定義です。

**計算量**

- $O(n)$

## 使用例

```swift
import AtCoder

var components = DSU(4)
_ = components.merge(0, 1)
print(components.same(0, 1)) // true
print(components.size(0)) // 2
print(components.same(0, 2)) // false
```

## 出典

以下の日英原稿をSwift向けに改編： [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_ja/dsu.md), CC0-1.0.

[目次](README.md) · [共通事項](usage.md)
