# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
