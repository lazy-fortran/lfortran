# The lazy-fortran fork of LFortran

This fork carries fixes that our projects need before upstream has them, on
top of [lfortran/lfortran](https://github.com/lfortran/lfortran). Its primary
copy is on fortyard (https://code.tugraz.at/yard/lfortran); GitHub
(lazy-fortran/lfortran) is a mirror that fortyard pushes `main` to.

## Rules

- `main` is the only branch anything depends on. Consumers pin a commit on
  it; fortyard's web build pins one in `web/lfortran.rev`. `main` is never
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
- Changes that only the fork needs (this file, `.fortyard/`, CI) are
  short-lived branches landed on fortyard as one squashed commit
  (`fy land lfortran BRANCH`).
- Upstream is brought in by merging an upstream commit into `main` with a
  merge commit.
- Numbers: the fork's changes and issues on fortyard count on from its
  GitHub numbers (`#25` and up). `(#17426)` to `(#17440)` on `main` are
  fortyard numbers from before that and not upstream's. Upstream is always
  written `lfortran/lfortran#N`.

## Pull requests the fork carries

| Upstream draft | What |
| --- | --- |
| lfortran/lfortran#16370 | report non-constant powers in the wasm backend |
| lfortran/lfortran#16375 | name the type in the wasm backend's power diagnostic (on #16370) |
| lfortran/lfortran#16376 | parse bare I/O statements in an interactive cell |
| lfortran/lfortran#16377 | load libraries and module directories from a cell |

Fixes in `main` that have no upstream pull request yet: static storage for
main program variables (bf4b95bcc1), the names a cell defines, uses and
assigns (df3bf93103), and LSP union pointers when copying arrays and tuples
(eeb73076d5).

## Style

The Fortran code follows upstream's style, so `.fortyard/format-exclude`
exempts it from fortyard's `fo fmt` check.

## The check

`.fortyard/check` runs upstream's own developer workflow on a fortyard
runner: `pixi run -e llvm11 build`, the reference tests and upstream's smoke
selection of the integration tests. The runner keeps the build tree, the
pixi environments and sccache between checks, so a check takes about two
minutes. GitHub Actions run upstream's full workflows after each push to
`main`, as advisory coverage of all platforms and LLVM versions.
After each landing fortyard also verifies `main` with `.fortyard/verify`, the
same check with all integration tests; a regression it finds is bisected to
its commit and reported as an issue.

## Syncing with upstream

1. On a branch from `main`, `git merge --no-ff <upstream commit>`. Take
   upstream's version of files the fork does not change on purpose,
   including `.github/workflows`.
2. Check the merge locally (`pixi run -e llvm11 build`, `tests`).
3. Land the branch (`fy land lfortran BRANCH`). A branch that is `main` plus
   one merge commit lands as that merge, so upstream's history stays an
   ancestor of `main` and later merges stay small. If `main` moved in the
   meantime, fortyard refuses it; merge again on the current `main`.

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
