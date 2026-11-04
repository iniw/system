---
name: writing-commits-and-pull-requests
description: What to write in commit messages and in pull request titles and descriptions, and how to format them, for example the subject line, line lengths and pull request templates. Use each time you write or change a commit message (for example with `git commit`, `jj describe` or `jj commit`) or a pull request title or description, or when you check commit messages before a pull request.
---

# Writing commits and pull requests

This skill describes what to write in commit messages and pull requests, and how to format them. Follow the
[`technical-writing`](../technical-writing/SKILL.md) skill for the prose.

## Content

These rules apply to commit messages and to pull request descriptions.

### Keep it short

Short text is easier to read and to review. Agents usually write too much, so write less than you think you need.

- Write only what the reader needs to understand and review the change. If the reader loses no information when you
  remove a sentence, remove it.
- Don't repeat what the title, the diff or another part of the text already says.
- Don't list every file, function or test that changes.
- If the subject line already tells the reader everything they need, skip the body. For example,
  `` cli: add a `--version` flag `` needs no body.

The length of the body should depend on how much the reader can't work out from the diff, not on the size of the
diff. A change whose reason is a single fact should get a single sentence, such as `deps: drop the patch for
openssl-sys` with the body "The fix was released upstream in 0.9.104". A fix for a subtle bug in a few lines can need
several paragraphs.

### Explanation

Start by reading the change and finding the problem that a user or a developer can see. Then write about that problem,
rather than describing the edit one file at a time.

Before you write, use all the context you have to answer these questions:

1. What is wrong now?
2. Does the change fix that problem directly, or does it only prepare for a later change that fixes it?

The explanation should usually follow this order:

1. The problem and its cause, in one paragraph. Use the past tense for the old behavior ("The cache kept…"). Trace
   the cause from the code to the symptom, and join each step to the one before it with words such as "so", "then" or
   "which". End with one concrete case that a reader can try, such as an input and its wrong output, or a command that
   failed. A symptom without its cause isn't enough.
2. Who the problem affects. If it only happens under some conditions, name them and say who isn't affected, so that
   the reader knows how much it matters. If bug reports, logs or crash dumps show the problem, say how they match the
   cause, because the match shows that the cause is real and not only plausible.
3. The fix. Use the present tense for the new behavior ("The cache now removes…"), not the imperative mood
   ("Remove…").
4. Why this is the right approach. Only write this if the change doesn't show why. The strongest reasons are:
   - Code in the project that already does the same thing, for example "as eviction already does for pinned entries".
     Name that code, so that the reader can compare the two.
   - A simpler alternative that the reader would think of, and the fact that rules it out.
   - A dependency's documented behavior that forces the design. Name the document and say what it guarantees.
5. What the change costs, if anything, such as a slower code path, more memory, a new way to fail, or a feature that
   stays off by default because of its cost.
6. What existing users and clients notice, if anything, such as a changed CLI flag, configuration option, format of
   stored data, wire format or public API. Say how old and new versions behave together, for example an old client with
   a new server, and what a user must do to migrate.

At the end, give one sentence to each part of the diff that the reader would otherwise question, such as a changed
test, a moved helper or an unrelated fix. For example: "The expiry test now uses a fake backend that never
responds, so that the refresh is still pending when the entry expires."

If the reader might expect the change to do something that it doesn't do, say so. For example: "This adds the option
to the CLI, but not to the configuration file."

If the change only moves or renames code, write "No behavior change.", so that the reader knows not to look for one.

### References

When another commit or an issue is part of the reason for the change, name it. Use the hash of a commit that is
already public, because the reader can't look up a commit or a jj change ID that only exists on your machine. These
forms are common:

- "Regressed in 7e01ddbe41d, which made every lookup…", when an earlier commit caused the problem.
- "This reverts most of 1b46a52, which was a workaround for…".
- "Found by fuzzing the parser." or "Reported in #123.", to tell the reader how the problem was found.

When you link to something, say what the link shows, rather than leaving a bare link for the reader to open and
interpret.

### Structure

The text must be easy to read and have enough structure to guide the reader. It must still read as one explanation
from start to finish, in which each part follows from the one before it.

A commit body is prose. Use markdown in it only for content that prose can't show well:

- A table for numbers, such as measurements before and after the change.
- A list for items of the same kind, such as the options that a change removes.
- A code block for a command or its output.

