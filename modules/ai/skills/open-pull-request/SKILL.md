---
name: open-pull-request
description: Creates a pull request from the current change, makes sure that CI passes, then watches the pull request for comments and checks each new comment against the code with a subagent. Use when asked to open, create, maintain or watch a pull request.
---

# Opening and managing pull requests

Follow all the steps below, in order.

You can rewrite the history of the change only until you create the pull request. Once it exists, don't rewrite,
reorder or squash the commits you pushed. Instead, add each fix as its own new commit, and before you push, move the
pull request's bookmark to that commit with `jj bookmark advance` or `jj bookmark move`.

For all work on GitHub, such as creating the pull request or reading CI checks, logs and comments, use your GitHub
tools. If they aren't available, fall back to the `gh` CLI.

Whenever you write or change a commit message, or the title or description of the pull request, follow the
`format-commit-and-pull-request` skill.

## 1. Prepare the commits

1. Find the commits of the change, for example with `jj log -r 'trunk()..@'`.
2. Check that each commit message follows the `format-commit-and-pull-request` skill, and fix any that don't with
   `jj describe <revision>`.

## 2. Create the pull request

1. Write the title and the description with the `format-commit-and-pull-request` skill, and save the description to a
   file in your scratchpad directory.
2. If the change is for a Linear issue, name the branch of the pull request after the issue. Get the branch name that
   Linear suggests for the issue from the `branchName` field of `linear issue view <issue> --json`. Then put a bookmark
   with that name on the head revision with `jj bookmark create <branch name> -r <head revision>`. If the change
   already has a bookmark, rename it with `jj bookmark rename` instead. `jj-gh pr create` then uses that bookmark
   rather than creating one.
3. Create the pull request with `jj-gh pr create`. It pushes the change for you, so there is no need to push first. If
   the change has no bookmark, it creates one. It also picks the base for you, which is the closest ancestor bookmark,
   or `trunk()` if there is none.

   ```sh
   jj-gh pr create <head revision> --no-edit --template-file <description file> --title-template '"<title>"'
   ```

   The value of `--title-template` is a jj template, so wrap the title in double quotes and escape each `"` and `\` in
   it with a `\`.

   If the user asks for stacked pull requests, open one pull request per part of the stack, one at a time, from the
   bottom of the stack to the top, each with its own title and description. Each part has the bookmark of the part
   below it as its closest ancestor bookmark, so `jj-gh pr create` uses that bookmark as the base and links the pull
   requests into a GitHub stack. Follow the remaining steps for every pull request in the stack.

## 3. Make sure that CI passes

1. Wait for the CI checks to finish.
2. If a check fails, read its logs and find the cause.
   - If the change caused the failure, fix it in a new commit and push again with `jj git push`.
   - If the failure is unrelated to the change, such as a flaky test or a problem with the CI system, tell the user
     and leave the code alone.
3. Repeat this step until all checks pass.

## 4. Watch for comments

Watch the pull request for new comments, and keep track of the ones you have already examined so that you examine each
comment only once.

For each new comment, start a subagent with the default model. Pass it the comment, the lines of code that the comment
is about and the revision range of the change, and tell it to:

- Find each claim that the comment makes.
- Check each claim against the code adversarially, without assuming that either the comment or the code is correct.
- Say whether each claim is correct, incorrect or uncertain, and back the answer with references to the code.

Then:

1. Tell the user about the comment and what the subagent found.
2. If the comment is correct and asks for a change, make the change in a new commit, and keep fixes for different
   comments in separate commits. If the fix changes something that the pull request description says, write a new
   description as well. Check the fix locally, then show it to the user for approval, together with the new
   description if there is one. Don't push the fix or change the description on GitHub until the user approves. After
   approval, push with `jj git push`, update the description, and go back to step 3.
3. Suggest a reply to the user, and write it with the rules in the "Style" section of the `review-pull-request` skill.
   Don't post it to GitHub or resolve the thread yourself.
   - If you made a change, suggest the reply together with the fix for approval, and say which commit has the change.
   - If the comment is incorrect, explain why, with references to the code.
   - If the result is uncertain, explain what is unclear and ask the user what to do, rather than guessing.

Keep watching until the pull request is merged or closed, or until the user tells you to stop.
