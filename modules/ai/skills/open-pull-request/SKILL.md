---
name: open-pull-request
description: Creates a pull request from the current change, makes sure that CI passes, then watches the pull request for comments and checks each new comment against the code with a subagent. Use when asked to open, create, maintain or watch a pull request.
---

# Managing Pull Requests

Do all the steps below, in order.

You can change the history of the change only until you create the pull request. After you create it, do not rewrite,
reorder or squash the commits that you pushed. Put each fix in a new commit, with one commit for each fix. Before you
push, move the bookmark of the pull request to the new commit with `jj bookmark advance` or `jj bookmark move`.

For all work on GitHub (for example, to create the pull request, or to read CI checks, logs and comments), use your
GitHub tools. If they are not available, use the `gh` CLI.

When you write or change a commit message, or the title or the description of the pull request, follow the
`format-commit-and-pull-request` skill.

## 1. Prepare the commits

1. Find the commits of the change, for example with `jj log -r 'trunk()..@'`.
2. Make sure that each commit message follows the `format-commit-and-pull-request` skill. If a message does not, fix
   it with `jj describe <revision>`.

## 2. Create the pull request

1. Write the title and the description with the `format-commit-and-pull-request` skill. Write the description to a file
   in your scratchpad directory.
2. Create the pull request with `jj-gh pr create`. It pushes the change for you, so you do not have to push it before.
   If the change does not have a bookmark, it makes one. It also picks the base for you: the closest ancestor bookmark,
   or `trunk()` if there is none.

   ```sh
   jj-gh pr create <head revision> --no-edit --template-file <description file> --title-template '"<title>"'
   ```

   The value of `--title-template` is a jj template, so put the title in double quotes, and escape each `"` and `\` in
   the title with a `\`.

   If the user asks for stacked pull requests, make one pull request for each part of the stack, one at a time, from the
   bottom of the stack to the top. Write a title and a description for each one. Because each part has the bookmark of
   the part below it as its closest ancestor bookmark, `jj-gh pr create` uses that bookmark as the base, and links the
   pull requests into a GitHub stack. Do the next steps for each pull request of the stack.
3. If the change is for a Linear issue, link the pull request to the issue with the Linear tools. Use the URL of the
   pull request that `jj-gh pr create` shows.

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
3. Reply to the comment in its thread.
   - If you made a change, say which commit has the change. Reply only after you push that commit.
   - If the comment is incorrect, say why, with references to the code.
   - If the result is not certain, do not guess. Ask the user what to do, and do not reply until they answer.
   - Never attribute the reply to yourself.
4. Resolve the thread after you reply, if you made the change or if the comment is incorrect. Do not resolve a thread
   when the result is not certain, or when the comment asks a question for a person to answer.

Continue to watch until the pull request is merged or closed, or until the user tells you to stop.
