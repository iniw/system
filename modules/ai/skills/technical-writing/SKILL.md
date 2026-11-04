---
name: technical-writing
description: Rules for any text that a person or an agent reads, such as replies, code comments, doc comments, names in code, documentation, log and error messages, commit messages, pull request text, review comments and skills. Use each time you write or change such text, and when you review it.
---

# Technical writing

These rules apply to all text that a person or an agent reads: replies to the user, comments, doc comments, names in
code, documentation, log and error messages, commit messages, pull request titles and descriptions, review comments,
and skills or other instructions for agents.

Write the way a fluent speaker explains something to a colleague, so that the reader understands each sentence on the
first read. Each section below covers one way that a text can make the reader stop and work out what it means.

## Order

Put each piece of information where the reader needs it.

- Start with the main point, and follow it with the details that support it. This holds at every level. A reply
  opens with the answer or the result, a paragraph opens with a sentence that states its topic, and a doc comment opens
  with what the item is or does. A doc comment on an `encoding: Option<String>` field that only says "`None` uses
  UTF-8." never says what the field holds, so write "The encoding of the file. `None` uses UTF-8."
- Explain a term, a name or a piece of context before the first sentence that relies on it.
- Put the subject and the main verb near the start of a sentence, and tell events in the order they happen, rather
  than stacking conditions before the main clause.

## Connections

Show how the ideas relate, so that the reader doesn't have to work it out.

- Link each idea to the one before it with words such as "because", "so" or "the cause was", both between sentences
  and between paragraphs.
- Write facts that follow from each other, such as a problem and its cause, as a paragraph, so that the words between
  the sentences show how they connect. Use a bulleted list only for three or more facts of the same kind, after a
  sentence that says what they have in common.
- Give each paragraph one topic, so that all its sentences relate to each other. If two parts of a paragraph could
  have different headings, split it or cut the part that the reader doesn't need.

## Sentences

Give each sentence one idea, together with its reason or result, and split a sentence that holds two.

- Give each clause its own subject and verb. In "The cache is cleared every hour. Or when it's full.", the second
  sentence reads as if it was cut off from the first, so write "The cache is cleared every hour, or when it's full."
  When clauses share a verb, repeat it. Instead of "The header takes the bold font, the body the regular one", write
  "The header takes the bold font, and the body takes the regular font."
- Describe events with verbs and things with nouns. Instead of "during a pending refresh", write "while the entry is
  refreshing". Instead of "the job that failed in position `index`", write "the failed job at `index`".
- Let the grammar say what kind of statement a sentence is. Write guidance with "should", "must" or the imperative.
  Instead of "a caller that keeps the connection open sends a ping every minute", which reads like a description of
  what already happens, write "a caller that keeps the connection open should send a ping every minute". Use "would"
  for something that the text considers but that doesn't happen, such as a rejected alternative, and use the present
  tense only for what does happen.

## Words

Choose each word and name so that the reader knows right away which one thing it means.

- Use the established term, even when it is technical, such as "moves", "owns" or "drops" in Rust, or the project's
  name for one of its concepts. A paraphrase is vaguer or longer than the term, as "holds" is for "owns".
- Say literally and in full what happens where there is no established term. Jargon, an idiom, a metaphor or a
  shorthand leaves the reader to rebuild the meaning. So instead of "the requests in flight", write "the requests that
  are waiting for a response", and instead of "handles the overflow", write "drops the requests that don't fit in the
  queue". A metaphor that is itself the established term, such as "memory leak", is fine.
- Name a function, type or variable after what it returns or holds, including the noun. `expired` could hold sessions
  or tokens, so name it `expired_sessions`.
- Call each thing by the same name every time, and use words with one meaning. "At once" can mean "immediately" or
  "together", so write the one you mean.
- Make each pronoun, and each "which", point to one thing. In "the parser passes the token to the lexer, which drops
  it", the reader can't tell what drops what, so repeat the noun: "the parser passes the token to the lexer, and the
  lexer then drops the token".

## Comments and documentation

Comments and documentation last as long as the code, so they must make sense to a reader who never saw the change that
added them.

- Explain why the code exists or why it works the way it does, rather than repeating what the code already says.
  Non-obvious code must have such a comment.
- Give the reason itself, not who asked for it. "The reviewer asked for a retry here" tells a later reader nothing, so
  write "The API returns 503 during deploys, so the client retries once."
- Don't narrate the change, as in "now uses a channel instead of a mutex". The reader of the code never saw the mutex.
- When a change makes a comment or a document wrong, update the parts that the change affects, and keep the general
  explanation that still holds. Don't replace a document with one that only describes the change.
