#!/bin/sh
# Run locally in Terminal: recording may require Instruments permissions.
set -eu
cd "$(dirname "$0")"
repo_dir=$(cd .. && pwd)
output=$(mktemp -d "$repo_dir/artifacts/maxflow-profile-XXXXXX")
# Match the Xcode SDK and compiler, independent of a shell-installed Swift.
export TOOLCHAINS=com.apple.dt.toolchain.XcodeDefault
swift_bin=$(xcrun --toolchain "$TOOLCHAINS" --find swift)
export PATH="$(dirname "$swift_bin"):$PATH"
if ! "$swift_bin" build -c release > "$output/build.log" 2>&1; then
  cat "$output/build.log" >&2
  exit 1
fi
bin_dir=$("$swift_bin" build -c release --show-bin-path)
cp "$bin_dir/benchmark" "$output/benchmark"
if [ -d "$bin_dir/benchmark.dSYM" ]; then
  cp -R "$bin_dir/benchmark.dSYM" "$output/benchmark.dSYM"
fi
{
  date -u
  "$swift_bin" --version
  uname -a
  git -C "$repo_dir" rev-parse HEAD
  git -C "$repo_dir" status --short
} > "$output/environment.txt"
git -C "$repo_dir" diff -- Sources Benchmarks/Sources > "$output/changes.diff"
printf 'Output: %s\n' "$output"
for language in Swift C++; do
  case "$language" in
    Swift) name=swift; filter='^Swift MaxFlow sparse network$' ;;
    C++) name=cpp; filter='^C\+\+ MaxFlow sparse network$' ;;
  esac
  xcrun xctrace record --template 'Time Profiler' --time-limit 30s \
    --output "$output/$name.trace" \
    --target-stdout "$output/$name.log" \
    --launch -- "$output/benchmark" run "$output/$name.json" \
    --filter "$filter" --min-size 32K --max-size 32K \
    --disable-cutoff true --min-duration 0.1
 done
printf '\nRecordings saved to: %s\n' "$output"
printf 'Open: open "%s/swift.trace"\n' "$output"
