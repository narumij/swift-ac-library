#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
case "$1" in
  Verification/UnionFind/unionfind.test.swift) product=UnionFind ;;
  *) echo "Unknown verification source: $1" >&2; exit 1 ;;
esac
swift build --package-path Verification -c release --product "$product"
bin_dir=$(swift build --package-path Verification -c release --show-bin-path)
mkdir -p "$2"
cp "$bin_dir/$product" "$2/a.out"
