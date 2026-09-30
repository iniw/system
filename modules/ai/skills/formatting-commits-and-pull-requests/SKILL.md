---
name: formatting-commits-and-pull-requests
description: Format rules for commit messages and for pull request titles and descriptions, for example the subject line format, line lengths and pull request templates. Use each time you write or change a commit message (for example with `jj describe` or `jj commit`) or a pull request title or description, or when you check commit messages before a pull request.
---

# Formatting Commits and Pull Requests

## Commit Messages

### Subject Line

- Stay at 72 characters or fewer
- Use the format `Category: Brief description of what's being changed`
  - Use a category that names the relevant library, application, service, utility, or similar unit
  - Combine categories with `+` when the patch genuinely spans multiple areas, for example `Foo+Bar`
- Use the imperative mood, like `Foo: Change the way dates work`
- Use markdown formatting if necessary, for example `Foo::bar` for code
- Choose lowercase (`foo: change the way dates work`) or sentence case (`Foo: Change the way dates work`) from the
  user's previous commits in the repository. If the user has no commits there, use the most common case in the
  repository

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
have. If there is no template, use the same structure as the body of a commit message. Follow the rules of the
repository, for example about linked issues and changelog entries.

The description has no line length limit. Do not wrap its lines at 72 characters or at any other length. Use markdown
formatting if necessary.

#### Testing

Explain how you made sure that the change is correct. If the template has a section about testing, put it there.
Otherwise, put it after the explanation of the change.

Describe the overall _process_ that you used to validate the change, and _why_ that process shows that the change is
correct.

Do not mention obvious, mechanical checks, for example that the code compiles, that the linters pass or that the
existing tests pass. The reader expects that they do.
