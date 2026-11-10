# The lazy-fortran fork of LFortran

This fork carries fixes that our projects need before upstream has them, on
top of [lfortran/lfortran](https://github.com/lfortran/lfortran). Its primary
copy is on fortyard (https://code.tugraz.at/yard/lfortran); GitHub
(lazy-fortran/lfortran) is a mirror that fortyard pushes `main` to.

## Rules

- `main` is the only branch anything depends on. Consumers pin a commit on
  it; fortyard's web build pins one in `web/lfortran.rev`.
- Every change is a short-lived branch pushed to fortyard and landed there
  (`fy land lfortran BRANCH`). fortyard runs `.fortyard/check` on it and
  lands it as one squashed commit. No branch stays around.
- Upstream is brought in by merging an upstream commit into `main` with a
  merge commit. `main` is never rebased or force-pushed, so pinned commits
  stay valid.
- Fixes worth offering upstream are listed in the GitHub issue "Fixes to
  offer upstream"; each is one squashed commit here, so it cherry-picks
  cleanly.

## The check

`.fortyard/check` runs upstream's own developer workflow on a fortyard
runner: `pixi run -e llvm11 build`, the reference tests and upstream's smoke
selection of the integration tests. The runner keeps the build tree, the
pixi environments and sccache between checks, so a check takes about two
minutes. GitHub Actions run upstream's full workflows after each push to
`main`, as advisory coverage of all platforms and LLVM versions.

## Syncing with upstream

1. On a branch from `main`, `git merge --no-ff <upstream commit>`. Take
   upstream's version of files the fork does not change on purpose,
   including `.github/workflows`.
2. Check the merge locally (`pixi run -e llvm11 build`, `tests`) or by
   pushing the branch to fortyard.
3. An administrator pushes the merge commit to `main` on fortyard: landing
   would squash it, which would make every later upstream merge conflict.

## Local commits

fo's pre-commit hook builds LFortran in a staged copy of the repository.
LFortran's build needs sources that `build0.sh` generates, so each clone
sets, once:

```sh
git config fo.hookPrepare 'export PATH=<env with re2c, bison, python>/bin:$PATH; v=$(git describe --tags --match "v[0-9]*" upstream/main 2>/dev/null) || v=v0.0.0; echo "${v#v}" > version; sed "/^source ci\/version.sh/d" build0.sh | bash'
```
