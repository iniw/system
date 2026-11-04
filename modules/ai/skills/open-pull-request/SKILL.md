---
name: open-pull-request
description: Creates a pull request from the current change and makes sure that CI passes. If asked, it then watches the pull request and addresses new review comments. Use when asked to open, create, maintain or watch a pull request.
---

# Opening and managing pull requests

Follow all the steps below, in order.

Rewrite the history of the change only before you create the pull request. Once the pull request exists, reviewers
rely on the commits that they already saw, so don't rewrite, reorder or squash the pushed commits. Instead, add each fix
as a new commit on top of them, and push without force. If an update would need a force push, for example to rebase a
stack of pull requests, ask the user first.

In jj, a bookmark doesn't move to new commits by itself, so move it before each push. Create the fix on top of the
bookmark with `jj new <branch>` and `jj commit -m "<message>"`, then move the bookmark with
`jj bookmark move <branch> --to @-` and push with `jj git push --bookmark <branch>`. `jj bookmark move` refuses to
move a bookmark backwards or sideways. `jj git push --dry-run` prints "Move sideways" when a push would need a force
push.

Use your GitHub tools for all work on GitHub, such as creating the pull request or reading CI checks, logs and
comments.

Whenever you write or change a commit message, or the title or description of the pull request, follow the
[`writing-commits-and-pull-requests`](../writing-commits-and-pull-requests/SKILL.md) skill.

## 1. Prepare the commits

1. Find the commits of the change, with `git log origin/<base>..HEAD` in git or `jj log -r 'trunk()..@'` in jj.
2. Check that each commit message follows the
   [`writing-commits-and-pull-requests`](../writing-commits-and-pull-requests/SKILL.md) skill, and fix any that don't.
   Both git and jj open an editor unless you pass the message, so pass it:
   - In jj, run `jj describe <revision> --stdin < <message file>`.
   - In git, write a file whose first line is `amend! <subject of the old commit>`, followed by a blank line and the
     new message. Run `git commit --allow-empty -F <file>` to create an empty commit with that message, then
     `git rebase --autosquash <base>` to squash it into the old commit.

## 2. Create the pull request

1. Write the title and the description with the
   [`writing-commits-and-pull-requests`](../writing-commits-and-pull-requests/SKILL.md) skill, and save the description
   to a file outside the repository, for example in your scratchpad directory.
2. Choose the name of the branch. If the change is for a Linear issue, use the branch name that Linear suggests: the
   `branchName` field of the issue in your Linear tools, or the "Copy git branch name" action on the issue's page. If
   the change already has a branch, rename it rather than creating another one, with `git branch -m <new name>` in git
   or `jj bookmark rename <old name> <new name>` in jj.
3. Push the branch:
   - In git, `git push origin HEAD:refs/heads/<branch>`, which works whether or not a local branch has that name.
   - In jj, `jj git push --named <branch>=<head revision>`, or `jj git push --bookmark <branch>` if the bookmark already
     exists.
4. Create the pull request:

   ```sh
   gh pr create --base <base branch> --head <branch> --title "<title>" --body-file <description file>
   ```

If the user asks for stacked pull requests, open one pull request for each part of the stack, with its own branch,
title and description. Open them one at a time, from the bottom of the stack to the top. Use the branch of the part
below as the base of each part, and the repository's main branch as the base of the bottom part. Follow the remaining
steps for every pull request in the stack. Keep your changes on the pull request that you are working on. Only after
that work is done and reviewed, update the pull requests above it by merging the lower branch into each of them. If
they need a rebase instead, ask the user first, because a rebase needs a force push.

## 3. Make sure that CI passes

1. Wait for the CI checks to finish. Don't check the status in a loop, because each read of the status adds its output
   to your context, even when nothing has changed. If your agent tells you when the checks finish, wait for that.
   Otherwise, wait with one command that blocks until the checks finish and discards the progress output. Run it in
   the background if your agent supports that, so that the command timeout doesn't stop it:

   ```sh
   gh pr checks <number> --watch --fail-fast > /dev/null; gh pr checks <number>
   ```

2. If a check fails, read its logs and find the cause.
   - If the change caused the failure, fix it in a new commit and push again, without force.
   - If the failure is unrelated to the change, such as a flaky test or a problem with the CI system, tell the user and
     leave the code alone.
3. Repeat this step until every check passes, or until the only checks that fail are unrelated to the change.

## 4. Watch the pull request

Only do this step if the user asked you to watch or maintain the pull request. Otherwise, tell the user that the pull
request is open and that CI passes, and stop.

Watch the pull request for new review comments, and address each one with the
[`address-review-comments`](../address-review-comments/SKILL.md) skill. A request to watch or maintain the pull request
counts as a request to address its review comments. Keep track of the comments you have already addressed, so that you
address each comment only once. After a fix, go back to step 3.

Keep watching until the pull request is merged or closed, or until the user tells you to stop.
