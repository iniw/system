---
name: reviewing-pull-requests
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

1. Fetch the pull request with `jj pr fetch <number>`. It prints the name of the bookmark that it makes (for example,
   `pr-123/branch-name`).
2. Check out the pull request with `jj new <bookmark>`. Then the subagents can read the code with their usual tools.
3. The revision range of the pull request is `<base>@origin..<bookmark>`, where `<base>` is the base branch of the pull
   request.

## 3. Start the reviewers

Start subagents in parallel, one for each category below. Use the most capable model, with a high reasoning effort.

Give each subagent:

- The revision range, and what the pull request must do.
- The problems that the comments on the pull request already report.
- Its category, with a short explanation of the problems to look for. Use the categories below as a guide, and change
  them to fit the pull request (for example, to fit its language).

Tell each subagent to:

1. Read the full change. Use `jj log -r <range>` and `jj diff --git -r <range>`. Also read the code around the change,
   not only the diff, because a change can break code that it does not touch.
2. If reading the code is not sufficient, it can also run the code. Do this only when it helps to understand the change
   or to find or confirm a specific problem. For example, it can build the code, run the tests, run the program, read
   its logs or take screenshots of its UI. It must not do actions that change a shared state, for example a deploy, or
   a write to a live database or cluster.
3. If it must change the code to find or confirm a specific problem, do this only in a temporary jj workspace, and never
   in the checkout of the pull request. For example, it can write a test that checks if the change handles an edge
   case. Make the workspace in a temporary directory that is outside of the repository, with a name that no other
   subagent uses:

   ```sh
   jj workspace add --name $name -r $bookmark $directory
   ```

   When it no longer needs the workspace, it must remove it, and all the commits that it made in it:

   ```sh
   jj abandon "$bookmark..$name@"
   jj workspace forget $name
   rm -rf $directory
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
   - A specific case that shows the problem. For a bug, give the input or the state, and the incorrect result. If it
     ran something that shows the problem (for example, a test), give the command and its output.
   - If the problem is important or minor.
   - A possible fix.
9. Say so if it finds no problems. It must not report problems that are not real only to have findings.

The categories are:

- Bugs: incorrect behavior, missing error handling, race conditions and edge cases.
- Simplifications: code that can be shorter or clearer, duplicate code and code that is not necessary.
- Performance and idiomatic code: code that is slow, does work that is not necessary, or is not idiomatic for its
  language. The code must use the features of the language and follow its purpose, not work against them. For example:
  - Smells: constructs that the code sometimes needs, but that a better design can often remove (for example, in Rust:
    `clone()`, `collect()`, `RefCell` and `Mutex`). Examine each smell in the change.
  - Concurrent code that relies heavily on synchronization when a different design does not need it.
  - Work that is done serially when it can be done in parallel.

The problems in each category are examples. They are not a full list.

## 4. Check the findings

Read each finding and examine it against the code. Make sure that it is real. Do not assume that a subagent is correct.

Keep the findings that are not real. You must tell about them in the report, with the reason that each one is not real.

## 5. Report

Tell the user:

- The CI checks that fail, if there are some.
- The real findings, the important ones first. For each finding, give its location (file, line and commit), the problem
  and a possible fix.
- The findings that are not real, and why.

## 6. Post the review

Do this step only if the user asks you to post the review.

1. Write one comment for each finding that the user wants to post.
2. Choose the type of the review:
   - Approve, if there are no findings, or if all the findings are minor, or if they can be fixed in a different pull
     request.
   - Request changes, if there are important findings that the pull request must fix before it is merged.
   - Comment, if you are not certain which one to choose.
3. Post all the comments as one review, with each comment on the line of its finding.
