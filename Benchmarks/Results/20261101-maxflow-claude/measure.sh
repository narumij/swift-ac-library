#!/bin/sh
# Usage: measure.sh <dir> <before-binary> <after-binary>
# before/after/after/before, 5 cycles each, sizes 128-32K, MaxFlow only.
set -eu
dir=$1; before=$2; after=$3
mkdir -p "$dir"
rm -f "$dir/before.json" "$dir/after.json"
for pair in "before:$before" "after:$after" "after:$after" "before:$before"; do
  name=${pair%%:*}; bin=${pair#*:}
  "$bin" run "$dir/$name.json" --filter 'MaxFlow sparse network' \
    --min-size 128 --max-size 32K --smoothness 1 --disable-cutoff true \
    --cycles 5 --mode append > /dev/null 2>&1
done
python3 "$(dirname "$0")/summarize.py" "$dir"
