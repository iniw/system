---
name: address-review-comments
description: Checks each review comment on a pull request against the code, fixes the valid ones in new commits and replies in the comment's thread. Waits for the user's approval before acting on comments from people. Use when asked to address, handle, check, triage or answer the review comments of a pull request, from people or from review bots.
---

# Addressing review comments

Follow all the steps below, in order.

A request to address the review comments of a pull request authorizes you to commit fixes, push them without force and
reply to comments from review bots, such as Greptile, Qodo or Copilot. Comments from people are part of a conversation
that the user owns. For those comments, the request only covers checking them and planning the fixes, and the rest
must wait for the user's approval (see step 3). The request never authorizes you to force push, resolve threads, submit
a review, post a top-level comment on the pull request or change its description.

If the user only asks you to check or triage the comments, stop after
[step 3](#3-ask-the-user-about-comments-from-people) and report the verdicts and the plan, without changing code or
posting anything.

For all work on GitHub, use your GitHub tools.

## 1. Collect the comments

1. Collect the open review threads on lines of code, and skip the resolved ones. Don't skip a thread only because the
   user's account already replied in it, because the reviewer may have answered that reply. In such a thread, handle
   only the comments that came after the latest reply from the user's account. With `gh`, this query lists the threads:

   ```sh
   gh api graphql -f owner=<owner> -f repo=<repo> -F number=<number> -f query='
     query($owner: String!, $repo: String!, $number: Int!) {
       repository(owner: $owner, name: $repo) {
         pullRequest(number: $number) {
           reviewThreads(first: 100) {
             nodes {
               isResolved path line
               comments(first: 100) { nodes { databaseId url createdAt body author { login __typename } } }
             }
           }
         }
       }
     }'
   ```

2. Skip the comments from the user's own account (`gh api user --jq .login`). These are earlier replies or commands to
   the review bots, not review feedback.
3. Note whether each remaining comment comes from a person or from a bot. A bot account has the type `Bot` and usually
   a login that ends in `[bot]`. Treat an author that you can't classify as a person.
4. Also read the review bodies and the general comments on the pull request
   (`gh pr view <number> --json reviews,comments`), such as a bot's summary or a reviewer's general remarks, but only to
   find problems that have no thread on a line of code. Check those problems like the others, but report them to the
   user rather than replying, because a reply there would only repeat the replies in the threads.

## 2. Check each comment against the code

Review bots often lack context or suggest changes that don't help, so a comment is not by itself a reason to change the
code. Reviews often raise one problem in several comments, so group the comments by the problem that they are about.
For each group:

- Find each claim that the comments make.
- Check each claim against the code adversarially, without assuming that either the comments or the code are correct.
- Say whether each claim is correct, incorrect or uncertain, and back the answer with references to the code.

These checks don't depend on each other, so they can run in parallel in separate agents. Give each agent the comments
of its group, the lines of code that each comment is about and the revision range of the pull request.

Then decide for each group whether it asks for a valid change, and plan a fix for each valid group. Look at the valid
groups together as well, because problems that look separate can have one cause in the structure or the design of the
code. A change to the design that addresses all of them is often better than a separate small fix for each group, so
plan that change instead, and say which groups it addresses. Keep each verdict, its reason and the plan in your notes
for the task.

## 3. Ask the user about comments from people

If any comment is from a person, stop here, before you change any code. Show the user each comment from a person with
its verdict, the reason and the planned fix or reply, and show the verdicts and the plan for the comments from bots
as well. Wait for the user's approval, and update the verdicts and the plan with any change the user asks for.
Then do the remaining steps for all the comments.

If you can't tell whether a comment is valid, explain what is unclear and ask the user what to do, rather than guessing.

## 4. Fix the valid comments

1. Make each fix in a new commit on top of the pull request, with one commit per group of comments, unless several
   groups share one fix. Each reply can then point to the commit that answers it. Write the commit messages with the
   [`writing-commits-and-pull-requests`](../writing-commits-and-pull-requests/SKILL.md) skill.
2. Run the checks that the fix can affect.
3. If a fix would change behavior or interfaces beyond what the pull request is meant to change, stop and ask the user
   rather than choosing an approach yourself.
4. If a fix changes something that the pull request description says, write a new description and show it to the user
   for approval before you change it on GitHub.
5. In jj, first move the branch's bookmark to the new commits, as the
   [`open-pull-request`](../open-pull-request/SKILL.md) skill describes. Then push without force. If the push would
   need a force push, stop and tell the user.

## 5. Reply in each thread

After the push, reply in each thread that you collected, so that the links to the commits work. With `gh`, write the
reply to a file and post it with:

```sh
gh api repos/<owner>/<repo>/pulls/<number>/comments/<comment id>/replies --field body=@<reply file>
```

`<comment id>` is the `databaseId` of the first comment in the thread, even when you answer a later comment, because
GitHub doesn't accept replies to replies.

- If you made a change, say what changed and link the commit by its short hash.
- If you didn't change anything, say why: the comment doesn't apply, or it is valid but outside the scope of the pull
  request. Back the reason with the code, a test or the documentation.

Follow the rules in the ["Style"](../review-pull-request/SKILL.md#style) section of the
[`review-pull-request`](../review-pull-request/SKILL.md) skill for the replies. Don't resolve the threads, because the
reviewer decides whether the reply answers the comment.

## 6. Report

For each comment, tell the user the verdict, the commit that addresses the comment or the reason it needs no change,
and the link to the reply. Also report the checks you ran, and the problems from review bodies and general comments
with your verdict on each one.
