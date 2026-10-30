#!/bin/bash
set -eu
cd "$(dirname "$0")/../../.."
out=/tmp/acl-sanitizers-repro
mkdir -p "$out"
base=Sources/AtCoder
shared=("$base/internal.swift" "$base/internal_bit.swift" "$base/internal_math.swift" "$base/internal_mod.swift" "$base/internal_mod_value.swift" "$base/internal_type_trait.swift" "$base/modint.swift")
swiftc -O -sanitize=thread "${shared[@]}" "$base/math.swift" "$base/convolution.swift" "$base/internal_convolution.swift" Maintanance/Investigations/OPS-011/main.swift -o "$out/probe"
for mode in fixed-mod changing-mod fft-builtin fft-custom; do
  TSAN_OPTIONS=halt_on_error=1:symbolize=0 "$out/probe" "$mode" > "$out/$mode.txt" 2>&1 || printf '%s exit=%s\n' "$mode" "$?"
done
swiftc -O -sanitize=thread "${shared[@]}" "$base/fenwicktree.swift" "$base/segtree.swift" Maintanance/Investigations/OPS-011/independent/main.swift -o "$out/independent"
"$out/independent"
# The following currently reproduces a Swift compiler failure (Invalid bitcast).
swiftc -Onone -sanitize=thread "$base/dsu.swift" Maintanance/Investigations/OPS-011/dsu/main.swift -o "$out/dsu"
