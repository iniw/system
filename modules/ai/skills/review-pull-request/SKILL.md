---
name: review-pull-request
description: Reviews a GitHub pull request with adversarial reviewers, each a separate agent with a fresh context, then checks that each finding is real. Use when asked to review a pull request. Also use each time before you start an agent to review a pull request or a local change.
---

# Reviewing pull requests

Follow all the steps below, in order. A review is read-only: unless the user asks, don't fix the problems that it
finds, don't push and don't post anything on GitHub.

For all work on GitHub, such as reading the pull request, its checks and its comments, use your GitHub tools.

## 1. Read the pull request

1. Read the title, the description, the linked issues and the CI checks of the pull request, and read any Linear issue
   with the Linear tools. The reviewers need this context to recognize wrong behavior.
2. Read the comments and review threads on the pull request. Don't report a problem that a comment already reports.
   If you find out more about such a problem, for example that it is worse than the comment says or that it has more
   causes or effects, report it and say which comment it builds on.

## 2. Check out the pull request

The reviewers must read the full code, not only the diff. If the current directory isn't a clone of the pull request's
repository, ask the user where the clone is.

Don't check out the pull request in the current working copy, because the user may have work in it. Check it out in a
separate worktree (git) or workspace (jj) in a temporary directory outside the repository instead. `$base` is the pull
request's base branch. The jj commands assume that the jj repository is colocated with git, which is the usual setup:

| Step                               | git                                                 | jj                                                  |
| ---------------------------------- | --------------------------------------------------- | --------------------------------------------------- |
| Fetch the base branch              | `git fetch origin $base`                            | `jj git fetch --branch $base`                       |
| Create the review checkout         | `git worktree add --detach $directory`              | `jj workspace add --name review-$number $directory` |
| Check out the pull request         | `gh pr checkout $number --detach` in `$directory`   | `gh pr checkout $number --detach` in `$directory`   |
| Revision range of the pull request | `origin/$base..HEAD` in `$directory`                | `$base@origin..@-` in `$directory`                  |
| Read the commits and the diff      | `git log $range` and `git diff origin/$base...HEAD` | `jj log -r $range` and `jj diff --git -r $range`    |
| Remove the review checkout         | `git worktree remove --force $directory`            | `jj workspace remove review-$number`                |

A jj workspace in a colocated repository has its own git worktree, so `gh pr checkout` works in it. jj then starts a
new working-copy commit on top of the pull request's head. `--detach` stops `gh pr checkout` from creating a local
branch, which would conflict with the pull request's branch if the user has that branch checked out elsewhere.

The reviewers read the code in the review checkout with their usual tools, so pass them its path. Remove the review
checkout when the review is done.

## 3. Start the reviewers

