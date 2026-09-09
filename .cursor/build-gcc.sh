#!/usr/bin/env bash
# Dispatcher. Prefer the named scripts directly.
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
mode="${1:-}"
if [[ $# -gt 0 ]]; then
  shift
fi

case "$mode" in
  dev|fast)
    exec "$DIR/build-gcc-dev.sh" "$@"
    ;;
  submit|patch)
    exec "$DIR/build-gcc-submit.sh" "$@"
    ;;
  *)
    echo "Usage: $0 dev|submit [build|check|bootstrap]" >&2
    echo "  $0 dev              fast pass verification (non-bootstrap C/C++/Fortran+LTO)" >&2
    echo "  $0 dev check        same, then make check-gcc" >&2
    echo "  $0 submit           community bootstrap of default languages" >&2
    echo "  $0 submit check     make -k check + test_summary (after bootstrap)" >&2
    exit 2
    ;;
esac
