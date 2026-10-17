---
name: format-commit-and-pull-request
description: What to write in commit messages and in pull request titles and descriptions, and their format rules, for example the subject line format, line lengths and pull request templates. Use each time you write or change a commit message (for example with `jj describe` or `jj commit`) or a pull request title or description, or when you check commit messages before a pull request.
---

# Formatting commits and pull requests

This skill describes what to write in commit messages and pull requests, and how to format them.

## Content

These rules apply to commit messages and to pull request descriptions.

### Keep it short

Short text is easier to read and to review. Agents usually write too much, so write less than you think you need.

- Write only what the reader needs to understand and review the change. If removing a sentence loses the reader no
  information, remove it.
- Don't repeat what the title, the diff or another part of the text already says.
- Don't list every file, function or test that changes.
- If the subject line already tells the reader everything they need, skip the body. For example,
  `` cli: add a `--version` flag ``.

The length of the body depends on how much the reader can't work out from the diff, not on the size of the diff. A
change whose reason is a single fact gets a single sentence, such as `deps: drop the patch for openssl-sys` with the
body "The fix was released upstream in 0.9.104", while a subtle bug in a few lines can need several paragraphs.

### Explanation

Start by reading the change and finding the problem that a user or a developer can see. Then write about that problem,
rather than describing the edit one file at a time.

Before you write, use all the context you have to answer these questions:

1. What is wrong now?
2. Does the change fix that problem directly, or does it only prepare for a later change that fixes it?

The explanation usually follows this order:

1. The problem and its cause, in one paragraph. Use the past tense for the old behavior ("The cache kept…"). Trace
   the cause from the code to the symptom, joining each step to the one before it with words such as "so", "then" or
   "which", and end with one concrete case that a reader can try, such as an input and its wrong output, or a command
   that failed. A symptom without its cause isn't enough.
2. Who the problem affects. If it only happens under some conditions, name them and say who isn't affected, so that
   the reader knows how much it matters. If bug reports, logs or crash dumps show the problem, say how they match the
   cause, because that shows that the cause is the real one and not only a plausible one.
3. The fix. Use the present tense for the new behavior ("The cache now removes…"), not the imperative mood
   ("Remove…").
4. Why this is the right approach. Only write this if the change doesn't make it clear. The strongest reasons are:
   - Code in the project that already does the same thing, for example "as eviction already does for pinned entries".
     Name that code, so that the reader can compare the two.
   - A simpler alternative that the reader would think of, and the fact that rules it out.
   - A dependency's documented behavior that forces the design. Name the document and say what it guarantees.
5. What the change costs, if anything, such as a slower path, more memory, a new way to fail, or a feature that stays
   off by default because of its cost.

Account for every part of the diff that the reader would otherwise question, such as a changed test, a moved helper or
a side fix, with one sentence each at the end. For example: "The expiry test now uses a fake backend that never
responds, so that the refresh is still pending when the entry expires."

If the reader might expect the change to do something that it doesn't do, say so. For example: "This adds the option
to the CLI, but not to the configuration file."

If the change only moves or renames code, write "No behavior change.", so that the reader knows not to look for one.

### References

When another commit or an issue is part of the reason for the change, name it. Use the hash of a public commit, because
the reader can't look up a change ID from your local history. These forms are common:

- "Regressed in 7e01ddbe41d, which made every lookup…", when an earlier commit caused the problem.
- "This reverts most of 1b46a52, which was a workaround for…".
- "Found by fuzzing the parser." or "Reported in #123.", which tells the reader how the problem came to light.

When you link to something, say what it shows, rather than leaving a bare link for the reader to open and interpret.

### Structure

The text must be easy to read and have enough structure to guide the reader, but it must still read as one
explanation from start to finish, with each part following from the one before it.

A commit body is prose. Use markdown in it only for content that prose can't carry well:

- A table for numbers, such as measurements before and after the change.
- A list for items that are truly parallel, such as the options that a change removes.
- A code block for a command or its output.