Start one reviewer per category in [Categories](#categories), all in parallel. A reviewer is a separate agent that
starts from a fresh context. Give each reviewer the most capable model that you can, with a high reasoning effort, and
never a model that is less capable than you.

If you can't start separate agents, review one category at a time yourself, and reread the change from the start for
each category. If you can't choose the model or the reasoning effort of a reviewer, use the default and say so in the
report.

Each reviewer must start from a fresh context. If you wrote the change yourself, give the reviewers the facts about it,
but not your reasons for thinking that it is correct, because those reasons would make the reviewers likely to agree
with you.

Pass each reviewer:

- The path of the review checkout, the revision range, the commit ID of the pull request's head, and what the pull
  request must do.
- The problems that comments on the pull request already report.
- The full text of its category from [Categories](#categories). The reviewer can't see this skill, so the name of the
  category alone isn't enough. Adapt the text to the pull request, for example to its language.
- The skills that apply to the code, by name and by path, with the instruction to read them before starting. A
  reviewer doesn't load a skill unless you tell it to. Always include [`designing-tests`](../designing-tests/SKILL.md).

Tell each reviewer to:

1. Read the full change, and read the code around the change as well as the diff, because a change can break code
   that it doesn't touch.
2. Run the code only if reading it isn't enough, and only when that helps to understand the change or to find or
   confirm a specific problem. For example, it can build the code, run the tests, run the program, read its logs or
   take screenshots of its UI. It must not change shared state, for example by deploying or writing to a live
   database or cluster. It must use ports, namespaces and other shared resources that no other reviewer uses.
3. Change code only when that is needed to find or confirm a specific problem, and only in its own temporary checkout,
   never in the review checkout. For example, it can write a test that checks whether the change handles an edge case.
   Commands that rewrite tracked files, such as formatters and code generators, also count as changing code. It should
   create the checkout from the commit ID `$head` of the pull request's head, in a temporary directory outside the
   repository, with a name `$name` that no other reviewer uses:
   - In git, it should run `git worktree add --detach $directory $head`, and `git worktree remove --force $directory`
     when it no longer needs the checkout.
   - In jj, it should run `jj workspace add --name $name -r $head $directory`. When it no longer needs the checkout,
     it should abandon the commits that it made there with `jj --repository $directory abandon "$head..$name@"`, then
     run `jj workspace remove $name`.
4. Look only for problems in its own category and ignore everything else. The problems listed in the category are
   examples, so it must also look for other problems of the same kind.
5. Be adversarial, examining the change critically instead of assuming it is correct.
6. Skip any problem that a comment on the pull request already reports, unless it finds out more about that problem.
7. Leave the commits of the pull request and the pull request itself unchanged, and post no comments on GitHub.
8. Report these details for each problem it finds:
   - The location, as file, line and commit.
   - The problem.
   - A specific case that shows the problem. For a bug, that means the input or state, and the wrong result.
   - How it confirmed the problem, if it ran something to do so. See [Evidence](#evidence).
   - Whether the problem is important or minor.
   - A possible fix.
9. List the important checks it ran that found no problem, such as running the program against a cluster and seeing
   the new feature work, along with the [evidence](#evidence) for each. Small checks, such as a passing build, aren't
   worth listing.
10. Say so if it finds no problems, rather than reporting problems that aren't real just to have findings.

### Evidence

The author of the pull request must be able to see that a finding is real and to repeat the check. So whenever a
reviewer runs something to confirm a problem or to check the change, it must report:

- The full code of each test, script or small program it wrote, and where it put each one, such as the test's file.
  It removes its checkout at the end, so the code must be in the report.
- The commands it ran, in order, and any changes it made to the environment before running them.
- The part of the output that shows the result, such as the panic message and its stack trace, rather than the whole
  output when most of it doesn't matter.

### Categories

The problems in each category are examples, not a complete list.

#### Bugs

Find the cases where the code doesn't do what it should. The pull request, its description and its linked issues
describe what the code should do. A bug is only real if a specific case shows it, meaning an input or a state and the
wrong result. If you can't find such a case, it isn't a bug.

Look for:

- Logic that doesn't match the request, such as a condition that is the wrong way around, or a case from the request
  that the code doesn't handle.
- Edge cases, such as empty values, zero, negative or very large numbers, missing optional values, the first and last
  items of a list, duplicate items, and non-ASCII text.
- Errors that the code ignores or turns into a value that looks valid, errors that lose the information that the user
  needs to find the cause, and panics or crashes on values that can be missing.
- Operations that can fail halfway and leave the state wrong, for example because there is no rollback or cleanup.
- Concurrency problems, such as race conditions, deadlocks, wrong assumptions about the order of events, tasks that are
  cancelled halfway, and retries of operations that must only happen once.
- Resources that the code never releases, such as files, connections or tasks, and operations that can wait forever
  because they have no timeout.
- Changes that break things that the pull request doesn't touch, such as callers that expect the old behavior, stored
  data, configuration and migrations.
- Changes that break compatibility between versions, such as a changed wire format, CLI flag, configuration option or
  public API, when an old client talks to a new server or a new client talks to an old one.
- Security problems, such as unvalidated input from users or the network, missing permission checks, and secrets in
  logs or error messages.
- Tests that don't test what they claim to, or that pass when the code is wrong.

#### Design, readability and simplicity

Check that the code is easy to read, understand and change. A reader should be able to follow the code without effort,
and someone who changes it later shouldn't have to work around it. Code that is simple and well designed also has
fewer places where a bug can go unnoticed.

The topics below are closely related. Code that isn't idiomatic is often more complex than it needs to be. A smell,
described below, often points to a problem in the design. When you find a problem, look for its cause in the design,
and suggest a fix for the cause rather than only for the symptom.

For each finding, show the better code and check that it keeps the same behavior. Don't suggest changes that only move
code somewhere else or that only reflect a different personal style, and don't suggest shorter code that is harder to
read.

Look for:

- Changes that go beyond the request, such as files and interfaces that no part of the request needs, and refactors,
  renames or reformatting that the change doesn't need. Suggest moving these to a separate pull request.
- Unnecessary code, such as dead code, parameters and configuration that nothing uses, checks that can never fail, and
  code that handles states that can't happen.
- Abstractions that don't help, such as interfaces, traits or generics that have only one implementation and make no
  test or caller simpler, and small functions that only one place calls and that only add indirection.
- Duplicate code, meaning logic that is repeated in the change or that already exists in the repository or in a
  library the project uses, including a new mechanism that does what an existing one already does. Suggest reusing the
  code that is already there.
- Code that does by hand what the language or its standard library already does, such as index loops instead of
  iterators in Rust, or `match` on errors instead of `?`.
- Code that doesn't follow the project's conventions, for example for error handling, logging or module layout. Read
  the code around the change to learn these conventions.
- Smells, meaning constructs that the code sometimes needs but that a better design can often remove, such as
  `clone()`, `collect()`, `RefCell` and `Mutex` in Rust. Examine each smell in the change, and check whether a
  different design would avoid it.
- Concurrent code that relies heavily on synchronization, when a different design, such as a single owner of the data
  or message passing, wouldn't need it.
- Data types that allow invalid states, when a better type such as an enum would remove checks from the code.
- Control flow that is hard to follow, such as deep nesting that an early return could remove, unnecessary flags and
  state variables, and long functions that mix high-level and low-level steps.
- Variables whose scope is larger than it needs to be.
- Names that don't say what a thing is or does, comments that are wrong or only repeat the code, and non-obvious code
  with no comment explaining why.
- Tests and designs that go against the [`designing-tests`](../designing-tests/SKILL.md) skill, such as tests of a
  dependency's promises, assertions on what a mock was told to return, and production code that only exists for tests.

#### Performance

Code should always be fast. Check that the code doesn't do work that a better design would avoid, and that it does
the work it needs as fast as possible.

Look for:

- Work inside a loop that could be done once before the loop.
- Algorithms that are slower than they need to be, such as O(n²) where O(n) is possible.
- Data structures that don't fit how the code uses the data, such as searching a large list where a hash map or a set
  would find the item directly.
- Memory access patterns that make poor use of the CPU cache. On modern CPUs, cache use often matters more for speed
  than anything else. Examples are data spread over many small heap allocations when one contiguous buffer could hold
  it, or a loop that reads data in a different order from how it is laid out in memory.
- Copies and allocations that could be avoided.
- Work that is repeated when it could be done once at startup or at compile time, such as a regular expression that
  is compiled on every call.
- I/O that is slower than it needs to be, such as unbuffered reads and writes, many small system calls where one large
  call would do, and reading all the data into memory where a stream would work.
- One request or query per item in a list, when a single request could cover all the items.
- Blocking calls in async code, and locks that are held during I/O or across an `await`.
- Memory that can grow without limit, such as caches and queues with no maximum size.
- Work that runs serially when it could run in parallel.

Report all work that could be avoided or made faster, even when the effect is small, and estimate how large the
effect is for each finding.

## 4. Check the findings

Read each finding and check it against the code to make sure it is real, without assuming that the reviewer is right.

Keep the findings that turn out not to be real, because the report must list them along with the reason each one is
not real.

If you run something to check a finding, record the [evidence](#evidence) the way the reviewers do. Keep the
evidence from the reviewers as well, because you need it for the report and for the comments.

## 5. Report

Tell the user:

- The CI checks that fail, if any.
- The real findings, most important first. For each one, give its location as file, line and commit, the problem, how
  it was confirmed and a possible fix.
- The important checks that found no problem.
- The findings that aren't real, and why.

## 6. Post the review

Only do this step if the user asks you to post the review.

1. Write the [comments](#comments).
2. Write the [body of the review](#body-of-the-review).
3. Choose the [type of the review](#type-of-the-review).
4. Post all the comments as one review, with each comment on the lines it is about. `gh pr review` can't comment
   on lines, so with `gh`, use `gh api repos/<owner>/<repo>/pulls/<number>/reviews --input <review file>`. The review
   file is JSON and holds `commit_id`, `event` (`APPROVE`, `REQUEST_CHANGES` or `COMMENT`), `body`, and `comments`,
   with `path`, `line`, `side` and `body` for each comment.

### Style

These rules apply to the comments and to the body of the review, and to replies on a pull request in general. Write
only the facts that the author needs, so that every sentence says something about the code.

- Start with the problem. Instead of "Nice work! One small thing: the `None` branch can't occur.", write "The `None`
  branch can't occur."
- The review can be wrong. When a finding comes from your reading of the code and you didn't confirm it, say so in
  your own words, for example "As far as I can tell, nothing waits on the child before this line." When the evidence
  confirms the finding, state it directly.
- Be direct, and don't thank, praise or greet the author.
- Don't tell the author what the pull request does, because they already know.
- Don't make a problem sound smaller or larger than it is with words such as "just", "small" or "critical". Describe
  the effect of the problem and let the author judge how much it matters.

### Comments

Write one comment for each finding that the user wants to post.

- Make each comment about one thing only. If a finding contains more than one problem or idea, split it into several
  comments.
- State the finding, the case that shows it and a possible fix in a few words or sentences, without repeating what the
  code or another comment already shows.
- Include the [evidence](#evidence), so that the author can see the problem and repeat the check. If a test shows the
  problem, include the test so that the author can add it to the pull request. Wrap long code and long output in a
  `<details>` block.
- Link each file, function or other piece of code that the comment mentions to its location on GitHub with a permalink,
  so that the author can find it easily. For code that the pull request doesn't change, link to the pull request's base
  commit, and for code that it adds or changes, link to its head commit. Use the name of the code as the link text, for
  example:

  ```markdown
  [`ci.yaml`](https://github.com/metalbear-co/mirrord/blob/9f10a12343d76cf585cd0d1c3205609ff0ad2984/.github/workflows/ci.yaml#L56)
  ```

### Body of the review

Put only the findings that aren't about specific lines of code in the body. Don't repeat or summarize the comments,
and don't tell the author what they already know, such as the CI checks that fail or the checks that found no problem.
If there are no such findings, leave the body empty.

### Type of the review

- Approve if there are no findings, if all the findings are minor, or if they can be fixed in a later pull request.
- Request changes if there are important findings that the pull request must fix before it is merged.
- Comment if you aren't sure which of the two to choose.
