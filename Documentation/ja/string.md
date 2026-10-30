# String

StringのSwift版リファレンスです。

## Swift版の使い方

String版の返す添字はCharacter単位の位置で、UTF-8バイト位置でもString.Indexでもありません。添字アクセスはArray(text)に変換すると扱いやすくなります。ASCII Stringと[UInt8]のsuffix arrayはO(n)、非ASCII String/[Character]は順位圧縮のため文字比較O(n log n)です。Unicode比較・変換の実コストは符号化長にも依存します。汎用suffix_arrayはComparable要素・Int添字のCollectionを受け取りますが、内部で0..<countを参照するので、非0始まりのsliceではなくArrayを渡してください。lcp_array/z_algorithmの汎用版はEquatableの配列です。upper指定版はIntに収まる整数値の配列を使います。バイト版のSAとCharacter版のLCPを混ぜないでください。LCPは空入力不可、suffix_arrayとz_algorithmは空入力可能です。

文字列アルゴリズム詰め合わせです。
文字列に関する様々なアルゴリズムが入っています。

文字列 `s` の $a$ 番目から $b - 1$ 番目の要素のsubstringを、`s[a..b)`と表記します。

## suffix_array

```swift
// (1): String -> [Int]
let sa = suffix_array(text)
// (2): [Int] -> [Int]
let sa2 = suffix_array(values)
// (3): [Int] and alphabet upper bound -> [Int]
let sa3 = suffix_array(values, upper)
```

長さ $n$ の文字列 `s` のSuffix Arrayとして、長さ $n$ の Array を返す。
Suffix Array `sa` は $(0, 1, \dots, n - 1)$ の順列であって、各 $i = 0,1, \cdots ,n-2$ について `s[sa[i]..n) < s[sa[i+1]..n)` を満たすもの。

**制約**

- $0 \leq n \leq 10^8$
- (2) 要素型・添字の要件は上記Swift版の注意を参照。
- (3) $0 \leq \mathrm{upper} \leq 10^8$
- (3) $s$ のすべての要素 $x$ について $0 \leq x \leq \mathrm{upper}$

計算量

- (1) ASCII: O(n); 非ASCII: O(n log n)文字比較。
- (2) 時間 $O(n \log n)$ 空間 $O(n)$
- (3) $O(n + \mathrm{upper})$

## lcp_array

```swift
// (1): String and its suffix array
let lcp = lcp_array(text, sa)
// (2): Array and its suffix array
let lcp2 = lcp_array(values, sa2)
```

長さ $n$ の文字列 `s` のLCP Arrayとして、長さ $n-1$ の配列を返す。$i$ 番目の要素は `s[sa[i]..n), s[sa[i+1]..n)` の LCP(Longest Common Prefix) の長さ。

**制約**

- `sa` は `s` のSuffix Array
- $1 \leq n \leq 10^8$
- (2) 要素型・添字の要件は上記Swift版の注意を参照。

**計算量**

- $O(n)$

## z_algorithm

```swift
// (1): String
let z = z_algorithm(text)
// (2): Array
let z2 = z_algorithm(values)
```

入力の長さを $n$ として、長さ $n$ の配列を返す。
$i$ 番目の要素は `s[0..n)`と`s[i..n)`のLCP(Longest Common Prefix)の長さ。

**制約**

- $0 \leq n \leq 10^8$
- (2) 要素型・添字の要件は上記Swift版の注意を参照。

**計算量**

- $O(n)$

## 使用例

```swift
import AtCoder

let text = "banana"
let sa = suffix_array(text)
print(sa) // [5, 3, 1, 0, 4, 2]
print(lcp_array(text, sa)) // [1, 3, 0, 0, 2]
print(z_algorithm("aaaa")) // [4, 3, 2, 1]
let characters = Array(text)
print(String(characters[sa[0]...])) // a
```

## 出典

以下の日英原稿をSwift向けに改編： [AtCoder Library (864245a)](https://github.com/atcoder/ac-library/blob/864245a00b00dd008d1abfdc239618fdb7d139da/document_ja/string.md), CC0-1.0.

[目次](README.md) · [共通事項](usage.md)
