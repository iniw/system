---
name: format-commit-and-pull-request
description: What to write in commit messages and in pull request titles and descriptions, and their format rules, for example the subject line format, line lengths and pull request templates. Use each time you write or change a commit message (for example with `jj describe` or `jj commit`) or a pull request title or description, or when you check commit messages before a pull request.
---

# Formatting Commits and Pull Requests

This skill tells what to write in commit messages and pull requests, and how to format them.

## Content

These rules are for commit messages and for pull request descriptions.

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

### Design History

How the design changed during the work is often good context. For example, an approach that looks simpler but does not
work, or a problem that testing found and that caused a change to the design. Write about an earlier version when it
helps the reader understand why the final design is correct.

The reader did not see the earlier version, so describe it fully. Do not write "Instead of the mutex from the first
version, this uses a channel." Write "A mutex is simpler, but it blocks all readers while the cache refreshes, so this
uses a channel."

Do not describe each step of the history, and do not write about earlier versions that do not help the reader
understand the final change.

### Private Context

Write only about things that the reader can see or find. The reader has the change, the repository and the public
history of the project. The reader does not have your session, your machine or your notes.

Do not write about things that exist only in your setup, and do not use them as a reason for a decision. For example:

- Local clusters and environments, for example a k3s or kind cluster, or a local database
- Plan files, notes and to-do lists
- Temporary files, scratch data and the output of commands that you ran
- Discussions with the user that the reader did not see

Do not write sentences like these:

- "Tested in our k3s cluster."
- "As the plan says, the cache stays per request."
- "The benchmark in the scratch directory shows a 2x speedup."

If one of these things is the reason for a decision, write the reason itself: explain why the approach is correct. If a
test result is important, describe the test so that the reader can do it again: what you ran, and on what type of
environment. Do not say where you ran it.

If the reader needs the code of a test or its output, put them in the text. Do not refer to a file or an output that
only you have.

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

First find the pull request template of the repository. Look in these locations:

- `.github/pull_request_template.md`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/PULL_REQUEST_TEMPLATE/`
- `docs/` and the repository root, with the same file names

Fill in each section of the template. Do not remove sections of the template, and do not add sections that it does not
have. Follow the rules of the repository, for example about linked issues and changelog entries.

If the description is longer than a few short paragraphs, split it into sections with markdown headers. Do not write one
long, continuous block of text. If there is a template, use its sections, and add lower-level headers inside a long
section if it helps. If there is no template, use sections like "Problem", "Solution" and "Testing". A short
description does not need headers.

The description has no line length limit. Do not wrap its lines at 72 characters or at any other length. Use markdown
formatting if necessary.

#### Testing

Explain how you made sure that the change is correct. If the template has a section about testing, put it there. If
there is no template, put it in its own section, or in its own paragraph if the description has no headers. If the
template has no section about testing, put it in the section that explains the change.

Describe the overall _process_ that you used to validate the change, and _why_ that process shows that the change is
correct.

Do not mention obvious, mechanical checks, for example that the code compiles, that the linters pass or that the
existing tests pass. The reader expects that they do.
