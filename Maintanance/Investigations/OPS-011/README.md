# OPS-011 ASan / TSan調査

対象：swift-ac-library 647a76d。macOS arm64、Apple Swift 6.4。製品コードは変更していない。

## ASan

既存 `swift test --build-system native -c release --sanitize address` はXCTest.XCTAssertNotEqualのデフォルト引数に対する未定義シンボルでリンク失敗。試験は実行されていない。ログacl-asan-release.txt。
代わりにOPS-010比較ドライバを `swift build --build-system native --package-path Maintanance/Investigations/OPS-010/swift -c release --sanitize address` で依存ライブラリごと計装。run-asan.pyで通常比較3486＋数学/フロー境界316＋CRT/畳み込み379＋構造境界132＝4313ケースを実行。全件期待値一致、ASan報告なし。既存XCTest全体の成功ではない。
途中に計装済みオブジェクトを直接リンクする試行もしたが、依存シンボル不足で失敗。上記SwiftPMビルドで解消した。run-asan.pyはOPS-010のコーパス・境界結果を必要とする。

## TSan

全体ReleaseビルドはSwiftコンパイラがInvalid bitcastで停止（acl-tsan-current-build.txt）。DSU単独でも-Ononeで再現（dsu/）。実行時データ競合ではなくコンパイラ問題。TSanを無効化・警告抑制して合格にはしない。
無変更の製品ソースを必要部分だけ直接コンパイルし、4並列で確認：

| 対象 | 結果 |
|---|---|
| 独立FenwickTree/SegTree各100反復 | 警告なし、期待値一致 |
| 法を事前に固定したdynamic ModInt | 警告なし |
| dynamic ModIntのset_modと読取を10000反復 | data race |
| 既定の法のconvolution、61要素×100反復 | 警告なし |
| 同じ数値の独自static_modによるconvolution | Swift access race |

最後の競合はatosで `_Internal.primitive_root_constexpr` → `fft_info.init` → `__static_const_fft_info.info` と特定。原始根の共有キャッシュへの並行アクセス。同一の可変配列を共有していなくても発生する。FFTキャッシュ自体も未同期で、最初の警告で止めるため他の競合を否定しない。ModIntはmod_dynamic.bt.getter/setterを特定。法を並行変更する利用まで保証するかは別の仕様判断。
初回100反復ではset_mod競合は検出なし。10000に増やすと検出。初回のFFT試験はシンボル化込みで40秒を超えたため停止し、symbolize=0で再実行して警告を保存。抑制は使っていない。

## 1.0へ向けて

ユーザー指示「1.0にするにはTSan通したい」。調査タスクはACTIVEを維持。残件は、全体TSanビルド障害、独立した畳み込みで起きる共有キャッシュ競合、対応する並行利用範囲の確定、既存XCTestのリンク障害。共有可変インスタンスの無同期書込みまで自動的に保証しない。今回の部分試験をもって1.0品質達成とはしない。

再現：reproduce.sh（最後のDSUコンパイルは現在失敗する）。バイナリは/tmpへ出力。ASanは上記ビルド後run-asan.py。生ログ・結果を同ディレクトリに保持。
