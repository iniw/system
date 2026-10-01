# Global User Guidelines

## Tool Availability

Most projects being worked on will have a nix development shell - make sure to use it by prefixing commands with
`nix develop -c`, this ensures the project's dependencies and build tools are available.

### Missing Programs

If you need a program that is not installed and is not in the devshell, run it with `nix shell`:

```sh
nix shell nixpkgs#$package -c $program $args
```

Do not use a different program in its place, and do not write a script that does the same work. For example, if
`python3` is not available, run `nix shell nixpkgs#python3 -c python3 script.py`. Do not write the script again in
`node` or `perl`.

The package name can be different from the program name. For example, `dig` is in the `dnsutils` package.

To use more than one package in a pipeline, give all of them and run the pipeline with `sh -c`:

```sh
nix shell nixpkgs#curl nixpkgs#jq -c sh -c 'curl -s https://example.com/data.json | jq .foo'
```

## Version Control

Always use `jj` instead of `git` for version control operations. Repositories are created with jujutsu and colocated
with git metadata, so git commands will work, but jujutsu commands are the more correct source of truth.

When looking at diffs specify the `--git` flag, like so: `jj diff --git`, to avoid using non-standard diff viewers the
user may have configured.

## Functions

Avoid extracting trivial, self-contained logic into micro-functions that are only used once. When the code is simple
(which it most often is), prefer inlining it at the callsite instead of introducing a helper that achieves nothing but
add indirection, hurting readability.

Functions make sense when they:

- Hide details that would distract from the callsite's flow;
- Are used in multiple places.

## Tests

### Location

If the language allows it, put the tests in their own module or file, and not in the file of the code that they test.
For example, in Rust, put the tests of `src/foo.rs` in `src/foo/tests.rs`, and declare the module in `src/foo.rs` with
`#[cfg(test)] mod tests;`.

### What to test

A test should check the promises that an interface makes to its callers. Here, "interface" has a general meaning: the
part of some code that its callers use and depend on, such as what they call, what they give to it, and what they get
back or can see. It is not a language feature, such as a Rust trait. The callers can be a user, another program or
other parts of the same program.

A good test:

- Tests the smallest interface that the change affects, and uses it only as its callers do. Decide what the interface
  is from what the code does and from who relies on it, not from its visibility (`pub`).
- Checks a promise that a caller understands, for example "the parser accepts identifiers with non-ASCII letters". It
  does not check an internal detail, for example "`is_identifier_char` returns `true` for `é`".
- Checks a promise of the project, and not of a dependency (a library, the standard library, the language, the
  operating system, ...). For example, do not test that `clap` reads `env = "FOO"`. Test that the command does the
  correct thing when `FOO` is set.
- Fails when the code does not keep the promise (for example, when you undo the change), and passes when you change
  the internals but the code still keeps the promise.
- Can run in parallel with other tests.
- Is fast. Tests are a part of the development loop, and you run them after each change.

A test that does not follow these rules often cannot find a bug. But it still costs time to run, to read and to change
with the code, so it is worse than no test.

### Design

The design of the code decides how easy it is to write good tests for it. If it is hard to give an interface what it
needs, or to control what it does, people test small helpers instead, or they do not write tests. So design interfaces
that:

- Declare all the state that they need, and only that state, so that a test can give it to them. Do not read global
  state (statics, singletons, environment variables) deep in the code. Do not ask for a large object ("god object")
  when the code uses only a small part of it.
- Use the real external services (the file system, a database, another program or a third-party API), and not mocks.
  A test that uses a mock checks the mock, and not the program. If a test fails because a service is slow or not
  available, the program has the same problem, so the test does its job when it shows it. But the side effects of one
  test must not change another test. For example, use a temporary directory for each test, `#[sqlx::test]` for a
  database, or different names for the things that each test creates in a third-party service. If the project's
  development environment cannot provide a service, change the environment so that it can, or tell the user.
- Give the same output for the same input. Values that change on each run (the clock, random values) are inputs too, so
  the caller gives them. Then the tests work like a proof by induction: if the output depends only on the input, and
  the code is correct for the usual case and for each edge case, this implies that it is correct for the other inputs
  of the same kind.

If you cannot write such a test, change the design, not the test.

These rules are mainly for new code. For old code, tell the user about the problem, and change its design only if the
user asks.

## Language

When writing something that will be read by a human, including me, use *SIMPLE LANGUAGE*. More specifically, use the
ASD-STE100 Simplified Technical English (STE) standard.

The more condensed, buzzwordy, jargon-heavy something is, the harder it is to read. Do not write like that.

This applies to essentially everything apart from the code itself: comments, variable/function/module names, PR
titles/bodies, commit messages, replies to my prompts, etc.

This is the most important rule of all. Follow it religiously.
