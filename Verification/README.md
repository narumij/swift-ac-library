# Library Checker verification

Union-Findの解答を、このリポジトリの`AtCoder`製品を使ってReleaseビルドし、Library Checkerの公開テストケースとチェッカーで検証します。オンラインへの解答提出は行いません。

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

問題を追加するときは、検証用ターゲット、`PROBLEM`コメント付きの`.test.swift`、`build.sh`の対応表、`run.sh`の実行対象を追加してください。

- [Union-Find](https://judge.yosupo.jp/problem/unionfind)
- [verification-helperのカスタム言語設定](https://online-judge-tools.github.io/verification-helper/document.html#settings-for-other-languages)
