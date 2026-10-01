---
name: implement-feature
description: Implements a feature or an issue (for example, a Linear issue) end to end. Finds how to implement it, writes it as atomic commits, tests it against a live environment and repeats subagent reviews until they find no important problems. Use when asked to implement, build or do a feature or issue end to end.
---

# Implementing Features End To End

Do all the steps below, in order. Do not stop after one step to ask if you should continue, unless a step tells you to
ask.

## 1. Find the implementation

1. Get the full request.
   - If the user gives an issue ID (for example, `COR-1314`), read the issue with the Linear tools. Also read its
     comments, its attachments, its linked issues and its parent issue.
   - If the issue links to external resources (for example, Slack threads), read each one fully with the most relevant
     tool. Look for links in the attachments, in the description and in the comments. These resources often contain
     decisions and details that are not in the issue.
   - If the user gives a plain request, use it as it is.
2. Read the code that the change touches. Find how the code does similar things now, and do the same.
3. If the request is not clear, or if there is more than one good way to do it and the choice has an important effect,
   ask the user before you write code. Otherwise, choose the best way and continue.

## 2. Write the code

Split the work into self-contained, atomic commits. Write each commit one at a time, with `jj`:

1. Start a new commit with `jj new`.
2. Write the change for that commit only.
3. Make sure that the project builds, and that the linters and tests pass for that commit.
4. Write the commit message with `jj describe -m "..."`.

When you write or change a commit message, in this step or in a later step, follow the
`format-commit-and-pull-request` skill.

If you must change an earlier commit, put the change in the commit where it belongs, not in the last commit. To do
this, use `jj absorb`, `jj squash --into <revision>` or `jj edit <revision>`.

## 3. Test against a live environment

Unit tests are not sufficient. Run the changed code in a live environment where it really runs, and make sure that it
does what the request asks for.

- To test MetalBear-related services, use the `test-metalbear-services` skill. If a different skill tells you how to
  test this project, use that skill.
- Test the main case of the request. Also test the error cases and the edge cases that the change can affect.
- If a test finds a bug:
  1. Fix it in the commit that caused it.
  2. In the same commit, add a regression test for the bug. The test must fail without the fix and pass with it.
  3. Test again.

If you cannot get access to the environment, or you do not have the necessary credentials, stop and tell the user. Do
not say that the change is tested if you did not test it.

## 4. Review with subagents

1. Start the reviewers as the "Start the reviewers" step of the `review-pull-request` skill tells you. There is no pull
   request, so change that step like this:
   - The revision range is `trunk()..@`. Where the step uses the bookmark of the pull request, use the commit ID of
     `@`.
   - The request from step 1 tells what the change must do. Where the step or its categories tell about the pull
     request, its description or its linked issues, use the change and the request.
   - There are no comments, so ignore the parts about the comments on the pull request.
   - The review workspace is your workspace. The subagents read the code in it. As that step says, they can make their
     own temporary workspaces to write tests or other code, but they must not change yours.
   - Also start one more subagent, for the category in [Commit structure](#commit-structure). Give it the full text of
     that section, just like the other categories.
2. Read each finding and make sure that it is real. Do not fix findings that are wrong. Tell the user about them at the
   end.
3. Fix the real findings. Rewrite the history: put each fix in the commit where the problem is, with `jj absorb`, `jj
   squash --into <revision>` or `jj edit <revision>`. Only make a new commit if the fix does not belong in a commit that
   is already there.
4. For each bug that you fix, add a regression test in the same commit as the fix. The test must fail without the fix
   and pass with it.
5. If a fix changes behavior, do the tests from step 3 again.
6. Start new subagents and do this step again. Stop when the subagents find no problems, or only find minor problems.

If the reviews do not stop finding important problems after some rounds, stop and ask the user what to do.

### Commit structure

Make sure that each commit is one logical change that a reviewer can read and understand alone. A good history lets a
reviewer read the change one step at a time, and lets a person who finds a commit later (for example, with `jj bisect`)
understand why it exists.

Look for:

- Commits that do more than one thing. For example, a refactor and a change of behavior in the same commit, or two fixes
  that are not related.
- Changes that are in the wrong commit. For example, a fix for a bug that an earlier commit adds, or a test for the code
  of a different commit.
- Commits in the wrong order. For example, a commit that uses code that a later commit adds, or a refactor that comes
  after the change that needs it.
- Commits that only make sense together, and that must be one commit.
- Commit messages that do not agree with what the commit does.

Do not build or test each commit. A different step does this later.

## 5. Check that each commit is atomic

Do this step only after all the other steps are complete, when you do not expect to change the commits again. `jj run`
is expensive, because it builds and tests each commit. It must be the last thing that you do. Do not do it during the
review loop in step 4, or after each round of reviews.

Use `jj run` to build, lint and test each commit of the change alone. For example:

```sh
jj run --ignore-changes -r 'trunk()..@' -- <command>
```

- Use the commands that the project uses, for example the ones in its CI.
- Use `--ignore-changes`, so that `jj run` does not change the commits.
- Use `-j <number>` to check more than one commit at a time.
- Read `jj run --help` for the other options.

If a commit fails, fix it in that commit, as step 2 tells you. If the fix changes behavior, do the tests from step 3
again. Then do `jj run` again, but only on the fixed commit and the commits after it (for example `-r '<revision>::@'`).

## 6. Report

Do not push the changes or open a pull request, unless the user asks you to. If the user asks you to, use the
`open-pull-request` skill.

Tell the user:

- The list of commits, with one line for each commit about what it does.
- How you tested the change, and the results.
- The results of the `jj run` check.
- The review findings that you did not fix, and why.
