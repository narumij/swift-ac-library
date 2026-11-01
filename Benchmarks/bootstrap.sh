#!/bin/sh
set -eu
cd "$(dirname "$0")"
revision=864245a00b00dd008d1abfdc239618fdb7d139da
if [ ! -d .build/ac-library/.git ]; then
  mkdir -p .build
  git clone https://github.com/atcoder/ac-library.git .build/ac-library
fi
git -C .build/ac-library checkout --detach "$revision"
swift build -c release
