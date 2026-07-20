---
name: writing-pr-descriptions
description: Writes PR descriptions that help reviewers understand a patch by explaining the problem, its cause, and why the change fixes it. Use when creating, revising, or polishing a PR description, including its title and body.
---

# Writing PR Descriptions

The main purpose of a PR description is to provide _context_ to the reviewer. It should explain what problem existed,
why it existed, and then gently introduce how the change fixes it. A good PR description makes the diff easier to review
because the reader knows what to expect before they start reading the code.

Start by reading the diff itself. Infer the user-visible or developer-visible problem first, then write the title and
body around that understanding instead of narrating the edit file by file.

## Title

Keep the title specific enough to orient the reader, but not so detailed that it tries to summarize the whole patch.

### Title Style

- Stay at 72 characters or fewer
- Use the format `Category: Brief description of what's being changed`
  - Use a category that names the relevant library, application, service, utility, or similar unit
  - Combine categories with `+` when the patch genuinely spans multiple areas, for example `Foo+Bar`
- Use the imperative mood, like `Foo: Change the way dates work`

## Body

The body should read like an explanation from one engineer to another - not like release notes and not like a checklist.
Structure it in a way where the sentences/paragraphs flows smoothly and naturally from beginning to end.

Use markdown formatting if necessary (e.g: code blocks, bullet points).

Before drafting the body, answer these questions from all the available context:

1. What's currently wrong?
2. Is this PR fixing that problem directly, or is it groundwork that makes the new final fix possible?

In most cases, the body should move through this shape:

1. Explain the problem or confusing behavior
2. Explain how the change addresses it
3. Explain why this approach is the right one when that context is not obvious from the diff alone

If the patch is straightforward, a compact body is preferred. Don't write long, unnecessary walls of text for something
that can be explained in one or two sentences. Focus on intent and reasoning more than on mechanics that are already
obvious in the diff, and avoid hype, filler, and over-explaining.

### Preparatory PRs

Some PRs do not achieve the final desired behavior by themselves, and instead solve a single, isolated piece of the
puzzle, serving as a building block for the final solution. In that case, lead with the final architectural or behavioral
requirement the system needs to justify the existence of this PR while keeping its description grounded in the state of
the system at its specific point in history, before the follow-up PRs are in place.

### Alternatives

If the patch took multiple iterations to get right, do not narrate that history in the PR body or present the
final solution as an alternative to the previous iterations. The reviewer only sees the final diff, so explain the patch
in its final form as the direct answer to the problem(s).

### Body Style

- Wrap at 72 characters

## Language

Keep the text light, direct, and easy to read. Use plain words over technical buzzwords and explain things as simply as
possible. The reviewer wants to spend their brain energy on the _code_, not the PR description, so don't complicate it.