A pull request description can use more structure, such as headers and examples (see
[Description](#description)). In both, connect each list or table to the text around it, for example with a sentence
before a list that says what the list holds and why it is there.

### Changes that are part of a larger one

Some changes don't deliver the final behavior on their own, because a later change builds on them. Say where the change
sits in the larger effort and what remains, but keep it short. A preparatory commit usually only needs one closing
sentence, such as "A later commit uses this to retry failed uploads." Describe what the system does once this change is
applied, not what it will do after the later changes.

### Context that the reader does not have

The reader has the change, the repository and the public history of the project. They don't have your session, your
machine, your notes or the earlier versions of the change, so follow the rules below whenever you write about one of
these.

#### Evidence

Evidence is what you ran and what you saw that shows that the change is correct, such as a test, a benchmark or a
deployment to a cluster. Write about it, but describe the type of environment rather than its name or location, and say
what the check does so that the reader understands the result.

- Don't write "Tested in our k3s cluster." Write "Tested in a local k3s cluster with the operator installed: …"
- Don't write "The benchmark in the scratch directory shows a 2x speedup." Write "A local benchmark that sends 10,000
  requests to the cache shows a 2x speedup."

Give the result as numbers from before and after the change, for example "the request now takes 3 ms instead of 70 ms".
When the evidence is a new test, say that the test fails without the change, because that shows that the test
catches the problem. For example: "This commit also adds a test that…. Without this change, …"

Report the costs and the checks that found no difference as well as the improvements, because the reader needs them to
judge the trade-off. For example: "Creating a pool entry is twice as slow, but a benchmark that streams 500 MB through
the parser shows no difference outside of noise."

Describe the overall _process_ you used to check the change, and _why_ that process shows that the change is correct.
If the existing tests can't reach the changed code, say why, and describe what you checked instead. Don't mention
obvious, mechanical checks, such as the code compiling, the linters passing or the existing tests passing, because the
reader expects them.

In a pull request description, also include what the reader needs to repeat the check:

- The code of any test or benchmark.
- The commands you ran.
- The configuration of any deployment.
- The part of the output that shows the result.

Wrap these in a `<details>` block so that the description stays easy to read. A commit message can't have one, so it
only gets the short description of the check.

#### Reasons from your session

Don't refer to plans, notes, to-do lists or discussions with the user. The reader can't read them, so they don't
count as a reason for a decision. Write the reason itself instead.

Don't write "As the plan says, the cache stays per request." Write "The cache stays per request, because …"

#### Earlier versions

How the design changed during the work is often useful context, such as an approach that looks simpler but doesn't
work, or a problem that testing found and that changed the design. Write about an earlier version when it helps the
reader understand why the final design is the way it is, but don't walk through every step of the history.

The reader never saw the earlier version, so describe it fully. Don't write "Instead of the mutex from the first
version, this uses a channel." Write "A mutex is simpler, but it blocks all readers while the cache refreshes, so this
uses a channel."

## Commit messages

### Subject line

The subject line must tell the reader which part of the code changes and how. It shouldn't try to summarize the whole
change.

- Make one specific claim about the new behavior. Don't use vague verbs that hide what changes, like "fix",
  "refactor", "improve" or "update". Write `cache: only store responses whose transfer succeeded`, not
  `cache: fix response storage`.
- Stay at 72 characters or fewer
- Use the format `category: brief description of what's being changed`
  - Use a category that names the relevant library, application, service, utility, or similar unit. Don't use the
    name of a type or a function as the category, and mention that name in the description instead.
  - Don't use a very wide category, like `treewide`, unless the change affects most of it
  - Combine categories with `+` when the patch genuinely spans multiple areas, for example `foo+bar`
- Use the imperative mood, like `foo: change the way dates work`
- Don't end the subject line with a period
- Use markdown formatting if necessary, for example `Foo::bar` for code

### Body

- Wrap at 72 characters
- Use markdown formatting only as [Structure](#structure) allows

### Example

This commit message follows the order from [Explanation](#explanation): the problem traced to a case the reader can
recognize, who it affects, the fix and why it is right, and the evidence.

```text
cache: keep expired entries while they refresh

The sweeper removed expired entries even while a refresh for them was
running. When the refresh finished, its entry was gone, so the next
lookup missed and went to the backend again. A key that clients read
every second, such as a session token, was fetched twice each time it
expired. This only happened when a refresh took longer than the 500 ms
sweep interval, so only with a slow backend.

The sweeper now skips entries that are refreshing, as eviction already
does for pinned entries. Removing the entry after its refresh finishes
would be simpler, but it would throw away the new response, so the
next lookup would still miss.

This commit also adds a test that expires an entry during a slow
refresh. Without this change, the second lookup reaches the backend.
```

## Pull requests

### Title

Use the same format as the commit subject line. If the pull request has only one commit, use its subject line.

### Describe the change as a whole

When the pull request has many commits, explain the idea that ties them together, rather than describing each commit in
turn. Each commit explains itself in its own message, so the description doesn't list the commits or summarize them one
by one.

### Description

First find the repository's pull request template and fill in each of its sections. Don't remove sections from the
template or add sections that it doesn't have, and follow the repository's rules, for example about linked issues and
changelog entries.

If the pull request adds or changes an interface that other code calls, such as a library API, a CLI or a
configuration option, show a short example of how a user uses it near the top of the description. The example
explains what the change offers faster than prose can, and the explanation that follows can then refer to it.

If the description is longer than a few short paragraphs, split it into sections with markdown headers rather than
writing one long block of text. If there is a template, use its sections, and add lower-level headers inside a long
section where that helps. If there is no template, use sections like "Problem", "Solution" and "Testing". A short
description doesn't need headers.

The description has no line length limit, so don't wrap its lines at 72 characters or at any other length. Use
markdown formatting if necessary.

Link each file, function or other piece of code that the description mentions to its location on GitHub with a
permalink, so that the reviewer can find it easily. Use the name of the code as the link text, for example
`` [`ci.yaml`](https://github.com/metalbear-co/mirrord/blob/9f10a12343d76cf585cd0d1c3205609ff0ad2984/.github/workflows/ci.yaml#L56) ``. <!-- rumdl-disable-line line-length -->
For code that the pull request doesn't change, link to the pull request's base commit, and for code that it adds or
changes, link to its head commit.
