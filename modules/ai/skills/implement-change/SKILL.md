---
name: implement-change
description: Implements a feature, a bug fix or an issue end to end. Finds how to implement it, agrees on the approach with the user when the choice matters, writes it as atomic commits, tests it against a live environment and repeats reviews, fixing the findings that the user chooses, until the reviews find no important problems. Use when asked to implement, build, fix or do a feature or issue end to end.
---

# Implementing changes end to end

Follow all the steps below, in order. Don't stop after a step to ask whether you should continue, unless the step
tells you to ask.

The request decides what you may change. A request to reproduce a bug, to run tests or to review code doesn't
authorize a fix, so report what you found and stop. Don't push, open a pull request or post anything unless the user
asks. If they ask for a pull request, use the [`open-pull-request`](../open-pull-request/SKILL.md) skill.

Keep the notes, plans, reproduction scripts and logs of the task outside the repository, in one directory per task.
Use your agent's scratchpad directory if it has one. Otherwise, create a directory in the system's temporary directory,
named after the issue (such as `cor-1923`) or after the task when there is no issue. Don't put credentials or customer
data there.

## 1. Understand the request

1. Get the full request.
   - If the user gives an issue, such as a Linear issue (`COR-1314`) or a GitHub issue (`#1301`), read it with the tools
     for its tracker, along with its comments, attachments, linked issues and parent issue.
   - If the issue links to external resources such as Slack threads, read each one in full with the most relevant tool.
     Look for links in the attachments, the description and the comments, because these resources often hold decisions
     and details that the issue leaves out.
   - If the user gives a plain request, use it as it is.
2. Read the code that the change touches. Find how the code handles similar things today, and the mechanisms that
   already do part of the request, such as similar features, helpers, extension points and the code that reads
   configuration.
