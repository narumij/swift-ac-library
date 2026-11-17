#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
# Always re-verify, including after manifest, dependency or toolchain changes.
rm -f .verify-helper/timestamps.local.json .verify-helper/timestamps.remote.json
oj-verify run --jobs 1 --tle 10 Verification/UnionFind/unionfind.test.swift
