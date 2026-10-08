---
name: review-pull-request
description: Reviews a GitHub pull request with adversarial subagents, then makes sure that each finding is real. Use when asked to review a pull request. Also use each time before you start a subagent to review a pull request.
---

# Reviewing Pull Requests

Do all the steps below, in order.

For all work on GitHub (for example, to read the pull request, its checks and its comments), use your GitHub tools. If
they are not available, use the `gh` CLI.

## 1. Read the pull request

1. Read the title, the description, the linked issues and the CI checks of the pull request. If an issue is on Linear,
   read it with the Linear tools. The reviewers need this to find behavior that is not correct.
2. Read the comments and the review threads that are already on the pull request. Do not report a problem again if a
   comment already reports it. But if you find more about that problem (for example, it is worse than the comment says,
   or it has more causes or effects), report it, and say which comment it adds to.

## 2. Check out the pull request

The reviewers must read the full code, not only the diff. If the current directory is not a clone of the repository of
the pull request, ask the user where the clone is.

Do not check out the pull request in the current workspace. The user can have work in its working copy. Use a separate
jj workspace for the review.

1. Fetch the pull request with `jj-gh pr fetch <number>`. It prints the name of the bookmark that it makes (for example,
   `pr-123/branch-name`).
2. Make the review workspace in a temporary directory that is outside of the repository:

   ```sh
   jj workspace add --name review-$number -r $bookmark $directory
   ```

   The subagents read the code in this directory with their usual tools. Give them its path.
3. The revision range of the pull request is `<base>@origin..<bookmark>`, where `<base>` is the base branch of the pull
   request.

## 3. Start the reviewers