3. If the request is a bug, reproduce it before you change any code, with whatever setup that takes, and keep the
   commands, the environment and the output. If a test can reproduce the bug, write that test first, because it then
   becomes the regression test for the fix. The reproduction shows that you found the real cause, and you need it again
   in [step 4](#4-test-against-a-live-environment) to show that the fix works. If you can't reproduce the bug, say so,
   and don't claim a cause that you only found by reading the code.

Broad research, such as finding every place that uses an interface, can run in parallel in separate agents. Ask them to
describe what they find with file and line references. Make the design decisions yourself from the code they point to,
because a summary can be wrong and the other agents don't know the whole request.

## 2. Choose the approach

Design the change to fit the code that is already there:

- **Reuse:** build on the existing mechanisms that you found in step 1. For each one that you don't use, know why it
  doesn't fit. A second mechanism for the same behavior drifts apart from the first one over time.
- **Fit:** follow the layering, ownership, error handling patterns and naming scheme of the surrounding code, and know
  why you depart from them where you do.
- **Testability:** design the change so that tests can check it through its interfaces with the real code and real
  services, as the [`designing-tests`](../designing-tests/SKILL.md) skill describes.
- **Compatibility:** find the interfaces that existing users and clients rely on, such as CLI flags, configuration,
  stored data, Kubernetes resources, wire formats and public APIs, and what the change does to each of them, including
  when versions are mixed, for example an old client with a new server. Each break must have a migration, or a reason
  why it needs none. Components that are always released and deployed together, such as the CLI and the UI server that
  it starts, don't need to work with older versions of each other.
- **Scope:** touch only the files and interfaces that the request needs. Refactors and cleanup that the request doesn't
  need are follow-ups for a later change, not part of this one, so report them to the user instead, even when they
  would improve the change. Don't add options, extension points or abstractions for requirements that nobody stated.

If the change spans several repositories, such as mirrord and the operator, agree on the shared interface before you
write code in either one, and plan the order in which they must be merged or released.

Stop and ask the user before you write any code if:

- the request is unclear, or you aren't sure of the cause of a bug;
- there is more than one good approach and the choice matters;
- the change breaks compatibility, or changes an interface beyond what the request asks for;
- the user asked you to plan first.

When you stop, explain in plain language what you understood about the problem and how the code works today, with file
and line references, as links if your interface shows them. Then describe one to three approaches, with what each
changes, what it reuses, what it breaks and what its drawbacks are, and say which one you recommend and why. Ask only
the questions whose answers change what you do, most important first. Give each question the reason it matters and the
answer that you would choose, with its reason, so that the user can answer with a short confirmation or correction.
Include questions about context that the code doesn't show, such as why something is the way it is, who depends on a
behavior, and whether the user wants a minimal fix or a thorough one.

Otherwise, choose the best approach yourself and continue. Describe the approach in the report.

If you find out later that the change must differ from the agreed approach in its behavior, its interfaces or its
scope, stop and tell the user what changed and why before you continue. A change to a detail within the agreed
approach only needs a mention in the report.

## 3. Write the code

Split the work into [atomic commits](#atomic-commits), and write them one at a time:

1. Start each commit from a working copy that has no other changes, and don't commit changes that you didn't make.
2. Write the change for that commit only.
3. Commit it. Whenever you write or change a commit message, in this step or a later one, follow the
   [`writing-commits-and-pull-requests`](../writing-commits-and-pull-requests/SKILL.md) skill.

If you need to change an earlier commit, make the change in the commit where it belongs rather than in the last one.
Then check that the changed commit is still atomic. If the commit is already pushed to a pull request, add a new commit
on top instead, because changing a pushed commit needs a force push.

The table below shows how to do this in git and in jj. Pass the message or the plan on the command line, so that no
command waits for an editor.

| Task                              | git                                                                  | jj                                                                                                                          |
| --------------------------------- | -------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| Commit the current change         | `git add` the files, then `git commit -F <message file>`             | `jj commit -m "..."`                                                                                                        |
| Move a fix into an earlier commit | `git commit --fixup=<commit>`, then `git rebase --autosquash <base>` | `jj squash --into <revision> -u` or `jj absorb`                                                                             |
| Check out an earlier commit       | `git switch --detach <commit>`                                       | `jj new <revision>` to test it, or `jj edit <revision>` to change it in place, then `jj new` on top of the finished changes |

### Atomic commits

An atomic commit is one logical change that works on its own: the project builds, and its linters and tests pass, at
that commit without any of the commits that come after it. A history of atomic commits lets a reviewer follow the change
one step at a time, and lets someone who finds a commit later, for example with `git bisect`, understand why it exists.

## 4. Test against a live environment

Unit tests aren't enough. Run the changed code in a live environment where it actually runs, and check that it does
what the request asks for.

- If the project's instructions or a skill explain how to run and test the project, follow them.
- Test the main case of the request, as well as the error cases and edge cases that the change can affect.
- If the change is a bug fix, repeat the reproduction from [step 1](#1-understand-the-request) and check that the bug is
  gone.
- If a test finds a bug:
  1. Fix it in the commit that introduced it.
  2. In the same commit, add a regression test that fails without the fix and passes with it.
  3. Test again.

If the change spans several repositories, test the combination with local builds of every repository, not with a
released version that the build fetches.

If you can't get access to the environment, or you lack the credentials for it, stop and tell the user. Never claim
that the change is tested if you didn't test it, and never claim that it works because the code looks right.

## 5. Review the change

1. Start the reviewers as described in the
   ["Start the reviewers"](../review-pull-request/SKILL.md#3-start-the-reviewers) step of the
   [`review-pull-request`](../review-pull-request/SKILL.md) skill. There is no pull request, so adapt that step as
   follows:
   - The revision range is the commits of the change, from the base branch to the last commit. Wherever the step uses
     the head of the pull request, use your last commit.
   - The request from step 1 and the approach from step 2 describe what the change must do. Wherever the step or its
     categories refer to the pull request, its description or its linked issues, use the change, the request and the
     approach instead. Tell the reviewers to also report where the approach itself is wrong.
   - There are no comments, so skip the parts about comments on the pull request.
   - The review checkout is your own working copy, and the reviewers read the code in it. As that step says, they can
     create their own temporary checkouts to write tests or other code, but they must not change yours.
   - Start one more reviewer for the category in [Presentation](#presentation), as for the other categories. This
     reviewer mostly judges text, so use the model that writes the clearest prose, even if it is less capable than you.
     This overrides the rule about the model in that step. Pass this reviewer the
     [`technical-writing`](../technical-writing/SKILL.md) and
     [`writing-commits-and-pull-requests`](../writing-commits-and-pull-requests/SKILL.md) skills by name and path, as
     that step does for the other skills.
2. Read each finding and check that it is real. Then report all the findings to the user, with your verdict on each
   one: real, possibly real or wrong, and why. Wait for the user to say which findings to fix, because the user may
   choose to leave some of them for later.
3. Fix the findings that the user chose by rewriting the history, so that each fix goes into the commit that has the
   problem. Only create a new commit if the fix doesn't belong in any existing one. Then check that each changed commit
   is still [atomic](#atomic-commits).
4. For each bug you fix, add a regression test in the same commit as the fix. The test must fail without the fix and
   pass with it.
5. If a fix changes behavior, repeat the tests from [step 4](#4-test-against-a-live-environment).
6. Start new reviewers and repeat this step, until the reviewers find no problems or only minor ones. Tell the new
   Presentation reviewer which of the earlier Presentation findings you fixed, so that it doesn't undo those fixes.

If the reviews keep finding important problems after a few rounds, stop and ask the user what to do.

### Presentation

Check that a reader can follow the change easily through its text, the layout of its code and the commits that split
it into steps. "Text" here means everything that the change adds or changes for a person or an agent to read, such as
the names of functions, types, variables and other symbols, comments and doc comments, commit messages, log and error
messages, help text and documentation. All of this text should be simple to read and should describe accurately what
it refers to. The other categories judge what the code does and how it is built, and this category only judges how
easily a reader can follow the change.

Look for:

- Text that breaks the rules of the [`technical-writing`](../technical-writing/SKILL.md) skill, and commit messages
  that break the rules of the [`writing-commits-and-pull-requests`](../writing-commits-and-pull-requests/SKILL.md)
  skill.
- Text that doesn't describe accurately what it refers to, such as a name that no longer fits what its function does,
  or a comment that a later commit makes wrong.
- Comments that only repeat the code, and non-obvious code with no comment that explains why it is that way.
- Code that is commented out, and TODO comments that don't say enough to act on.
- Code that the change adds or rewrites without empty lines between its parts, which leaves the reader to find where
  each part ends. Agents often write code this way. Put an empty line between the items of a module, between the
  members of a struct, enum, trait or `impl` block when they have doc comments, attributes or more than one line, and
  between the steps of a function body, such as reading the input, checking it and building the result. Short members
  without doc comments, such as the fields of a `Point { x: f64, y: f64 }`, can stay together.
- Commits that aren't [atomic](#atomic-commits), such as a refactor and a behavior change in one commit, a fix that
  comes in a later commit than the bug, a commit that uses code from a later one, or two commits that only make sense
  together.
- Lines that a commit reformats or reorders without otherwise changing them, which make its diff harder to read.

Judge how important a finding is by what it costs a reader, not by whether it changes what the code does. A finding is
important whenever it makes the reader do work that clearer text or commits would save them, such as working out what
a sentence means, checking whether two texts that say the same thing differ, or correcting a wrong idea, because these
are the problems that this category exists to find. You can also report a preference whose cost to the reader you
can't name, but mark it as minor and say why it is better. Show the rewritten text or the new split of the commits for
each finding.

Don't build or test each commit, because the author checks that separately.

## 6. Report

Tell the user:

- The list of commits, with one line per commit about what it does.
- The approach, if you chose it without asking, and anything that existing users or clients will notice.
- How you tested the change, and the results, including the checks that failed or that you couldn't run.
- The review findings that you didn't fix, and why.
- The follow-ups that you found but left out of the change.
