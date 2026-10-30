#!/bin/bash
set -eu
cd "$(dirname "$0")"
mkdir -p logs
clang++ -std=c++17 -O0 -g -I upstream cpp.cpp -o cpp-debug > logs/cpp-debug.txt 2>&1
clang++ -std=c++17 -O2 -I upstream cpp.cpp -o cpp-release > logs/cpp-release.txt 2>&1
swift build --build-system native --package-path swift > logs/swift-debug.txt 2>&1
swift build --build-system native --package-path swift -c release > logs/swift-release.txt 2>&1
