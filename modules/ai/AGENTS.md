# Global user guidelines

## Writing

These rules apply to all text that a person or an agent reads, which means replies to my prompts, comments, names in
code, commit messages, pull request titles and descriptions, and skills or other instructions for agents. They are
the most important rules in this file.

Write the way a fluent speaker explains something to a colleague, so that the reader understands each sentence on the
first read. Each section below covers one way that a text can make the reader stop and work out what it means.

### Order

Put each piece of information where the reader needs it.

- Start with the main point, and follow it with the details that support it. This holds at every level. A reply
  opens with the answer or the result, a paragraph with a sentence that states its topic, and a doc comment with what
  the item is or does. A doc comment on an `encoding: Option<String>` field that only says "`None` uses UTF-8." never
  says what the field holds, so write "The encoding of the file. `None` uses UTF-8."
- Explain a term, a name or a piece of context before the first sentence that relies on it.
- Put the subject and the main verb near the start of a sentence, and tell events in the order they happen,
  rather than stacking conditions before the main clause.

### Connections

Show how the ideas relate, so that the reader doesn't have to work it out.

- Link each idea to the one before it with words such as "because", "so" or "the cause was", both between
  sentences and between paragraphs.
- Write facts that follow from each other, such as a problem and its cause, as a paragraph, so that the words
  between the sentences show how they connect. A bulleted list is only for three or more facts of the same kind, after
  a sentence that says what they have in common.
- Give each paragraph one topic, so that all its sentences relate to each other. If two parts of a paragraph could
  have different headings, split it or cut the part that the reader doesn't need.

### Sentences

Give each sentence one idea, together with its reason or result, and split a sentence that holds two.

- Give each clause its own subject and verb. In "The cache is cleared every hour. Or when it's full.", the second
  sentence reads as if it was cut off from the first, so write "The cache is cleared every hour, or when it's full."
  When clauses share a verb, repeat it. Instead of "The header takes the bold font, the body the regular one", write
  "The header takes the bold font, and the body takes the regular font."
- Describe events with verbs and things with nouns. Instead of "during a pending refresh", write "while the entry
  is refreshing". Instead of "the job that failed in position `index`", write "the failed job at `index`".
- Let the grammar say what kind of statement a sentence is. Write guidance with "should", "must" or the
  imperative. Instead of "a caller that keeps the connection open sends a ping every minute", which reads like a
  description of what already happens, write "a caller that keeps the connection open should send a ping every
  minute". Use "would" for something that the text considers but that doesn't happen, such as a rejected alternative,
  and use the present tense only for what does happen.

### Words

Choose each word and name so that the reader knows right away which one thing it means.

- Use the established term, even when it is technical, such as "moves", "owns" or "drops" in Rust, or the project's
  name for one of its concepts. A paraphrase is vaguer or longer than the term, as "holds" is for "owns".
- Say literally and in full what happens where there is no established term. Jargon, an idiom, a metaphor or a
  shorthand leaves the reader to rebuild the meaning. So instead of "the requests in flight", write "the requests that
  are waiting for a response", and instead of "handles the overflow", write "drops the requests that don't fit in the
  queue". A metaphor that is itself the established term, such as "memory leak", is fine.
- Name a function, type or variable after what it returns or holds, including the noun. `expired` could hold
  sessions or tokens, so name it `expired_sessions`.
- Call each thing by the same name every time, and use words with one meaning. "At once" can mean "immediately"
  or "together", so write the one you mean.
- Make each pronoun, and each "which", point to one thing. In "the parser passes the token to the lexer, which drops
  it", the reader can't tell what drops what, so repeat the noun: "the parser passes the token to the lexer, and the
  lexer then drops the token".

## Tool availability

Most projects have a nix development shell, which provides the project's dependencies and build tools. Run commands in
it by prefixing them with `nix develop -c`.

### Missing programs

If you need a program that is neither installed nor in the devshell, run it through `nix shell`:

```sh
nix shell nixpkgs#$package -c $program $args
```

Don't use a different program instead, or write a script that does the same job. For example, if `python3` is missing,
don't rewrite the script in `node` or `perl`. Run `nix shell nixpkgs#python3 -c python3 script.py` instead.

The package name can differ from the program name. For example, `dig` comes from the `dnsutils` package.

To use several packages in a pipeline, list all of them and run the pipeline through `sh -c`:

```sh
nix shell nixpkgs#curl nixpkgs#jq -c sh -c 'curl -s https://example.com/data.json | jq .foo'
```

## Build cache

This machine has `kache`, a build cache like `sccache` that caches the output of the Rust, C, C++ and CUDA compilers.
All workspaces on the machine share the cache. So when you or a subagent build a project in another workspace, for
example a temporary jj workspace to test something, the build reuses the cached results rather than building the whole
project from scratch.

Because `kache` already shares the build results, don't set up another way to share or cache them, and don't tell
subagents to do it. In particular, don't:

- Point the build in one workspace at the build directory of another, for example with `CARGO_TARGET_DIR` for Cargo or
  `-B` for CMake. Builds in the two workspaces would then block or overwrite each other.
