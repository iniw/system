---
name: review-pull-request
description: Reviews a GitHub pull request with adversarial subagents, then makes sure that each finding is real. Use when asked to review a pull request. Also use each time before you start a subagent to review a pull request.
---

# Reviewing pull requests

Follow all the steps below, in order.

For all work on GitHub, such as reading the pull request, its checks and its comments, use your GitHub tools. If they
aren't available, fall back to the `gh` CLI.

## 1. Read the pull request

1. Read the title, the description, the linked issues and the CI checks of the pull request, and read any Linear issue
   with the Linear tools. The reviewers need this to recognize behavior that is wrong.
2. Read the comments and review threads already on the pull request, and don't report a problem that a comment
   already reports. If you find out more about such a problem, for example that it is worse than the comment says or
   that it has more causes or effects, report it and say which comment it builds on.

## 2. Check out the pull request

The reviewers must read the full code, not only the diff. If the current directory isn't a clone of the pull
request's repository, ask the user where the clone is.

Don't check out the pull request in the current workspace, because the user may have work in its working copy. Use a
separate jj workspace for the review instead:

1. Fetch the pull request with `jj-gh pr fetch <number>`, which prints the name of the bookmark it creates, for example
   `pr-123/branch-name`.
2. Create the review workspace in a temporary directory outside the repository:

   ```sh
   jj workspace add --name review-$number -r $bookmark $directory
   ```

   The subagents read the code in this directory with their usual tools, so pass them its path.
3. The revision range of the pull request is `<base>@origin..<bookmark>`, where `<base>` is the pull request's base
   branch.

## 3. Start the reviewers

