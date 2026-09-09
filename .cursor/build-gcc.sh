#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="${GCC_BUILD_DIR:-${HOME}/gcc-build}"
PREFIX="${GCC_PREFIX:-${HOME}/gcc-install}"
JOBS="${GCC_JOBS:-2}"

CONFIGURE_ARGS=(
  --prefix="$PREFIX"
  --enable-languages=c,c++,fortran,lto
  --enable-lto
  --disable-multilib
  --disable-bootstrap
  --disable-nls
)

mkdir -p "$BUILD"
cd "$BUILD"

stamp="$BUILD/cursor-configure.stamp"
desired="$(printf '%s\n' "${CONFIGURE_ARGS[@]}")"
if [[ ! -f Makefile ]] || [[ "$(cat "$stamp" 2>/dev/null || true)" != "$desired" ]]; then
  "$ROOT/configure" "${CONFIGURE_ARGS[@]}"
  printf '%s\n' "$desired" > "$stamp"
fi

make -j"$JOBS"
