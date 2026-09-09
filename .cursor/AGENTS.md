# Cursor Cloud specific instructions

This fork is for Cloud Agent work against GCC `master`. Upstream GCC does not accept GitHub pull requests; after a change is ready, export `git format-patch` and send it to `gcc-patches@gcc.gnu.org`.

Always build out of tree. Cloud VMs have about 16GB RAM and no swap; keep `GCC_JOBS=2` unless a higher `-j` is known not to OOM. The two build trees must not be mixed: they use different `$HOME/gcc-build-*` directories.

## Fast pass verification

Use this while iterating on a middle-end pass. It is **not** the configuration to report on `gcc-patches`.

```bash
./.cursor/build-gcc-dev.sh          # or: ./.cursor/build-gcc.sh dev
./.cursor/build-gcc-dev.sh check    # build + make check-gcc
```

Configure flags: `--enable-languages=c,c++,fortran,lto --enable-lto --disable-multilib --disable-bootstrap --disable-nls`.

Targeted tests instead of the full C suite:

```bash
cd "$HOME/gcc-build-dev"
make -j2 check-gcc RUNTESTFLAGS="dg.exp=the-test-name.c"
```

## Patch submission (community)

Follow [Testing Patches](https://gcc.gnu.org/contribute.html) for changes that are not isolated to a non-C/C++ front end: bootstrap **all default languages** and run **all testsuites**. Default languages are C, C++, Fortran, and Objective-C; LTO is on because `--enable-lto` defaults to enabled. Do not pass `--disable-bootstrap`. Leave `--enable-checking` unset so trunk keeps `yes,extra`. See [Installing GCC: Configuration](https://gcc.gnu.org/install/configure.html).

```bash
./.cursor/build-gcc-submit.sh           # or: ./.cursor/build-gcc.sh submit
./.cursor/build-gcc-submit.sh check     # make -k check + contrib/test_summary
```

`--disable-multilib` is added only when `gcc -m32` does not work. That is still a valid single-target test. Compare results to a pre-patch run or to recent [gcc-testresults](https://gcc.gnu.org/pipermail/gcc-testresults/) posts; the script cannot do that comparison by itself.

Do not add Ada, Go, D, or other non-default languages on the Cloud VM.