Start subagents in parallel, one for each category in [Categories](#categories). Use the most capable model, with a high
reasoning effort. The model must be at least as capable as you.

Give each subagent:

- The revision range, and what the pull request must do.
- The problems that the comments on the pull request already report.
- Its category: the full text of the category from [Categories](#categories). The subagent cannot see this skill, so do
  not only give it the name of the category. Change the text to fit the pull request (for example, to fit its
  language).

Tell each subagent to:

1. Read the full change. Use `jj log -r <range>` and `jj diff --git -r <range>`. Also read the code around the change,
   not only the diff, because a change can break code that it does not touch.
2. If reading the code is not sufficient, it can also run the code. Do this only when it helps to understand the change
   or to find or confirm a specific problem. For example, it can build the code, run the tests, run the program, read
   its logs or take screenshots of its UI. It must not do actions that change a shared state, for example a deploy, or
   a write to a live database or cluster.
3. If it must change the code to find or confirm a specific problem, do this only in its own temporary jj workspace, and
   never in the review workspace. For example, it can write a test that checks if the change handles an edge
   case. Make the workspace in a temporary directory that is outside of the repository, with a name that no other
   subagent uses:

   ```sh
   jj workspace add --name $name -r $bookmark $directory
   ```

   When it no longer needs the workspace, it must remove it, and all the commits that it made in it:

   ```sh
   jj --repository $directory abandon "$bookmark..$name@"
   jj workspace remove $name
   ```

4. Look only for problems in its category, and ignore all other problems. The problems that you give it are examples.
   It must also look for other problems of the same type.
5. Be adversarial: examine the change critically, and not assume that it is correct.
6. Not report a problem again if a comment on the pull request already reports it, unless it finds more about that
   problem.
7. Not change the commits of the pull request or the pull request itself, and not post comments on GitHub.
8. Give these for each problem that it finds:
   - The location: file, line and commit.
   - The problem.
   - A specific case that shows the problem. For a bug, give the input or the state, and the incorrect result.
   - How it confirmed the problem, if it ran something to do this. See [Evidence](#evidence).
   - If the problem is important or minor.
   - A possible fix.
9. Tell which important checks it ran that found no problem. For example, it ran the program against a cluster, and the
   new feature worked correctly. Do not tell about small checks, for example a build that passes. Give the
   [evidence](#evidence) for each check.
10. Say so if it finds no problems. It must not report problems that are not real only to have findings.

### Evidence

The author of the pull request must be able to see that a finding is real, and to do the same check again. So, when the
subagent runs something to confirm a problem or to check the change, it must give:

- The full code of each test, script or small program that it wrote, and where it put it (for example, the file of the
  test). It removes its workspace at the end, so the report must contain the code.
- The commands that it ran, in order, and the changes that it made to the environment before it ran them.
- The part of the output that shows the result, for example the panic message and its stack trace. Do not give all of
  the output if most of it is not important.

### Categories

The problems in each category are examples. They are not a full list.

#### Bugs

Find the cases where the code does not do what it must do. The pull request, its description and its linked issues tell
what the code must do. A bug is real only if there is a specific case that shows it: an input or a state, and the
incorrect result. If you cannot find such a case, it is not a bug.

Look for:

- Logic that does not agree with the request. For example, a condition that is the wrong way around, or a case of the
  request that the code does not handle.
- Edge cases: empty values, zero, negative or very large numbers, missing optional values, the first and the last item
  of a list, duplicate items, and text that is not ASCII.
- Errors that the code ignores, or that it changes into a value that looks correct. Panics or crashes on values that can
  be missing. Errors that lose the information that the user needs to find the cause.
- Operations that can fail half-way and leave the state incorrect, for example with no rollback or cleanup.
- Concurrency problems: race conditions, deadlocks, incorrect assumptions about the order of events, tasks that are
  cancelled half-way, and retries of operations that must occur only once.
- Resources that the code does not release, for example files, connections or tasks. Operations that can wait forever
  because they have no timeout.
- Changes that break code that the pull request does not touch: callers that expect the old behavior, old clients,
  stored data, configuration and migrations.
- Security problems: input from users or from the network that the code does not validate, missing permission checks,
  and secrets in logs or in error messages.
- Tests that do not test what they say, or that pass when the code is wrong.

#### Design, readability and simplicity

Make sure that the code is easy to read, to understand and to change. A reader must be able to follow the code without
effort, and a person who changes it later must not have to work against it. Code that is simple and well designed also
has fewer places where bugs can hide.

The topics below are closely related. Code that is not idiomatic is often more complex than necessary, and a smell often
shows a problem in the design. When you find a problem, look for its cause in the design, and suggest a fix for the
cause, not only for the symptom.

For each finding, show the better code, and make sure that it keeps the same behavior. Do not report changes that only
move code to a different location, or that are only a different personal style. Do not make code shorter if that makes
it harder to read.

Look for:

- Code that is not necessary: dead code, parameters and configuration that nothing uses, checks that can never fail,
  and code that handles states that cannot occur.
- Abstractions that do not help: interfaces, traits or generics with only one implementation, and small functions that
  are used only once and only add indirection.
- Duplicate code: logic that is repeated in the change, or that is already in the repository or in a library that the
  project uses. Use the code that is already there.
- Code that does manually what the language or its standard library already does. For example, in Rust: index loops
  instead of iterators, or `match` on errors instead of `?`.
- Code that does not follow the conventions of the project, for example how it handles errors, how it logs, or how it
  organizes modules. Read the code around the change to find these conventions.
- Smells: constructs that the code sometimes needs, but that a better design can often remove (for example, in Rust:
  `clone()`, `collect()`, `RefCell` and `Mutex`). Examine each smell in the change, and find if a different design does
  not need it.
- Concurrent code that relies heavily on synchronization, when a different design (for example, one owner of the data,
  or message passing) does not need it.
- Data types that allow states that are not valid, when a better type (for example, an enum) removes checks from the
  code.
- Control flow that is hard to follow: deep nesting that an early return can remove, flags and state variables that are
  not necessary, and long functions that mix high-level and low-level steps.
- Variables with a scope that is larger than necessary.
- Names that do not tell what a thing is or does. Comments that are wrong, or that only repeat the code. Code that is
  not obvious and has no comment that tells why.
- Tests and designs that go against the "Tests" section of the global instructions.

#### Performance

Code must be fast. This is always a goal. Make sure that the code does not do work that a better design does not need,
and that it does the work that it needs as fast as possible.

Look for:

- Work in a loop that can be done one time before the loop.
- Algorithms that are slower than necessary, for example O(n²) where O(n) is possible.
- Data structures that do not fit how the code uses the data. For example, a search in a large list where a hash map or
  a set finds the item directly.
- Memory access patterns that are bad for the CPU cache. On modern CPUs, these often have more effect on speed than
  anything else. For example, data in many small heap allocations when one contiguous buffer can hold it, or a loop
  that reads data in an order that does not agree with how it is stored in memory.
- Copies and allocations that can be avoided.
- Work that is done again each time, when it can be done one time at startup or at compile time. For example, a regular
  expression that is compiled on each call.
- I/O that is slower than necessary: reads and writes with no buffer, many small system calls where one large call is
  possible, and full data read into memory where a stream is possible.
- One request or query for each item in a list, when one request for all the items is possible.
- Blocking calls in async code, and locks that are held during I/O or during an `await`.
- Memory that can grow without a limit, for example caches and queues with no maximum size.
- Work that is done serially when it can be done in parallel.

Report all work that can be avoided or made faster, also when its effect is small. For each finding, tell how large you
think the effect is.

## 4. Check the findings

Read each finding and examine it against the code. Make sure that it is real. Do not assume that a subagent is correct.

Keep the findings that are not real. You must tell about them in the report, with the reason that each one is not real.

If you run something to examine a finding, keep the [evidence](#evidence) in the same way as the subagents do. Keep the
evidence that the subagents give too. You need it for the report and for the comments.

## 5. Report

Tell the user:

- The CI checks that fail, if there are some.
- The real findings, the important ones first. For each finding, give its location (file, line and commit), the problem,
  how it was confirmed and a possible fix.
- The important checks that found no problem.
- The findings that are not real, and why.

## 6. Post the review

Do this step only if the user asks you to post the review.

1. Write the [comments](#comments).
2. Write the [body of the review](#body-of-the-review).
3. Choose the [type of the review](#type-of-the-review).
4. Post all the comments as one review, with each comment on it's relevant lines.

### Style

This applies to the comments and to the body of the review. Write only the facts that the author needs. Each sentence
must give information about the code.

- Start with the problem. For example, "The `None` branch cannot occur.", and not "Nice work! One small thing: the
  `None` branch cannot occur."
- The review can be wrong. When a finding comes from your reading of the code, and you did not confirm it, say so in
  your own words. For example, "As far as I can tell, nothing waits on the child before this line." When the evidence
  confirms the finding, write it directly.
- Be direct. Do not thank the author, praise the change or greet the author.
- Do not tell the author what the pull request does. The author knows it.
- Do not make a problem seem smaller or larger than it is. Do not use words such as "just", "small" or
  "critical" to do this. Tell the effect of the problem, and the author can judge how important it is.

### Comments

Write one comment for each finding that the user wants to post.

- One thing: each comment must be about one thing only. If a finding contains more than one problem or idea, split it
  into more comments.
- Content: in a few words or sentences, give the finding, the case that shows it and a possible fix. Do not repeat what
  the code or a different comment already shows.
- Evidence: give the [evidence](#evidence), so that the author can see the problem and do the check again. If a test
  shows the problem, give the test, so that the author can add it to the pull request. Put long code and long output in
  a `<details>` block.
- Links: link each file, function or other code that the comment mentions to its location on GitHub with a permalink, so
  that the author can read it easily. Use the name of the code as the text of the link, for example
  `` [`ci.yaml`](https://github.com/metalbear-co/mirrord/blob/9f10a12343d76cf585cd0d1c3205609ff0ad2984/.github/workflows/ci.yaml#L56) ``. <!-- rumdl-disable-line line-length -->
  For code that the pull request does not change, use the base commit of the pull request. For code that the pull
  request adds or changes, use its head commit.

### Body of the review

Put in the body only the findings that are not about specific lines of the code. Do not repeat or summarize the
comments, and do not tell the author what they already know, for example the CI checks that fail or the checks that
found no problem. If there are no such findings, leave the body empty.

### Type of the review

- Approve, if there are no findings, or if all the findings are minor, or if they can be fixed in a different pull
  request.
- Request changes, if there are important findings that the pull request must fix before it is merged.
- Comment, if you are not certain which one to choose.
