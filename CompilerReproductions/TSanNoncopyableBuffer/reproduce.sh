#!/bin/bash
set -eu
cd "$(dirname "$0")"
output=$(mktemp -d "${TMPDIR:-/tmp}/swift-tsan-buffer.XXXXXX")
printf 'Logs and object files: %s\n' "$output"
swiftc --version
failed=0
for configuration in plain-debug plain-release asan-debug tsan-debug tsan-release; do
  case "$configuration" in
    plain-debug) flags=(-Onone) ;;
    plain-release) flags=(-O) ;;
    asan-debug) flags=(-Onone -sanitize=address) ;;
    tsan-debug) flags=(-Onone -sanitize=thread) ;;
    tsan-release) flags=(-O -sanitize=thread) ;;
  esac
  if swiftc "${flags[@]}" -emit-object Repro.swift -o "$output/$configuration.o" > "$output/$configuration.log" 2>&1; then
    printf '%s: compilation succeeded\n' "$configuration"
  else
    status=$?
    printf '%s: compilation failed (exit %s)\n' "$configuration" "$status"
    head -n 6 "$output/$configuration.log"
    failed=1
  fi
done
# A compiler failure remains a nonzero exit, even when it reproduces this report.
exit "$failed"