A pull request description can use more structure, such as headings and examples (see [Description](#description)). In
both, connect each list or table to the text around it, for example with a sentence before a list that says what the
list holds and why it is there.

### Changes that are part of a larger one

Some changes don't deliver the final behavior on their own, because a later change builds on them. Say which part of
the larger effort the change is and what remains, but keep it short. A preparatory commit usually only needs one closing
sentence, such as "A later commit uses this to retry failed uploads." Describe what the system does once this change is
applied, not what it will do after the later changes.

### Context that the reader does not have

The reader has the change, the repository and the public history of the project. They don't have your session, your
machine, your notes or the earlier versions of the change, so follow the rules below whenever you write about one of
these.

#### Evidence

Evidence is a check that you ran to show that the change is correct, such as a test, a benchmark or a deployment to a
cluster, together with its result. Write about it, but describe the type of environment rather than its name or
location. Say what the check does, so that the reader understands the result.

- Don't write "Tested in our k3s cluster." Write "Tested in a local k3s cluster with the operator installed: …"
- Don't write "The benchmark in the scratch directory shows a 2x speedup." Write "A local benchmark that sends 10,000
  requests to the cache shows a 2x speedup."

Give the result as numbers from before and after the change, for example "the request now takes 3 ms instead of 70 ms".
When the evidence is a new test, say that the test fails without the change, because the failure shows that the test
catches the problem. For example: "This commit also adds a test that…. Without this change, …"

Report the costs and the checks that found no difference as well as the improvements, because the reader needs all
of them to judge the trade-off. For example: "Creating a pool entry is twice as slow, but a benchmark that streams
500 MB through the parser shows no difference outside of noise."

Describe the overall _process_ you used to check the change, and _why_ that process shows that the change is correct.
If the existing tests don't run the changed code, say why, and describe what you checked instead. Don't mention
obvious, mechanical checks, such as the code compiling, the linters passing or the existing tests passing, because the
reader expects them.

In a pull request description, also include what the reader needs to repeat the check:

- The code of any test or benchmark.
- The commands you ran.
- The configuration of any deployment.
- The part of the output that shows the result.

Wrap these in a `<details>` block so that the description stays easy to read. A commit message can't hold a `<details>`
block, so it should only have the short description of the check.

#### Reasons from your session

Don't refer to plans, notes, to-do lists or discussions with the user. The reader can't read them, so they don't count
as a reason for a decision. Write the reason itself instead.

Don't write "As the plan says, the cache stays per request." Write "The cache stays per request, because …"

#### Earlier versions

How the design changed during the work is often useful context, such as an approach that looks simpler but doesn't
work, or a problem that testing found and that changed the design. Write about an earlier version when it helps the
reader understand why the final design is the way it is, but don't describe every step of the history.

The reader never saw the earlier version, so describe it fully. Don't write "Instead of the mutex from the first
version, this uses a channel." Write "A mutex is simpler, but it blocks all readers while the cache refreshes, so this
uses a channel."

## Commit messages

### Subject line

The subject line must tell the reader which part of the code changes and how. It shouldn't try to summarize the whole
change.

- Make one specific claim about the new behavior. Don't use vague verbs that hide what changes, such as "fix",
  "refactor", "improve" or "update". Instead of `cache: fix response storage`, write
  `cache: only store responses whose transfer succeeded`.
- Stay at 72 characters or fewer.
- Use the format `category: brief description of what's being changed`.
  - Use a category that names the library, application, service, utility or similar unit that changes. Don't use the
    name of a type or a function as the category. Put that name in the description instead.
  - Don't use a very wide category, such as `treewide`, unless the change affects most of the code that the category
    covers.
  - Combine categories with `+` when the change genuinely spans several areas, for example `foo+bar`.
- Use the imperative mood, for example `foo: change the way dates work`.
- Don't end the subject line with a period.
- Use markdown formatting if necessary, for example `Foo::bar` for code.

If the repository already uses a different convention for subject lines, such as Conventional Commits, follow the
repository instead.

### Body

- Wrap at 72 characters.
- Use markdown formatting only as [Structure](#structure) allows.

### Example

This commit message follows the order from [Explanation](#explanation): the problem traced to a case that the reader
can recognize, who it affects, the fix and why it is right, and the evidence.

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

When the pull request has many commits, explain the idea that connects them, rather than describing each commit in turn.
Each commit message already explains its commit, so the description shouldn't list the commits or summarize them one
by one.

### Template

Find the repository's pull request template before you write the description, because `gh pr create --body-file`
doesn't fill it in for you. The template is a file named `pull_request_template.md` (with any capitalization) in
`.github/`, in the root of the repository or in `docs/`, or a file in a `PULL_REQUEST_TEMPLATE/` directory in one of
those places. If there are several templates, ask the user which one to use. If the repository has none, look in the
same places in the organization's `.github` repository, because GitHub falls back to that one.

Fill in each section of the template, and follow the repository's rules, for example about linked issues and changelog
entries. Don't remove sections from the template or add sections that it doesn't have, with these exceptions:

- Keep a checklist with the original wording of each item. Tick an item only when it is true for this pull request,
  and leave the others unticked rather than rewording them to fit. Remove an item only if the template says that you
  may.
- Remove HTML comments and sections that only instruct the author, such as a list of the CI labels that the author
  can add.

### Description

If the pull request adds or changes an interface that other code calls, such as a library API, a CLI or a
configuration option, show a short example of how a user uses it near the top of the description. The example shows
what the change offers faster than prose can, and the rest of the description can then refer to the example.

Link the issue that the pull request resolves, such as the Linear issue. If the same work needs pull requests in other
repositories, for example a change to both mirrord and the operator, link those pull requests and say which one must
be merged or released first.

If the description is longer than a few short paragraphs, split it into sections with markdown headings. If there is
a template, use its sections, and add lower-level headings inside a long section where that helps. If there is no
template, use the sections "Problem", "Solution" and "Testing". A short description doesn't need headings.

In the testing section, start with one short line for each kind of check that you ran, with its result, such as "The new
end-to-end test passes in a local kind cluster." Put the details from [Evidence](#evidence) after these lines, in
`<details>` blocks. Mention a check that failed or that you couldn't run only if it should block the merge.

The description has no line length limit, so don't wrap its lines at 72 characters or at any other length. Use
markdown formatting if necessary.

Link each file, function or other piece of code that the description mentions to its location on GitHub with a
permalink, so that the reviewer can find the code easily. For code that the pull request doesn't change, link to the
base commit of the pull request. For code that the pull request adds or changes, link to the head commit. Use the name
of the code as the link text, for example:

```markdown
[`ci.yaml`](https://github.com/metalbear-co/mirrord/blob/9f10a12343d76cf585cd0d1c3205609ff0ad2984/.github/workflows/ci.yaml#L56)
```
