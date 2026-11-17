# Library Checker verification

[AtCoder Library Practice Contest（practice2）](https://atcoder.jp/contests/practice2/tasks)で出典として挙げられているLibrary Checkerの7問を、このリポジトリの`AtCoder`製品で解きます。Releaseビルドした解答をLibrary Checkerの公開テストケースとチェッカーで検証します。AtCoderの本番テストを取得するものではなく、オンラインへの解答提出も行いません。

| practice2 | Library Checker | 検証するAPI |
| --- | --- | --- |
| A | [Unionfind](https://judge.yosupo.jp/problem/unionfind) | `DSU` |
| B | [Point Add Range Sum](https://judge.yosupo.jp/problem/point_add_range_sum) | `FenwickTree<Int>` |
| C | [Sum of Floor of Linear](https://judge.yosupo.jp/problem/sum_of_floor_of_linear) | `floor_sum` |
| F | [Convolution](https://judge.yosupo.jp/problem/convolution_mod) | `convolution`（998244353） |
| G | [Strongly Connected Components](https://judge.yosupo.jp/problem/scc) | `SCCGraph` |
| I | [Number of Substrings](https://judge.yosupo.jp/problem/number_of_substrings) | `suffix_array`、`lcp_array` |
| K | [Range Affine Range Sum](https://judge.yosupo.jp/problem/range_affine_range_sum) | `LazySegTree`、`modint998244353` |

D・E・H・J・Lはこの出典一覧に含まれず、今回の検証対象外です。SCCのように正解の表現が複数ある問題も、文字列一致ではなくLibrary Checkerのチェッカーで判定します。

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
