# Cursor Cloud specific instructions

This fork is for Cloud Agent work against GCC `master`. Upstream GCC does not accept GitHub pull requests; after a change is ready, export `git format-patch` and send it to `gcc-patches@gcc.gnu.org`.

## Build

Cloud VMs have about 16GB RAM and no swap. Always use an **out-of-tree**, **non-bootstrap** build. From the repository root:

```bash
./.cursor/build-gcc.sh
```

Or equivalently:

```bash
mkdir -p "$HOME/gcc-build"
cd "$HOME/gcc-build"
<repo-root>/configure \
  --prefix="$HOME/gcc-install" \
  --enable-languages=c,c++,fortran,lto \
  --enable-lto \
  --disable-multilib \
  --disable-bootstrap \
  --disable-nls
make -j2
```

- Use `make -j2` unless you have confirmed a higher `-j` does not OOM.
- Keep C/C++/Fortran + LTO. Do not add Ada, Go, D, or Rust on the default Cloud VM.
- Do not enable bootstrap on the default Cloud VM.
- Do not build inside the source tree.

## Test

After `make`, run a targeted test, not the full suite:

```bash
cd "$HOME/gcc-build"
make -j2 check-gcc RUNTESTFLAGS="dg.exp=the-test-name.c"
# Fortran / LTO as needed:
# make -j2 check-fortran
# make -j2 check-gcc RUNTESTFLAGS="lto.exp=the-test-name.c"
```
