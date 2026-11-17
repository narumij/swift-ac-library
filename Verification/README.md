# Library Checker verification

このリポジトリの公開機能を使ってLibrary Checkerの問題を解きます。対象は「機能ごとに1問」で、全オーバーロード・補助メソッド・境界条件を個別に網羅するものではありません。通常の単体試験・サニタイザ試験を補う利用例の検証です。Releaseビルドした解答をLibrary Checkerの公開テストケースとチェッカーで検証します。AtCoderの本番テストを取得するものではなく、オンラインへの解答提出も行いません。

## 公開機能との対応

| 公開機能 | Library Checker問題 | 主な使用箇所 |
| --- | --- | --- |
| `DSU` | [Unionfind](https://judge.yosupo.jp/problem/unionfind) | `merge` / `same` |
| `FenwickTree` | [Point Add Range Sum](https://judge.yosupo.jp/problem/point_add_range_sum) | `add` / `sum` |
| `SegTree` | [Point Set Range Composite](https://judge.yosupo.jp/problem/point_set_range_composite) | 非可換な合成、`set` / `prod` |
| `LazySegTree` | [Range Affine Range Sum](https://judge.yosupo.jp/problem/range_affine_range_sum) | アフィン更新、`apply` / `prod` |
| `MFGraph` | [Bipartite Matching](https://judge.yosupo.jp/problem/bipartitematching) | 最大流からマッチングを復元 |
| `MCFGraph` | [Assignment Problem](https://judge.yosupo.jp/problem/assignment) | 最小費用流から順列を復元 |
| `SCCGraph` | [Strongly Connected Components](https://judge.yosupo.jp/problem/scc) | 成分とトポロジカル順 |
| `TwoSAT` | [Two Sat](https://judge.yosupo.jp/problem/two_sat) | 充足判定と割当の復元 |
| `pow_mod` | [Binomial Coefficient (Prime Mod)](https://judge.yosupo.jp/problem/binomial_coefficient_prime_mod) | 階乗の逆元をFermatの小定理で計算 |
| `inv_mod` | 同上 | 逆階乗の起点を計算 |
| `floor_sum` | [Sum of Floor of Linear](https://judge.yosupo.jp/problem/sum_of_floor_of_linear) | 各ケースを直接計算 |
| `crt` | [Convolution (Mod 1000000007)](https://judge.yosupo.jp/problem/convolution_mod_1000000007) | 2つの素数の剰余から係数を復元 |
| `convolution` | [Convolution](https://judge.yosupo.jp/problem/convolution_mod) | 998244353での畳み込み |
| `convolution_ll` | [Convolution (Mod 1000000007)](https://judge.yosupo.jp/problem/convolution_mod_1000000007) | 分割した係数の整数畳み込み |
| `suffix_array` | [Suffix Array](https://judge.yosupo.jp/problem/suffixarray) | 接尾辞配列を直接出力 |
| `lcp_array` | [Number of Substrings](https://judge.yosupo.jp/problem/number_of_substrings) | LCP総和から異なる部分文字列数を計算 |
| `z_algorithm` | [Z Algorithm](https://judge.yosupo.jp/problem/zalgorithm) | Z配列を直接出力 |
| `static_modint` | [Range Affine Range Sum](https://judge.yosupo.jp/problem/range_affine_range_sum)等 | 固定法での演算 |
| `dynamic_modint` | [Binomial Coefficient (Prime Mod)](https://judge.yosupo.jp/problem/binomial_coefficient_prime_mod) | 入力された法の設定と階乗・逆階乗の演算 |

`SegTreeOperator` / `LazySegTreeOperator` / `static_mod`等の構成用プロトコルは、これらの解答で使用します。型の別名、数値変換の補助型、`clone`や予約容量等の追加メソッドには独立の問題を割り当てていません。

### 合成解法の前提

- Assignmentの負の費用には共通の定数を足します。どの解も行列の辺をちょうどN本使うので最適解は変わらず、`MCFGraph`の非負費用という前提を守れます。出力時にN倍を引きます。
- 1000000007での畳み込みは係数を15ビットずつに分割します。分割後の畳み込み係数はInt64に収まり、低位部分は2素数の積未満なので`crt`で一意に復元できます。`convolution_ll`に範囲外の巨大係数を渡しません。
- 二項係数は問題の制約`n < m`と素数の法を使います。逆階乗の起点を`inv_mod`で求める解答と、`pow_mod`で求める解答を別々に用意しています（15問題・16解答）。どちらも通常の解答として公式チェッカーで判定します。合成数・非互いに素な入力等まで網羅する試験ではありません。
- 解の表現が複数あるグラフ問題は、文字列一致ではなくLibrary Checkerの専用チェッカーで判定します。

### practice2との対応

[practice2](https://atcoder.jp/contests/practice2/tasks)の出典7問も含みます。A=Unionfind、B=Point Add Range Sum、C=Sum of Floor of Linear、F=Convolution、G=SCC、I=Number of Substrings、K=Range Affine Range Sumです。AtCoderのA〜Lそのものを検証するものではありません。

通常のパッケージから検証用の依存・実行ターゲットを分離しています。GitHub Actionsの`Library Checker`はmain向けPR、mainへのpush、手動実行で動きます。既存の通常試験・サニタイザ試験とは別です。

## ローカルで実行

Swift 6.2以降、Python 3.12、Git、C++コンパイラが必要です。Library Checkerのケース生成とチェッカーのビルドにはC++を使います。初回はネットワーク接続が必要です。

リポジトリ直下で:

```sh
python3 -m venv Verification/.venv
. Verification/.venv/bin/activate
python -m pip install -r Verification/requirements.txt
bash Verification/run.sh
```

macOSで別途導入したSwiftとXcode SDKが合わない場合は、Xcode付属のSwiftを使ってください。

```sh
PATH="$(dirname "$(xcrun --find swift)"):$PATH" bash Verification/run.sh
```

実行のたびに検証済み記録を消して全登録問題を再検証します。ローカルでは取得済みケースを再利用しますが、CIではケース・検証済み記録をキャッシュしません。1ケース10秒はCI用の余裕を含む制限で、公式ジャッジの実行時間保証や性能評価ではありません。

問題を追加するときは、検証用ターゲット、`PROBLEM`コメント付きの`.test.swift`、`build.sh`の対応表を追加してください。`run.sh`は`Verification/*/*.test.swift`を全件実行します。

- [verification-helperのカスタム言語設定](https://online-judge-tools.github.io/verification-helper/document.html#settings-for-other-languages)
