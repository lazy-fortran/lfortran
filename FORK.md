# The lazy-fortran fork of LFortran

This fork carries fixes that our projects need before upstream has them, on
top of [lfortran/lfortran](https://github.com/lfortran/lfortran). It lives on
GitHub as lazy-fortran/lfortran.

## Rules

- `main` is the only branch anything depends on. Consumers pin a commit on
  it. `main` is never
  rebased or force-pushed, so pinned commits stay valid.
- A fix meant for upstream is one branch on upstream's `main`, and that
  branch is the head of a draft pull request against lfortran/lfortran (from
  krystophny/lfortran). It follows upstream's rules: its style, its tests,
  one fix per pull request, no merge of `main` into an unreviewed branch.
- The fork uses such a fix by merging its branch into `main` with a merge
  commit titled `Merge lfortran/lfortran#N: TITLE` (see "Merging a pull
  request branch"). When the pull request changes, its branch is merged
  again. A fix that needs another is a branch on top of that one's branch;
  both are merged, the lower one first.
- When upstream merges a pull request, the next sync brings it in and nothing
  has to be removed here.
- Nothing reaches upstream by itself. Pushing a pull request branch, opening
  a pull request and marking one ready are done by hand, and pull requests
  stay drafts until Chris decides.
- Changes that only the fork needs (this file, `.github/ci/`, CI) are
  short-lived branches of one commit each, landed by a pull request through
  the merge queue. The queue merges with a merge commit, so that upstream
  merges keep upstream's history as an ancestor of `main`.
- Upstream is brought in by merging an upstream commit into `main` with a
  merge commit.
- Numbers: `(#17426)` to `(#17440)` and the numbers from `#25` to the move
  back to GitHub (November 2026) on `main` belong to the retired fortyard
  server, not to upstream or to this repository's GitHub pull requests. Upstream is always
  written `lfortran/lfortran#N`.

## Pull requests the fork carries

| Upstream draft | What |
| --- | --- |
| lfortran/lfortran#16370 | report non-constant powers in the wasm backend |
| lfortran/lfortran#16375 | name the type in the wasm backend's power diagnostic (on #16370) |
| lfortran/lfortran#16376 | parse bare I/O statements in an interactive cell |
| lfortran/lfortran#16377 | load libraries and module directories from a cell |
| lfortran/lfortran#17762 | built-in LLD skips GCC directories of other systems (MinGW next to Linux GCC) |
| lfortran/lfortran#17830 | an implicit-interface external procedure is declared by its first call (WebAssembly links it) |
| lfortran/lfortran#17831 | the length of a STOP message is passed to printf as int |
| lfortran/lfortran#17832 | `_lfortran_random_seed` is declared with the runtime's signature |
| lfortran/lfortran#17839 | size of a defined operation used for a function result shape |
| lfortran/lfortran#17847 | a vector-subscripted target is not reallocated on assignment |
| lfortran/lfortran#17851 | bounds of an array section in the LLVM backend |
| lfortran/lfortran#17852 | default initialization of component arrays of an intent(out) dummy |
| lfortran/lfortran#17853 | real power with a negative integer exponent in its full range |
| lfortran/lfortran#17854 | complex VALUE argument of bind(c) passed in memory (WebAssembly) |
| lfortran/lfortran#17855 | integer power with a negative exponent for bases 1 and -1 |
| lfortran/lfortran#17863 | `nearest(0, -1.0)` is the smallest negative subnormal, not NaN |
| lfortran/lfortran#17864 | `scale(x, i)` by `ldexp` for real(4) and real(8), so that it does not overflow where the result is representable |
| lfortran/lfortran#17865 | `spacing` of negative numbers, of `huge` and below `tiny` |
| lfortran/lfortran#17887 | bounds-remapping pointer assignment to a derived-type component |
| lfortran/lfortran#17888 | type-info size of a derived type for the target's layout (class arrays on wasm32) |
| lfortran/lfortran#17889 | SELECT TYPE in a procedure copied to pass arrays by data |
| lfortran/lfortran#17890 | `c_associated` of a `c_ptr` with the POINTER attribute |

Fixes in `main` that have no upstream pull request yet: static storage for
main program variables (bf4b95bcc1), the names a cell defines, uses and
assigns (df3bf93103), LSP union pointers when copying arrays and tuples
(eeb73076d5), `transfer` of an allocatable array to a character mold
(a95f935133), indexing a fixed-size array constant by a variable
(18596e2ab7), and the size of global arrays of characters of kind 2 and 4
(a7a43d599d).

## Style

The Fortran code follows upstream's style and is not formatted with
`fo fmt`.

## The check

`.github/ci/check` runs upstream's own developer workflow in the merge
queue: `pixi run -e llvm11 build`, the reference tests and upstream's smoke
selection of the integration tests. Each night `.github/ci/verify` checks
`main`, the same check with all integration tests. Upstream's own workflows
are removed, so that they do not run on the fork. Both scripts run on Linux x86_64. They
also support macOS arm64, where they have not yet been run. `CHECK_LLVM`
names another LLVM environment of `pixi.toml` (default `llvm11`); the
reference tests need LLVM 11 and are skipped with any other.

## Syncing with upstream

1. On a branch from `main`, `git merge --no-ff <upstream commit>`. Take
   upstream's version of files the fork does not change on purpose, except
   upstream's workflows in `.github/workflows`, which stay removed
   (`git rm` them when the merge brings them back).
2. Check the merge locally (`pixi run -e llvm11 build`, `tests`).
3. Open a pull request of the branch and put it into the merge queue
   (`gh pr merge --auto`). It lands with a merge commit, so upstream's
   history stays an ancestor of `main` and later merges stay small.

## Merging a pull request branch

The same three steps with the pull request's branch in place of the
upstream commit, and the merge titled `Merge lfortran/lfortran#N: TITLE`.
Several branches can be merged at once: merge them one after another into a
branch from upstream's `main`, then merge that branch into `main` as one
merge commit.

## Local commits

fo's pre-commit hook builds LFortran in a staged copy of the repository.
LFortran's build needs sources that `build0.sh` generates, so each clone
sets, once:

```sh
git config fo.hookPrepare 'export PATH=<env with re2c, bison, python>/bin:$PATH; v=$(git describe --tags --match "v[0-9]*" upstream/main 2>/dev/null) || v=v0.0.0; echo "${v#v}" > version; sed "/^source ci\/version.sh/d" build0.sh | bash'
```
