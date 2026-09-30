---
name: writing-for-reviewers
description: Explains what to write in text that other people read about a code change, for example commit messages, pull request titles and descriptions, replies to review comments, and comments on issues that summarize the change. Use each time you write or change any of these.
---

# Writing for Reviewers

The main purpose of this text is to give _context_ to the reader. The reader is usually a reviewer, or a person who
finds the change later. Good text makes the change easier to understand, because the reader knows what to expect before
they read the code.

Start by reading the change itself. Find the user-visible or developer-visible problem first, then write the text around
that understanding. Do not narrate the edit file by file.

## Explanation

Before you write, answer these questions from all the available context:

1. What's currently wrong?
2. Does the change fix that problem directly, or is it groundwork that makes the final fix possible?

In most cases, the explanation should move through this shape:

1. Explain the problem or confusing behavior
2. Explain how the change addresses it
3. Explain why this approach is the right one, when that context is not obvious from the change alone

Change the shape to fit the type of text. For example, a reply to a review comment answers the comment first: what you
changed because of it, or why you did not change anything.

If the change is straightforward, a compact explanation is preferred. Don't write long, unnecessary walls of text for
something that can be explained in one or two sentences. Focus on intent and reasoning more than on mechanics that are
already obvious in the code.

## Structure

The text must read well, and it must also have enough structure to guide the reader. Use the features of markdown, like
lists, tables and code blocks, to give the text structure where it helps the reader. Do not use them to narrate the edit
file by file.

With this structure, the text must still read as one explanation from beginning to end. Each part must follow from what
comes before it. Connect each structured part to the text around it, for example with a sentence before a list that
tells the reader what the list contains and why it is there.

## Titles

A title, like a commit subject or a pull request title, should be specific enough to orient the reader, but not so
detailed that it tries to summarize the whole change.

## Describe the Change as a Whole

When the text is about a change with many parts, for example a pull request with many commits, explain the full change.
Do not describe each part one by one.

## Partial Changes

Some changes do not achieve the final desired behavior by themselves. Instead, they solve a single, isolated piece of
the puzzle, and are a building block for the final solution. In that case, start with the final architectural or
behavioral requirement that makes this change necessary. Keep the description grounded in the state of the system at
that point in history, before the follow-up changes are in place.

## Voice

The user is the author of the text. Write it from the point of view of the user.

- For actions that the author took during the work, use "I", "me" and "my". For example, how the change was tested:
  "I tested this with 100 clients."
- For the goals and decisions of the project, use "we", "us" and "our". Here, "we" is the team of the project. For
  example, the motivation for the change: "We are migrating from A to B, so this moves the parser to B."
- Never use "we" for you and the user together. The reader does not know about you, so the reader thinks that "we" is
  the team of the project
- Do not mention yourself, for example as "the agent", "the AI" or "Claude"

Do not write sentences like these:

- "We tested this with 100 clients."
- "After our discussion, the parser now returns an error."
- "Claude found this bug during testing."

It is also fine to write without a person, for example: "This change keeps the cache per request."

## Private Context

Write only about things that the reader can see or find. The reader has the change, the repository and the public
history of the project. The reader does not have your session, your machine or your notes.

Do not mention things that exist only in your setup, and do not use them as a reason for a decision. For example:

- Local clusters and environments, like a k3s or kind cluster, or a local database
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

## Design History

How the design changed during the work is often good context. For example, an approach that looks simpler but does
not work, or a problem that testing found and that caused a change to the design. Mention an earlier version when it
helps the reader understand why the final design is correct.

The reader did not see the earlier version, so describe it fully. Do not write "Instead of the mutex from the first
version, this uses a channel." Write "A mutex is simpler, but it blocks all readers while the cache refreshes, so this
uses a channel."

Do not narrate each step of the history, and do not mention earlier versions that do not help the reader understand the
final change.
