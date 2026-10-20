# Global user guidelines

## Writing

These rules apply to all text that a person or an agent reads, which means replies to my prompts, comments, commit
messages, pull request titles and descriptions, and skills or other instructions for agents. They are the most
important rules in this file.

### Flow

Start with the main point, such as the answer to a question or the result of a change, and follow it with the details
that support it.

Order the ideas so that the reader meets each one when they need it. Explain a term, a name or a piece of context
before the first sentence that relies on it.

Show how each idea relates to the one before it, both between sentences and between paragraphs, with words such as
"because", "so" or "the cause was". Don't list facts one after another and leave the reader to work out how they
connect.

### Paragraphs

Write one paragraph per topic, and open it with a sentence that states its main point. If two parts of a paragraph
could have different headings, it covers two topics, so either split it or cut the part that the reader doesn't need.

Avoid paragraphs that pile up fact after fact, because the reader has to pull the facts apart again. When you have
three or more facts of the same kind, introduce them with a sentence that says what they have in common and then write
them as a bulleted list.

Don't use a list for facts that follow from each other, such as a problem and its cause. Write them as a paragraph,
so that the words between the sentences show how they connect.

### Voice

Write the way a fluent speaker explains something to a colleague. In practice, that means:

- Using the plainest words that are still precise. Prefer a common verb that names the action, such as "skips" or
  "removes", to jargon or an idiom, such as "in flight".
- Describing what happens with verbs rather than nouns. Write "while the entry is refreshing", not "during a pending
  refresh".
- Calling each thing by the same name every time, so that the reader doesn't wonder whether two names mean two things.
- Putting the subject and the main verb near the start of the sentence, and telling events in the order they happen,
  rather than stacking conditions before the main clause.
- Giving each sentence one idea, together with its reason or result, and splitting a sentence that holds two.
- Using "would" for something that the text considers but that doesn't happen, such as a rejected alternative.
- Phrasing things the way people naturally would, rather than in a robotic or overly literal way.
- Prefer a word with one meaning. If a phrase can mean two things, like “at once” (“immediately” or “together”), use the
  word for the one you mean.
- Describe what happens literally. Avoiding using "images", like “sunk into” or “calm”, except for when that's an
  established term in the project.

## Tool availability

Most projects have a nix development shell, which provides the project's dependencies and build tools. Run commands in
it by prefixing them with `nix develop -c`.

### Missing programs

If you need a program that is neither installed nor in the devshell, run it through `nix shell`:

```sh
nix shell nixpkgs#$package -c $program $args
```

Don't swap in a different program or write a script that does the same job. For example, if `python3` is missing, run
`nix shell nixpkgs#python3 -c python3 script.py` rather than rewriting the script in `node` or `perl`.

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

A function makes sense when it:

- Hides details that would distract from the flow of the code that calls it.
- Is called from more than one place.

## Tests

### Location

If the language allows it, keep the tests in their own module or file rather than in the file of the code they test.
In Rust, for example, the tests for `src/foo.rs` go in `src/foo/tests.rs`, and `src/foo.rs` declares the module with
`#[cfg(test)] mod tests;`.

### What to test

A test should check the promises that an interface makes to its callers. "Interface" has a broad meaning here. It is
the part of some code that its callers use and depend on, such as what they call, what they pass in, and what they get
back or can observe, rather than a language feature like a Rust trait. The callers can be a user, another program or
other parts of the same program.

A good test:

- Tests the smallest interface that the change affects, and uses it only the way its callers do. Decide what the
  interface is from what the code does and who relies on it, not from its visibility (`pub`).
- Checks a promise that a caller would understand, such as "the parser accepts identifiers with non-ASCII letters",
  rather than an internal detail such as "`is_identifier_char` returns `true` for `é`".
- Checks a promise of the project rather than of a dependency (a library, the standard library, the language, the
  operating system, ...). For example, don't test that `clap` reads `env = "FOO"`. Test that the command does the
  right thing when `FOO` is set.
- Fails when the code breaks the promise, for example when you revert the change, and passes when you change the
  internals but the code still keeps the promise.
- Can run in parallel with other tests.
- Is fast, because tests are part of the development loop and you run them after every change.

A test that breaks these rules often can't catch a bug, but it still costs time to run, to read and to update along
with the code, so it is worse than having no test at all.

### Design

The design of the code decides how easy it is to write good tests for it. If it is hard to give an interface what it
needs or to control what it does, people end up testing small helpers instead, or not writing tests at all. So design
interfaces that:

- Declare all the state they need, and only that state, so that a test can pass it in. Don't read global state
  (statics, singletons, environment variables) deep in the code, and don't ask for a large object ("god object") when
  the code only uses a small part of it.
- Use the real external services, such as the file system, a database, another program or a third-party API, rather
  than mocks. A test that uses a mock checks the mock and not the program, and if a test fails because a service is
  slow or unavailable, the program has the same problem.
- Give the same output for the same input. Values that change on every run, such as the clock or random values, are
  inputs too, so the caller passes them in. The tests then work like a proof by induction: if the output depends only
  on the input, and the code is correct for the usual case and for each edge case, then it is also correct for the
  other inputs of the same kind.

When tests use real services, the side effects of one test must not affect another. For example, use a temporary
directory per test, `#[sqlx::test]` for a database, or different names for the things each test creates in a
third-party service. If the project's development environment can't provide a service, change the environment so that
it can, or tell the user.

If you can't write such a test, change the design, not the test.

These rules are mainly for new code. For old code, tell the user about the problem, and only change its design if the
user asks.
