---
name: write-a-commit-message
description: Writes commit messages that help reviewers understand a patch by explaining the problem, its cause, and why the change fixes it. Use when creating, revising, or polishing a commit message.
---

# Writing Commit Messages

The main purpose of a commit message is to provide _context_ to the reviewer. It should explain what problem existed,
why it existed, and then gently introduce how the change fixes it. A good commit message makes the diff easier to review
because the reader knows what to expect before they start reading the code.

Start by reading the diff itself. Infer the user-visible or developer-visible problem first, then write the message
around that understanding instead of narrating the edit file by file.

## Subject Line

Keep the subject specific enough to orient the reader, but not so detailed that it tries to summarize the whole patch.

### Subject Line Style

- Stay at 72 characters or fewer
- Use the format `Category: Brief description of what's being changed`
  - Use a category that names the relevant library, application, service, utility, or similar unit
  - Combine categories with `+` when the patch genuinely spans multiple areas, for example `Foo+Bar`
- Use the imperative mood, like `Foo: Change the way dates work`

## Body

Write the body in natural, human prose. It should read like an explanation from one engineer to another, not like
release notes and not like a checklist.

Use markdown formatting if necessary (e.g: code blocks, bullet points).

Before drafting the body, answer these questions from all the available context:

1. What's currently wrong?
2. Is this commit fixing that problem directly, or is it groundwork that makes the new final fix possible?

In most cases, the body should move through this shape:

1. Explain the problem or confusing behavior
2. Explain how the change addresses it
3. Explain why this approach is the right one when that context is not obvious from the diff alone

If the patch is straightforward, a compact body is preferred. Don't write long, unnecessary walls of text for something
that can be explained in one or two sentences. Focus on intent and reasoning more than on mechanics that are already
obvious in the diff, and avoid hype, filler, and over-explaining.

### Preparatory Commits

Some commits do not achieve the final desired behavior by themselves, and instead solve a single, isolated piece of
the puzzle, serving as a building block for the final solution. In that case, lead with the final architectural or
behavioral requirement the system needs to justify the existence of this commit while keeping it's description grounded
in the state of the system at it's specific point in history, before the follow up commits are in place.

### Alternatives

If the patch took multiple iterations to get right, do not narrate that history in the commit message or present the
final solution as an alternative to the previous iterations. The reviewer only sees the final diff, so explain the patch
in its final form as the direct answer to the problem(s).

### Body Style

- Wrap at 72 characters

## Tone And Voice

Commit messages should feel calm, direct, human, and easy to read. They should have a light, chill quality to them, like
one engineer casually but thoughtfully walking another through a change. A little whimsicalness is welcome when it helps
the message feel natural, but it should stay subtle and never get in the way of clarity.

## Readability

Make the message easy to follow on the first read. Prefer plain words, short sentences, and paragraphs that move
naturally from the problem to the fix. Avoid technical buzzwords, abstract framing, and puffed-up language. If a simpler
sentence works, use it.
