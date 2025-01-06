# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
