# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- `suffix_array`に`String`と`[Character]`向けのUnicode対応実装を追加
- macOS向けのdeath testを追加
- `SegTreeOperation`と`LazySegTreeOperation`による関数プロパティベースの演算定義を追加
- `SegTree`と`LazySegTree`に`Collection`および範囲からの初期化を追加

### Changed
- Swift tools versionを6.2に更新
- SwiftPM traitsを使って`BENCHMARK`と`_O_UNCHECKED`を切り替える構成に変更
- 依存パッケージのバージョンを更新
- `DSU`, `SegTree`, `LazySegTree`, `MFGraph`, `MCFGraph`, 内部CSRなどを非コピー型と直接メモリ管理中心の実装に変更
- `Executable`ターゲットを`TopLevel`ターゲットへ変更
- `maxflow`, `mincostflow`, `scc`, `two_sat`, `string`まわりの実装とテストを更新

### Fixed
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