Start one subagent per category in [Categories](#categories), all in parallel. Each subagent needs the most capable
model with a high reasoning effort, so set the model explicitly rather than relying on the default:

- In Claude Code, use `fable`.
- In Codex, use `astra`.

If neither applies, use the most capable model available, and never a model that is less capable than you.

Pass each subagent:

- The revision range, and what the pull request must do.
- The problems that comments on the pull request already report.
- The full text of its category from [Categories](#categories). The subagent can't see this skill, so the name of the
  category alone isn't enough. Adapt the text to the pull request, for example to its language.

Tell each subagent to:

1. Read the full change with `jj log -r <range>` and `jj diff --git -r <range>`, and read the code around the change as
   well as the diff, because a change can break code that it doesn't touch.
2. Run the code only if reading it isn't enough, and only when that helps to understand the change or to find or
   confirm a specific problem. For example, it can build the code, run the tests, run the program, read its logs or
   take screenshots of its UI. It must not do anything that changes shared state, such as a deploy or a write to a live
   database or cluster.
3. Change code only when that is needed to find or confirm a specific problem, and only in its own temporary jj
   workspace, never in the review workspace. For example, it can write a test that checks whether the change handles an
   edge case. It should create the workspace in a temporary directory outside the repository, with a name that no
   other subagent uses:

   ```sh
   jj workspace add --name $name -r $bookmark $directory
   ```

   When it no longer needs the workspace, it should remove the workspace and every commit it made there:

   ```sh
   jj --repository $directory abandon "$bookmark..$name@"
   jj workspace remove $name
   ```

4. Look only for problems in its own category and ignore everything else. The problems listed in the category are
   examples, so it must also look for other problems of the same kind.
5. Be adversarial, examining the change critically instead of assuming it is correct.
6. Skip any problem that a comment on the pull request already reports, unless it finds out more about that problem.
7. Leave the commits of the pull request and the pull request itself alone, and not post comments on GitHub.
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
subagent runs something to confirm a problem or to check the change, it must report:

- The full code of each test, script or small program it wrote, and where it put it, such as the test's file. It
  removes its workspace at the end, so the report has to hold the code.
- The commands it ran, in order, and any changes it made to the environment before running them.
- The part of the output that shows the result, such as the panic message and its stack trace, rather than the whole
  output when most of it doesn't matter.

### Categories

The problems in each category are examples, not a complete list.

#### Bugs

Find the cases where the code doesn't do what it should. The pull request, its description and its linked issues
describe what the code should do. A bug is only real if there is a specific case that shows it, meaning an input or a
state and the wrong result, so if you can't find such a case, it isn't a bug.

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
- Changes that break code the pull request doesn't touch, such as callers that expect the old behavior, old clients,
  stored data, configuration and migrations.
- Security problems, such as unvalidated input from users or the network, missing permission checks, and secrets in
  logs or error messages.
- Tests that don't test what they claim to, or that pass when the code is wrong.

#### Design, readability and simplicity

Check that the code is easy to read, understand and change. A reader should be able to follow the code without effort,
and someone who changes it later shouldn't have to work around it. Code that is simple and well designed also has
fewer places where a bug can go unnoticed.

The topics below are closely related. Code that isn't idiomatic is often more complex than it needs to be, and a smell
often points to a problem in the design. When you find a problem, look for its cause in the design, and suggest a fix
for the cause rather than only for the symptom.

For each finding, show the better code and check that it keeps the same behavior. Don't report changes that only move
code somewhere else or that only reflect a different personal style, and don't make code shorter if that makes it
harder to read.

Look for:

- Unnecessary code, such as dead code, parameters and configuration that nothing uses, checks that can never fail, and
  code that handles states that can't happen.
- Abstractions that don't help, such as interfaces, traits or generics with only one implementation, and small
  functions that are used once and only add indirection.
- Duplicate code, meaning logic that is repeated in the change or that already exists in the repository or in a
  library the project uses. Reuse the code that is already there.
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
- Tests and designs that go against the "Tests" section of the global instructions.

#### Performance

Code should always be fast. Check that the code doesn't do work that a better design would avoid, and that it does
the work it needs as fast as possible.

Look for:

- Work inside a loop that could be done once before the loop.
- Algorithms that are slower than they need to be, such as O(n²) where O(n) is possible.
- Data structures that don't fit how the code uses the data, such as searching a large list where a hash map or a set
  would find the item directly.
- Memory access patterns that are bad for the CPU cache, which on modern CPUs often matter more for speed than anything
  else. Examples are data spread over many small heap allocations when one contiguous buffer could hold it, or a loop
  that reads data in a different order from how it is laid out in memory.
- Copies and allocations that could be avoided.
- Work that is repeated every time when it could be done once at startup or at compile time, such as a regular
  expression that is compiled on every call.
- I/O that is slower than it needs to be, such as unbuffered reads and writes, many small system calls where one large
  call would do, and reading all the data into memory where a stream would work.
- One request or query per item in a list, when a single request could cover all the items.
- Blocking calls in async code, and locks that are held during I/O or across an `await`.
- Memory that can grow without limit, such as caches and queues with no maximum size.
- Work that runs serially when it could run in parallel.

Report all work that could be avoided or made faster, even when the effect is small, and say how large you think the
effect is for each finding.

## 4. Check the findings

Read each finding and check it against the code to make sure it is real, without assuming that the subagent is right.

Keep the findings that turn out not to be real, because the report must list them along with the reason each one is
not real.

If you run something to check a finding, keep the [evidence](#evidence) the same way the subagents do. Keep the
evidence from the subagents as well, because you need it for the report and for the comments.

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
4. Post all the comments as one review, with each comment on its relevant lines.

### Style

These rules apply to the comments and to the body of the review. Write only the facts that the author needs, so that
every sentence says something about the code.

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
- In a few words or sentences, state the finding, the case that shows it and a possible fix, without repeating what the
  code or another comment already shows.
- Include the [evidence](#evidence), so that the author can see the problem and repeat the check. If a test shows the
  problem, include the test so that the author can add it to the pull request. Wrap long code and long output in a
  `<details>` block.
- Link each file, function or other piece of code that the comment mentions to its location on GitHub with a
  permalink, so that the author can find it easily. Use the name of the code as the link text, for example
  `` [`ci.yaml`](https://github.com/metalbear-co/mirrord/blob/9f10a12343d76cf585cd0d1c3205609ff0ad2984/.github/workflows/ci.yaml#L56) ``. <!-- rumdl-disable-line line-length -->
  For code that the pull request doesn't change, link to the pull request's base commit, and for code that it adds or
  changes, link to its head commit.

### Body of the review

Put only the findings that aren't about specific lines of code in the body. Don't repeat or summarize the comments,
and don't tell the author what they already know, such as the CI checks that fail or the checks that found no problem.
If there are no such findings, leave the body empty.

### Type of the review

- Approve if there are no findings, if all the findings are minor, or if they can be fixed in a later pull request.
- Request changes if there are important findings that the pull request must fix before it is merged.
- Comment if you aren't sure which of the two to choose.
