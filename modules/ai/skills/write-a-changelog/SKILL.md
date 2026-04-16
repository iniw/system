---
name: write-a-changelog
description: Writes short, user-facing changelog entries that summarize the high-level idea behind a change without implementation detail. Use when creating, revising, or polishing release notes, changelog entries, customer-facing summaries, or "what changed" updates.
---

# Writing Changelog Entries

Summarize the user-visible change, avoid talking about the implementation unless it's relevant. Focus on what changed
and why it matters to the user.

## Entry Style

- Keep entries short and easy to scan
- Lead with the user-visible change, not the implementation
- Use plain language over internal terms when possible
- Mention limitations, scope, or caveats only when they matter to users

Before drafting the entry, answer these questions from the available context:

1. What changed for the user?
2. Why does that matter?
3. What details are purely implementation and should be omitted?

## Tone

Write in calm, direct, customer-facing language that stays light, simple, and easy to read.
Prefer plain words over technical buzzwords or abstract phrasing.

## Output Shape

Default to one or two sentences unless the user asks for a longer entry.

- First sentence: what was changed or added
- Optional second sentence: why it matters, what it allows you to do, potential caveats...
