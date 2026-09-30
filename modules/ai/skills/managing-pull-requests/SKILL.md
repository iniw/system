---
name: managing-pull-requests
description: Creates a pull request from the current change, makes sure that CI passes, then watches the pull request for comments and checks each new comment against the code with a subagent. Use when asked to open, create, maintain or watch a pull request.
---

# Managing Pull Requests

Do all the steps below, in order.

You can change the history of the change only until you create the pull request. After you create it, do not rewrite,
reorder or squash the commits that you pushed. Put each fix in a new commit, with one commit for each fix. Before you
push, move the bookmark of the pull request to the new commit with `jj bookmark advance`.

For all work on GitHub (for example, to create the pull request, or to read CI checks, logs and comments), use your
GitHub tools. If they are not available, use the `gh` CLI.

## 1. Prepare the commits

1. Find the commits of the change, for example with `jj log -r 'trunk()..@'`.
2. Make sure that each commit message follows the commit conventions of the user and of the repository. If a message
   does not, fix it with `jj describe <revision>`.

## 2. Create the pull request

1. Find the pull request template of the repository. Look in these locations:
   - `.github/pull_request_template.md`
   - `.github/PULL_REQUEST_TEMPLATE.md`
   - `.github/PULL_REQUEST_TEMPLATE/`
   - `docs/` and the repository root, with the same file names.
2. Write the title. Use the same format as the commit subject lines. If the pull request has only one commit, use its
   subject line.
3. Write the body. Fill in each section of the template. Do not remove sections of the template, and do not add
   sections that it does not have. If there is no template, explain the problem, and how the change fixes it. Follow the
   rules of the repository, for example about linked issues and changelog entries.
4. Push the change with `jj git push`. Use the bookmark of the change if it has one. If not, use `jj git push -c <head
   revision>` to make one.
5. Create the pull request. Use the default branch of the repository as the base.

## 3. Make sure that CI passes

1. Wait for the CI checks to complete.
2. If a check fails, read its logs and find the cause.
   - If the change caused the failure, fix it in a new commit. Then push again with `jj git push`.
   - If the failure is not related to the change (for example, a flaky test or a problem with the CI system), tell the
     user. Do not change the code for it.
3. Do this step again until all checks pass.

## 4. Watch for comments

Watch the pull request for new comments.

Remember which comments you already examined, so that you only examine each comment one time.

For each new comment, start a subagent with the default model. Give it the comment, the lines of code that the comment
is about and the revision range of the change. Tell it to:

- Find each claim that the comment makes.
- Examine each claim against the code, adversarially. It must not assume that the comment is correct, and it must not
  assume that the code is correct.
- Say if each claim is correct, incorrect or not certain, and give the reasons with references to the code.

Then:

1. Tell the user about the comment and the result of the subagent.
2. If the comment is correct and asks for a change, make the change in a new commit. Do not put fixes for different
   comments in the same commit. Push again with `jj git push` and do step 3 again.
3. Do not reply to comments, and do not resolve them, unless the user asks you to.

Continue to watch until the pull request is merged or closed, or until the user tells you to stop.
