#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="${GCC_BUILD_DIR:-${HOME}/gcc-build}"
PREFIX="${GCC_PREFIX:-${HOME}/gcc-install}"
JOBS="${GCC_JOBS:-2}"

mkdir -p "$BUILD"
cd "$BUILD"

if [[ ! -f Makefile ]]; then
  "$ROOT/configure" \
    --prefix="$PREFIX" \
    --enable-languages=c,c++ \
    --disable-multilib \
    --disable-bootstrap \
    --disable-nls
fi

make -j"$JOBS"