- Add a compiler wrapper such as `sccache` or `ccache`, for example with `RUSTC_WRAPPER` or
  `CMAKE_<LANG>_COMPILER_LAUNCHER`. It would replace `kache`, or cache the same work a second time.

## Version control

Always use `jj` instead of `git` for version control. Repositories are created with jujutsu and colocated with git
metadata, so git commands work too, but when the two disagree, jj's view of the repository is the correct one.

Add `--git` when you look at diffs, as in `jj diff --git`, so that jj prints a standard diff rather than using a diff
viewer that the user may have configured.

## Functions

Don't extract simple, self-contained logic into a small function that only one place calls. Most code is simple, and
such a helper only adds indirection, which makes the code harder to read, so write the logic at the call site instead.

Extract a function when it hides details that would distract from the flow of the code that calls it, or when more
than one place calls it.

## Tests

A test should catch a regression, which is a change that breaks a promise that an interface makes to its callers.
"Interface" has a broad meaning here. It is the part of some code that its callers use and depend on, such as what
they call, what they pass in, and what they get back or can observe, rather than a language feature like a Rust trait.
The callers can be a user, another program or other parts of the same program.

Each test costs time to run, to read and to update along with the code, so a test that can't catch a regression is
worse than having no test at all.

### What to test

Write a test for a promise whose regression would be costly. For example, a backup tool that shows the wrong progress
causes its users far less trouble than one that restores the wrong files. This holds in two cases:

The first case is an invariant, meaning a promise that is part of the core of the program, such as a backup tool
restoring exactly the files that it backed up. The core is what makes the program worth using, so test it thoroughly.
The other parts of the program, such as its progress output or the wording of its messages, can and should change over
time. A test of those parts would break each time they change on purpose, and it would catch nothing that matters, so
don't write one.

The second case is a bug that you fix. The bug has already cost the users and the time to fix it, so add a regression
test in the same change as the fix, so that the bug doesn't come back. The test should check the cause of the bug
rather than its symptom, and the two are often in different parts of the program. For example, if the progress of a
backup goes past 100% because the tool visits hard-linked files twice, the test should check that the tool visits each
file once, and it doesn't involve the progress output at all. In that case, the symptom showed up at an edge of the
program, but the test checks its core.

Don't test a promise of a dependency (a library, a framework, the standard library, the language, the operating
system, ...). Using a dependency means trusting it to keep its promises, and a well-known dependency has earned that
trust through its users and its own tests. This includes code that only declares what a dependency should do. For
example, the attribute `#[arg(env = "FOO")]` on a field of a `clap` argument struct tells `clap` to read the field from
the environment variable `FOO` when the command line doesn't set it. A test that sets `FOO` and checks that the field
holds its value only checks `clap`, so don't write one. If the option is part of the core of the program, test the
promise that the project makes with it, such as what the command does when `FOO` is set.

### Which interface to test

Test the smallest interface that the change affects, and use it only the way its callers do. Decide what the interface
is from what the code does and who relies on it, not from its visibility (`pub`).

Check the promise in terms that a caller would understand. Instead of an internal detail, such as
"`is_identifier_char` returns `true` for `é`", check "the parser accepts identifiers with non-ASCII letters".

### How a test should behave

A test should give the right result and cost little to run, so it should:

- Fail when the code breaks the promise, for example when you revert the change, and pass when you change the
  internals but the code still keeps the promise.
- Be able to run in parallel with other tests.
- Be fast, because tests are part of the development loop and you run them after every change.

### Design

The design of the code decides how easy it is to write good tests for it. If it is hard to give an interface what it
needs or to control it's side effects, people end up testing small internal helpers instead, or not writing tests at
all. So design interfaces that:

- Declare all the state they need, and only that state, so that a test can pass it in. Don't read global state
  (statics, singletons, environment variables) deep in the code, and don't ask for a large object ("god object") when
  the code only uses a small part of it.
- Use the real external services, such as the file system, a database, another program or a third-party API, rather
  than mocks. A test that uses a mock checks the mock and not the program, and if a test fails because a service is
  slow or unavailable, the program has the same problem.
- Give the same output for the same input. Values that change on every run, such as the clock or random values, are
  inputs too, so the caller should pass them in. The tests then work like a proof by induction: if the output depends
  only on the input, and the code is correct for the usual cases and for the edge cases, then it is also correct for
  the other inputs of the same kind.

When tests use real services, the side effects of one test must not affect another. For example, use a temporary
directory per test, fresh, isolated database instances, or different names for the things each test creates in a
third-party service. If the project's development environment can't provide a service, change the environment so that
it can, or tell the user.

If you can't write such a test, change the design, not the test.

These rules are mainly for new code. For old code, tell the user about the problem, and only change its design if the
user asks.

### Location

If the language allows it, keep the tests in their own module or file rather than in the file of the code they test.
In Rust, for example, the tests for `src/foo.rs` should go in `src/foo/tests.rs`, and `src/foo.rs` should declare the
module with `#[cfg(test)] mod tests;`.
