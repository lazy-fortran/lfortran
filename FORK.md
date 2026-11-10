# The lazy-fortran fork of LFortran

This fork carries fixes that our projects need before upstream has them,
on top of [lfortran/lfortran](https://github.com/lfortran/lfortran).

## Rules

- `main` is the only branch anything depends on. Consumers pin a commit on
  it; fortyard's web build pins one in `web/lfortran.rev`.
- Every change is a short-lived branch and a pull request here, squash-merged
  through the merge queue as soon as its checks pass, and its branch deleted.
  No pull request stays open.
- Upstream is brought in by merging an upstream commit into `main` with a
  merge commit. `main` is never rebased or force-pushed, so pinned commits
  stay valid.
- Fixes worth offering upstream are listed in the issue "Fixes to offer
  upstream"; each is one squashed commit here, so it cherry-picks cleanly.

## Fixing a defect

1. Reproduce it with a test in the repository's own test suites that fails
   before the fix.
2. Fix it on a branch, open a pull request and add it to the merge queue
   (`gh pr merge N --auto`). The queue runs the Quick and Exhaustive checks
   on Linux and Windows; macOS runs after each merge to `main`.
3. Move the consumer's pin to the new `main` commit.
4. If upstream should have it, list it in "Fixes to offer upstream".

## Syncing with upstream

1. On a branch from `main`, `git merge --no-ff <upstream commit>`. In
   conflicts in `.github/workflows`, take upstream's file and keep the
   fork's additions: the `merge_group` trigger, the two gate jobs, macOS
   left out of the queue, and `OMPI_MCA_pml`/`OMPI_MCA_osc` set to `^ucx`.
2. Open a pull request with the label `full-ci`, which runs the checks.
3. When they pass, an administrator moves `main` to the merge commit with a
   plain push. This is the one use of the administrators' bypass of the
   merge queue and the hygiene check: the hygiene check cannot pass a range
   of upstream commits by upstream authors, and the squashing queue would
   destroy the merge.

## Local commits

fo's pre-commit hook builds LFortran in a staged copy of the repository.
LFortran's build needs sources that `build0.sh` generates, so each clone
sets, once:

```sh
git config fo.hookPrepare 'export PATH=<env with re2c, bison, python>/bin:$PATH; v=$(git describe --tags --match "v[0-9]*" upstream/main 2>/dev/null) || v=v0.0.0; echo "${v#v}" > version; sed "/^source ci\/version.sh/d" build0.sh | bash'
```
