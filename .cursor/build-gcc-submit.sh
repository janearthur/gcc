#!/usr/bin/env bash
# Patch-submission build. Matches Testing Patches in
# https://gcc.gnu.org/contribute.html for changes outside a front end:
# bootstrap all default languages, then run all testsuites.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="${GCC_BUILD_DIR:-${HOME}/gcc-build-submit}"
PREFIX="${GCC_PREFIX:-${HOME}/gcc-install-submit}"
JOBS="${GCC_JOBS:-2}"
ACTION="${1:-bootstrap}"

CONFIGURE_ARGS=(
  --prefix="$PREFIX"
  --enable-languages=default
)

# contribute.html requires at least one target, not multilib. Disable
# multilib when the host cannot compile -m32, which is typical on Cloud VMs.
if ! echo 'int main(void){return 0;}' | gcc -m32 -x c - -o /dev/null >/dev/null 2>&1; then
  CONFIGURE_ARGS+=(--disable-multilib)
  echo "No working -m32 toolchain; configuring with --disable-multilib."
fi

mkdir -p "$BUILD"
cd "$BUILD"

stamp="$BUILD/cursor-configure.stamp"
desired="$(printf '%s\n' "${CONFIGURE_ARGS[@]}")"
if [[ ! -f Makefile ]] || [[ "$(cat "$stamp" 2>/dev/null || true)" != "$desired" ]]; then
  "$ROOT/configure" "${CONFIGURE_ARGS[@]}"
  printf '%s\n' "$desired" > "$stamp"
fi

case "$ACTION" in
  bootstrap|build)
    make -j"$JOBS" bootstrap
    ;;
  check)
    if [[ ! -f Makefile ]]; then
      echo "Configure/bootstrap first: $0 bootstrap" >&2
      exit 1
    fi
    set +e
    make -k -j"$JOBS" check
    check_status=$?
    set -e
    if [[ -x "$ROOT/contrib/test_summary" ]]; then
      "$ROOT/contrib/test_summary" || true
    fi
    exit "$check_status"
    ;;
  *)
    echo "Usage: $0 [bootstrap|check]" >&2
    echo "  bootstrap  3-stage bootstrap of default languages (C/C++/Fortran/ObjC + LTO)" >&2
    echo "  check      make -k check and contrib/test_summary (run after bootstrap)" >&2
    exit 2
    ;;
esac
