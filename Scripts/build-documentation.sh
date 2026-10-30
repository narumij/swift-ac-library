#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

output="${1:-.build/documentation}"
scratch="${DOC_BUILD_PATH:-.build/documentation-build}"
symbols="$scratch/atcoder-symbols"
mkdir -p "$symbols"

# SwiftPM's plugin symbol-graph build enables all traits, including TSAN_TEST.
# Extract from a normal build instead, so DSU and MCFGraph remain documented.
swift build --scratch-path "$scratch" --build-system native -c release --target AtCoder
bin_path="$(swift build --scratch-path "$scratch" --build-system native -c release --show-bin-path)"
target="$(swiftc -print-target-info | python3 -c 'import json,sys; print(json.load(sys.stdin)["target"]["triple"])')"
extractor="$(command -v swift-symbolgraph-extract)"
sdk_args=()
if [[ "$(uname -s)" == "Darwin" ]]; then
  extractor="$(xcrun --find swift-symbolgraph-extract)"
  sdk_args=(-sdk "$(xcrun --show-sdk-path)")
fi
"$extractor" -module-name AtCoder -I "$bin_path/Modules" \
  -target "$target" "${sdk_args[@]}" -minimum-access-level public -output-dir "$symbols"
python3 - "$symbols/AtCoder.symbols.json" <<'PY'
import json, sys
with open(sys.argv[1]) as f:
    symbols = json.load(f)["symbols"]
names = {s["names"]["title"] for s in symbols}
for required in ("DSU", "MCFGraph"):
    if not any(n == required or n.startswith(required + "<") for n in names):
        raise SystemExit("Missing public API in documentation: " + required)
PY

if [[ "$(uname -s)" == "Darwin" ]]; then
  docc_bin="$(xcrun --find docc)"
elif command -v docc >/dev/null 2>&1; then
  docc_bin="$(command -v docc)"
else
  docc_bin="$(xcrun --find docc)"
fi
"$docc_bin" convert Sources/AtCoder/AtCoder.docc \
  --additional-symbol-graph-dir "$symbols" \
  --output-path "$output" --fallback-display-name AtCoder \
  --fallback-bundle-identifier org.narumij.AtCoder \
  --transform-for-static-hosting --hosting-base-path swift-ac-library \
  --warnings-as-errors
