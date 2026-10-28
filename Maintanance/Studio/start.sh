#!/bin/sh
set -eu
studio_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
exec "$studio_dir/registry" studio --port 8089 --started-by user
