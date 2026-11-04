# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-11-05
### Added
- `suffix_array`に`String`と`[Character]`向けのUnicode対応実装を追加
- macOS・Linux向けの異常終了テストを追加
- `SegTreeOperation`と`LazySegTreeOperation`による関数プロパティベースの演算定義を追加
- `SegTree`と`LazySegTree`に`Collection`および範囲からの初期化を追加

- `MFGraph.reserveCapacity(edgeCounts:)`による頂点ごとの隣接辺ストレージの予約を追加
- 英語のDocCと日本語のMarkdownガイドを整備し、mainのDocCをGitHub Pagesで公開
- C++版ACLとの比較ベンチマークとチャートを追加
- C++版とのランダム比較・整数境界のテストを追加。確認範囲と残る制限事項を`KNOWN_LIMITATIONS.md`に記載
- ASan・TSan用のCIと`ASAN_TEST`・`TSAN_TEST` traitsを追加（異常終了テストなど、一部は対象外）

### Changed
- Swift tools versionを6.2に更新
- SwiftPM traitsを使って`BENCHMARK`と`_O_UNCHECKED`を切り替える構成に変更
- 依存パッケージのバージョンを更新
- `DSU`, `SegTree`, `LazySegTree`, `MFGraph`, `MCFGraph`, 内部CSRなどを非コピー型と直接メモリ管理中心の実装に変更
- `Executable`ターゲットを`TopLevel`ターゲットへ変更
- `maxflow`, `mincostflow`, `scc`, `two_sat`, `string`まわりの実装とテストを更新

- テストをSwift Testingへ移行し、オリジナルACL相当と追加テストをファイル構成で分離
- SCCの探索を明示的なスタックへ変更し、CSR構築とグループ化を改善
- 最大流の隣接辺ストレージ、最小費用流の作業バッファ再利用、セグメント木・文字列・畳み込み処理の一意性検査や整数演算のオーバーヘッドを削減

### Fixed
- SCCの深いグラフで再帰によるスタックオーバーフローが起きる問題を修正
- `floor_sum`の中間演算を符号なし整数として扱い、負の係数や整数境界付近での誤計算・停止を修正
- `ModInt`へ小さい整数型から入力するときの変換と、畳み込みキャッシュの型識別を修正
- `z_algorithm`の不具合を修正
- 内部CSRのクラッシュを修正
- Sendable関連のコンパイル問題を修正

## [0.1.29] - 2025-9-6
### Added
- `SegTree`と`LazySegTree`に要素生成クロージャを受け取る初期化を追加

## [0.1.28] - 2025-9-4
### Changed
- Sendable対応を更新

## [0.1.27] - 2025-9-3
### Changed
- READMEを更新

## [0.1.26] - 2025-8-15
### Fixed
- maxflowの不具合を修正

## [0.1.25] - 2025-7-30
### Changed
- segtreeとlazy_segtreeの実装とテストを更新

## [0.1.24] - 2025-7-20
### Changed
- sccのLibrary Checker向け確認を反映

## [0.1.23] - 2025-7-18
### Changed
- CHANGELOGを更新

## [0.1.22] - 2025-7-18
### Fix
- macOSのswiftコマンドでreleaseビルドでクラッシュする不具合の迂回

## [0.1.21] - 2025-7-18
## [0.1.20] - 2025-7-18
- タグミス

## [0.1.14] - 2025-6-14
### Changed
- 些末な修正

## [0.1.14] - 2025-6-13
### Changed
- convolution_llの型を変更
- internal mathの型を変更

## [0.1.13] - 2025-6-10
### Changed
- internal mathの型を変更

## [0.1.12] - 2025-6-10
### Changed
- modintの内部データ型を変更

## [0.1.11] - 2025-6-9
### Added
- modintにuvalプロパティを追加

## [0.1.10] - 2025-6-5
### Changed
- チューニング等

## [0.1.9] - 2025-5-31
### Changed
- `get`アクセサを`_read`アクセサに変更

## [0.1.8] - 2025-5-10
### Added
- 事前定義のfft_infoを追加
### Changed
- convolutionのbutterfly演算でのキャスト回数を削減する修正

## [0.1.7] - 2025-5-7
### Changed
- floor_sumの商と余の演算をquotientAndRemainderに変更
- sccの内部実装をポインタ主体に変更

## [0.1.6] - 2025-5-6
### Changed
- convolutionのbatterfly演算での数値キャスト方法を一部変更

## [0.1.5] - 2025-5-4
### Changed
- ac-library v1.6の変更を反映
- SegtreeOperatorやLazySegtreeOperatorのTを大文字に変更
- SegTreeOperator及びLazySegTreeOperatorを関数オブジェクトではなく静的関数を用いるよう変更
- SCCの各メソッドにインライン属性の追加
- SCCの内部実装から型引数を除去
- SCCの内部実装でポインタを用いるよう変更

## [0.1.4] - 2025-1-18
### Changed
- 依存パッケージバージョンの固定

## [0.1.3] - 2025-1-7
### Changed
- Ouncheckedフラグの再追加

## [0.1.2] - 2025-1-7
### Changed
- linuxでint128を利用するよう変更 (internal_math)
- 引数をIntのみに変更 (math)
- CapやCostに浮動小数点数が指定できるよう変更 (maxflow, mincostflow)
- 型変数名を修正 (segtree, lazy_segtree)
- ビット演算の際のキャストの削減 (internal_bit, segtree, lazy_setree, convolution)
- コンパイラフラグ-Ouncheckedの追加

## [0.1.1] - 2025-1-2
### Changed
- 複数のデータ構造を、ManagedBufferを利用する構造に変更
- ビルドターゲットをSwift 5.10から6.0に変更

## [0.1.0] - 2024-11-9
### Changed
- ジャッジ用の初期バージョン
