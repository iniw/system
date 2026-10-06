---
name: format-commit-and-pull-request
description: What to write in commit messages and in pull request titles and descriptions, and their format rules, for example the subject line format, line lengths and pull request templates. Use each time you write or change a commit message (for example with `jj describe` or `jj commit`) or a pull request title or description, or when you check commit messages before a pull request.
---

# Formatting Commits and Pull Requests

This skill tells what to write in commit messages and pull requests, and how to format them.

## Content

These rules are for commit messages and for pull request descriptions.

### Keep It Short

Short text is easier to read and to review. Agents usually write too much, so write less than you think is necessary.

- Write only what the reader needs to understand and review the change. If the reader loses no information when you
  remove a sentence, remove it.
- Do not repeat what the title, the diff or a different part of the text already tells.
- Do not list each file, function or test that changes.
- A small change needs only a few sentences.

When you finish, read the text again. Remove each sentence, list item and word that the reader does not need.

### Explanation

First, read the change. Find the problem that a user or a developer can see. Then write the text about that problem. Do
not describe the edit one file at a time.

Before you write, use all the context that you have to answer these questions:

1. What is wrong now?
2. Does the change fix that problem directly? Or does it only prepare for a later change that fixes it?

Usually, the explanation has this order:

1. The problem, or the behavior that is confusing.
2. How the change fixes it.
3. Why this is the correct approach. Write this only if the change does not make it clear.

### Structure

The text must be easy to read, and it must have sufficient structure to guide the reader. Where it helps the reader, use
markdown: lists, tables and code blocks. Do not use them to describe the edit one file at a time.

The text must still be one explanation from the start to the end. Each part must follow from the part before it.
Connect each list or table to the text around it. For example, before a list, write a sentence that tells what the list
contains and why it is there.

### Describe the Change as a Whole

When the change has many parts, for example a pull request with many commits, explain the full change. Do not describe
each part one by one.

### Partial Changes

Some changes do not give the final behavior alone. They solve one part of the problem, and a later change uses them to
complete the solution. For these changes, start with the final requirement (for the design or for the behavior) that
makes this change necessary. Describe the system as it is when this change is applied, before the later changes.

### Context That the Reader Does Not Have

The reader has the change, the repository and the public history of the project. The reader does not have your
session, your machine, your notes or the earlier versions of the change. When you write about one of these things,
use the rules below.

#### Evidence

Evidence is what you ran and what you saw that shows that the change is correct, for example a test, a benchmark or a
deployment to a cluster. Write about it, but give the type of environment and not its name or location. Tell what the
check does, so that the reader understands the result.

- Do not write "Tested in our k3s cluster." Write "Tested in a local k3s cluster with the operator installed: …"
- Do not write "The benchmark in the scratch directory shows a 2x speedup." Write "A local benchmark that sends 10,000
  requests to the cache shows a 2x speedup."

Describe the overall _process_ that you used to check the change, and _why_ that process shows that the change is
correct. Do not mention obvious, mechanical checks, for example that the code compiles, that the linters pass or that
the existing tests pass. The reader expects that they do.

In a pull request description, also give the code and the settings that you used, so that the reader can do the check
again. For example: the code of a test or a benchmark, the commands that you ran, the configuration of a deployment and
the part of the output that shows the result. Put them in a `<details>` block, so that the description stays easy to
read. A commit message cannot have a `<details>` block, so give only the short description of the check there.

#### Reasons From Your Session

Do not refer to plans, notes, to-do lists or discussions with the user. The reader cannot read them, so they are not a
reason for a decision. Write the reason itself.

Do not write "As the plan says, the cache stays per request." Write "The cache stays per request, because …"

#### Earlier Versions

How the design changed during the work is often good context. For example, an approach that looks simpler but does not
work, or a problem that testing found and that caused a change to the design. Write about an earlier version when it
helps the reader understand why the final design is the way it is, but do not describe each step of the history.

The reader did not see the earlier version, so describe it fully. Do not write "Instead of the mutex from the first
version, this uses a channel." Write "A mutex is simpler, but it blocks all readers while the cache refreshes, so this
uses a channel."

## Commit Messages

### Subject Line

The subject line must tell the reader which part of the code changes and how. It must not try to summarize all of the
change.

- Stay at 72 characters or fewer
- Use the format `category: brief description of what's being changed`
  - Use a category that names the relevant library, application, service, utility, or similar unit
  - Combine categories with `+` when the patch genuinely spans multiple areas, for example `foo+bar`
- Use the imperative mood, like `foo: change the way dates work`
- Use markdown formatting if necessary, for example `Foo::bar` for code

### Body

- Wrap at 72 characters
- Use markdown formatting if necessary (e.g: code blocks, bullet points)

## Pull Requests

### Title

Use the same format as the commit subject line. If the pull request has only one commit, use its subject line.

### Description

First find the pull request template of the repository and fill in each section. Do not remove sections of the template,
and do not add sections that it does not have. Follow the rules of the repository, for example about linked issues and
changelog entries.

If the description is longer than a few short paragraphs, split it into sections with markdown headers. Do not write one
long, continuous block of text. If there is a template, use its sections, and add lower-level headers inside a long
section if it helps. If there is no template, use sections like "Problem", "Solution" and "Testing". A short
description does not need headers.

The description has no line length limit. Do not wrap its lines at 72 characters or at any other length. Use markdown
formatting if necessary.

Link each file, function or other code that the description mentions to its location on GitHub with a permalink, so
that the reviewer can read it easily. Use the name of the code as the text of the link, for example
`` [`ci.yaml`](https://github.com/metalbear-co/mirrord/blob/9f10a12343d76cf585cd0d1c3205609ff0ad2984/.github/workflows/ci.yaml#L56) ``. <!-- rumdl-disable-line line-length -->
For code that the pull request does not change, use the base commit of the pull request. For code that the pull request
adds or changes, use its head commit.
