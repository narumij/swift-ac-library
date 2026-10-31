#!/bin/sh
set -eu
cd "$(dirname "$0")"
./bootstrap.sh
binary="$(swift build -c release --show-bin-path)/benchmark"
output=${1:-Results/$(date +%Y%m%d-%H%M%S)}
max_size=${MAX_SIZE:-2M}
cycles=${CYCLES:-3}
mkdir -p "$output"
{
  date -u
  uname -a
  sysctl -n machdep.cpu.brand_string 2>/dev/null || true
  swift --version
  clang++ --version
  printf 'Swift library revision: '
  git -C .. rev-parse HEAD
  git -C .. status --short
  printf 'C++ ACL revision: '
  git -C .build/ac-library rev-parse HEAD
  printf 'MAX_SIZE=%s CYCLES=%s\n' "$max_size" "$cycles"
  printf 'Release: Swift -O; C++ explicit -O3 -DNDEBUG; sanitizers OFF\n'
} > "$output/environment.txt"
cp Package.resolved "$output/Package.resolved.json"
"$binary" verify > "$output/verification.txt"
"$binary" verify-extended >> "$output/verification.txt"
"$binary" verify-flow-phases >> "$output/verification.txt"
cp library.json "$output/library.json"
"$binary" library run --library library.json "$output/results.json" \
  --max-size "$max_size" --smoothness 1 --disable-cutoff true --cycles "$cycles" --mode replace-all > "$output/run.log" 2>&1
"$binary" library render --library library.json "$output/results.json" \
  --output "$output" --format png > "$output/render.log" 2>&1
printf 'Results and charts: %s\n' "$output"
