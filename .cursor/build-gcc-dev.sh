#!/usr/bin/env bash
# Fast rebuild for middle-end pass work. Not the configuration to cite on gcc-patches.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="${GCC_BUILD_DIR:-${HOME}/gcc-build-dev}"
PREFIX="${GCC_PREFIX:-${HOME}/gcc-install-dev}"
JOBS="${GCC_JOBS:-2}"
ACTION="${1:-build}"

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

case "$ACTION" in
  build)
    make -j"$JOBS"
    ;;
  check)
    make -j"$JOBS"
    make -j"$JOBS" check-gcc
    ;;
  *)
    echo "Usage: $0 [build|check]" >&2
    echo "  build  out-of-tree non-bootstrap C/C++/Fortran+LTO (default)" >&2
    echo "  check  build, then make check-gcc" >&2
    exit 2
    ;;
esac
