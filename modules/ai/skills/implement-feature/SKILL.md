---
name: implement-feature
description: Implements a feature or an issue end to end. Finds how to implement it, writes it as atomic commits, tests it against a live environment and repeats subagent reviews until they find no important problems. Use when asked to implement, build or do a feature or issue end to end.
---

# Implementing features end to end

Follow all the steps below, in order. Don't stop after a step to ask whether you should continue, unless the step
tells you to ask.

## 1. Find the implementation

1. Get the full request.
   - If the user gives an issue, such as a Linear issue (`COR-1314`) or a GitHub issue (`#1301`), read it with the tools
     for its tracker, along with its comments, attachments, linked issues and parent issue.
   - If the issue links to external resources such as Slack threads, read each one in full with the most relevant tool.
     Look for links in the attachments, the description and the comments, because these resources often hold decisions
     and details that the issue leaves out.
   - If the user gives a plain request, use it as it is.
2. Read the code that the change touches. Find how the code handles similar things today, and follow the same approach.
3. If the request is unclear, or if there is more than one good way to do it and the choice matters, ask the user
   before you write any code. Otherwise, pick the best way and carry on.

## 2. Write the code

Split the work into [atomic commits](#atomic-commits), and write them one at a time with `jj`:

1. Start each commit from a fresh, empty working copy. If the working copy isn't empty, start a new commit with
   `jj new`.
2. Write the change for that commit only.
3. Check that the project builds and that the linters and tests pass for that commit.
4. Finish the commit with `jj commit -m "..."`. This saves the commit message and creates a fresh, empty working copy
   for the next change. Always leave the working copy on that new commit.

Whenever you write or change a commit message, in this step or a later one, follow the `format-commit-and-pull-request`
skill.

If you need to change an earlier commit, make the change in the commit where it belongs rather than in the last one,
using `jj absorb`, `jj squash --into <revision>` or `jj edit <revision>`. If you use `jj edit`, return to a fresh,
empty working copy on top of the finished changes when you are done. Then check that the changed commit is still
atomic.

### Atomic commits

An atomic commit is one logical change that works on its own: the project builds, and its linters and tests pass, at
that commit without any of the commits that come after it. A history of atomic commits lets a reviewer follow the
change one step at a time, and lets someone who finds a commit later, for example with `jj bisect`, understand why it
exists.

## 3. Test against a live environment

Unit tests aren't enough. Run the changed code in a live environment where it actually runs, and check that it does
what the request asks for.

- To test MetalBear-related services, use the `test-metalbear-services` skill. If a different skill explains how to
  test this project, use that one instead.
- Test the main case of the request, as well as the error cases and edge cases that the change can affect.
- If a test finds a bug:
  1. Fix it in the commit that introduced it.
  2. In the same commit, add a regression test that fails without the fix and passes with it.
  3. Test again.

If you can't get access to the environment, or you lack the credentials for it, stop and tell the user. Never claim
that the change is tested if you didn't test it.

## 4. Review with subagents

1. Start the reviewers as described in the "Start the reviewers" step of the `review-pull-request` skill. There is no
   pull request, so adapt that step as follows:
   - The revision range is `trunk()..@`. Wherever the step uses the pull request's bookmark, use the commit ID of `@`.
   - The request from step 1 describes what the change must do. Wherever the step or its categories refer to the pull
     request, its description or its linked issues, use the change and the request instead.
   - There are no comments, so skip the parts about comments on the pull request.
   - The review workspace is your own workspace, and the subagents read the code in it. As that step says, they can
     create their own temporary workspaces to write tests or other code, but they must not change yours.
   - Start one more subagent for the category in [Presentation](#presentation), just like the other categories. In
     Claude Code, start it with `opus` rather than `fable`, because this subagent mostly judges text, and Opus writes
     clearer prose than Fable. Elsewhere, use the model that the step asks for.
2. Read each finding and check that it is real. Don't fix findings that are wrong, but tell the user about them at the
   end.
3. Fix the real findings by rewriting the history, so that each fix lands in the commit that has the problem. Use
   `jj absorb`, `jj squash --into <revision>` or `jj edit <revision>`, and only create a new commit if the fix doesn't
   belong in any existing one. Then check that each changed commit is still [atomic](#atomic-commits).
4. For each bug you fix, add a regression test in the same commit as the fix. The test must fail without the fix and
   pass with it.
5. If a fix changes behavior, repeat the tests from step 3.
6. Start new subagents and repeat this step, until the subagents find no problems or only minor ones. Tell the new
   Presentation subagent which of its earlier findings you fixed, so that it doesn't reverse them.

If the reviews keep finding important problems after a few rounds, stop and ask the user what to do.

### Presentation

Check that the change presents itself clearly and simply to a reader, through its text, through the layout of its code
and through the commits that split it into steps. "Text" here means everything that the change adds or changes for a
person or an agent to read, such as the names of functions, types, variables and other symbols, comments and doc
comments, commit messages, log and error messages, help text and documentation. Whatever kind of text it is, it should
be simple to read and describe accurately what it refers to. The other categories judge what the code does and how it
is built. This one, on the other hand, only judges how easily a reader can follow the change.

Look for:

- Text that breaks the rules of the "Writing" section of the global instructions, and commit messages that break the
  rules of the `format-commit-and-pull-request` skill.
- Text that doesn't describe accurately what it refers to, such as a name that no longer fits what its function does,
  or a comment that a later commit makes wrong.
- Comments that only repeat the code, and non-obvious code with no comment that explains why it is that way.
- Code that is commented out, and TODO comments that don't say enough to act on.
- Code that the change adds or rewrites without empty lines between its parts, which leaves the reader to find where
  each part ends. Agents often write code this way. Put an empty line between the items of a module, between the
  members of a struct, enum, trait or `impl` block when they have doc comments, attributes or more than one line, and
  between the steps of a function body, such as reading the input, checking it and building the result. Short
  members without doc comments, such as the fields of a `Point { x: f64, y: f64 }`, can stay together.
- Commits that aren't [atomic](#atomic-commits), such as a refactor and a behavior change in one commit, a fix that
  lands after the commit with the bug, a commit that uses code from a later one, or two commits that only make sense
  together.
- Lines that a commit reformats or reorders without otherwise changing them, which make its diff harder to read.

Judge how important a finding is by what it costs a reader, not by whether it changes what the code does. A finding
is important whenever it makes the reader do work that clearer text or commits would save them, such as working out
what a sentence means, checking whether two texts that say the same thing differ, or correcting a wrong idea, because
these are the problems that this category exists to find. You can also report a preference whose cost to the reader
you can't name, but mark it as minor and say why it is better. Show the rewritten text or the new split of the commits
for each finding.

Don't build or test each commit, because the author checks that separately.

## 5. Report

Don't push the changes or open a pull request unless the user asks. If they do, use the `open-pull-request` skill.

Tell the user:

- The list of commits, with one line per commit about what it does.
- How you tested the change, and the results.
- The review findings that you didn't fix, and why.
