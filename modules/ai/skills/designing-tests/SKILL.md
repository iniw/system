---
name: designing-tests
description: Decides which tests are worth writing, at which interface, and how to design code so that it is easy to test. Use before you plan, write or review tests in any language, and when you fix a bug.
---

# Test design

A test should catch a regression, which is a change that breaks a promise that an interface makes to its callers.
"Interface" has a broad meaning here. It is the part of some code that its callers use and depend on, such as what
they call, what they pass in, and what they get back or can observe, rather than a language feature like a Rust trait.
The callers can be a user, another program or other parts of the same program.

Each test costs time to run, to read and to update along with the code, so a test that can't catch a regression is
worse than having no test at all. For each test you plan, name a plausible bug in our code that would make it fail.
If you can't name one, don't write the test.

## What to test

Write a test for a promise whose regression would be costly. For example, a backup tool that shows the wrong progress
causes its users far less trouble than one that restores the wrong files. This holds in two cases.

The first case is an invariant, meaning a promise that is part of the core of the program, such as a backup tool
restoring exactly the files that it backed up. The core is what makes the program worth using, so test it thoroughly.
The other parts of the program, such as its progress output or the wording of its messages, can and should change over
time. A test of those parts would break each time they change on purpose, and it would catch nothing that matters, so
don't write one. Wire formats, configuration and other contracts with external clients are part of the core, because
breaking them breaks the clients.

The second case is a bug that you fix. The bug has already cost the users and the time to fix it, so add a regression
test in the same change as the fix, so that the bug doesn't come back. The test should check the cause of the bug
rather than its symptom, and the two are often in different parts of the program. For example, if the progress of a
backup goes past 100% because the tool visits hard-linked files twice, the test should check that the tool visits each
file once, and it doesn't involve the progress output at all. Check that the test fails without the fix and passes with
it, and that it fails because of the bug rather than because of a broken fixture.

Don't test a promise of a dependency, such as a library, a framework, the standard library, the language, the operating
system or a similar external component. Using a dependency means trusting it to keep its promises, and a well-known
dependency has earned that trust through its users and its own tests. This includes code that only declares what a
dependency should do. For example, the attribute `#[arg(env = "FOO")]` on a field of a `clap` argument struct tells
`clap` to read the field from the environment variable `FOO` when the command line doesn't set it. A test that sets
`FOO` and checks that the field holds its value only checks `clap`, so don't write one. If the option is part of the
core of the program, test the promise that the project makes with it, such as what the command does when `FOO` is set.

The table below shows the difference between a test of a dependency and a test of our behavior.

| Tests the dependency                         | Tests our behavior                                                                       |
| -------------------------------------------- | ---------------------------------------------------------------------------------------- |
| A derived type round-trips through Serde     | A fixture from a real client still decodes, and our output has the shape clients expect  |
| A channel delivers a value                   | Our worker finishes the accepted jobs before it shuts down, and rejects new jobs after   |
| A timeout fires                              | Our operation returns the documented error and cancels the work it started               |
| A getter returns its field                   | A state transition keeps its invariant when it succeeds and when it fails                |
| A map returns the value stored under a key   | Our cache returns the stored entry until it expires, and fetches a new one after that    |

Don't write tests to reach a number of tests or a coverage target. Coverage helps to find code that no test reaches,
but it doesn't show that a test is useful. Extend an existing test when it already covers the scenario, rather than
adding a copy under a new name. In Rust, for example, add a `#[case]` to an existing `rstest` test rather than writing a
new test. Each case in a table-driven test should cover a different edge case or failure.

## Which interface to test

Test the smallest interface that the change affects, and use it only the way its callers do. Decide what the interface
is from what the code does and who relies on it, not from its visibility (`pub`).

- Test an algorithm, a parser, a validation or a state machine on its own, because these have a meaning of their own.
- Test a larger behavior through the component that provides it, with its real internal code, rather than with one test
  per helper function.
- Test what users and other programs see, such as a CLI, an API or a wire protocol, through that interface. Don't push
  every test through an expensive end-to-end environment when a smaller interface shows the same behavior.

Check the promise in terms that a caller would understand. Instead of an internal detail, such as
"`is_identifier_char` returns `true` for `é`", check "the parser accepts identifiers with non-ASCII letters".

## How a test should behave

Each test should:

- Fail when the code breaks the promise, for example when you revert the change, and pass when you change the
  internals but the code still keeps the promise.
- Be able to run in parallel with other tests. A test that needs a resource that only one test can use at a time may
  run on its own, as the project's other tests of that kind do.
- Be as fast as the behavior that it checks allows, because tests are part of the development loop. A slow test that
  checks something important is still worth keeping, so don't remove or weaken a test only because it is slow.
- Wait for an event that it can observe, such as a message on a channel or a line in a log, rather than sleep and hope
  that a background task has finished. Use a timeout only to stop a test that hangs.

## Design

The design of the code decides how easy it is to write good tests for it. If it is hard to give an interface what it
needs or to control its side effects, people end up testing small internal helpers instead, or not writing tests at
all. So design interfaces that:

- Declare all the state they need, and only that state, so that a test can pass it in. Try to avoid reading global
  state (statics, singletons, environment variables) deep in the code, and try to avoid asking for a large object
  ("god object") when the code only uses a small part of it.
- Prefer real external services, such as the file system, a database, another program or a third-party API, over
  mocks when the tests can use them. If a test fails because a service is slow or unavailable, the program has the same
  problem.
- Give the same output for the same input. Values that change on every run, such as the clock or random values, are
  inputs too, so the caller should pass them in. The tests then work like a proof by induction: if the output depends
  only on the input, and the code is correct for the usual cases and for the edge cases, then it is also correct for
  the other inputs of the same kind.

When tests use real services, the side effects of one test shouldn't affect another. For example, use a temporary
directory per test, fresh, isolated database instances, or different names for the things each test creates in a
third-party service. If the project's development environment can't provide a service, change the environment so that
it can, or tell the user.

Try to keep test support out of the production code. Fixtures, builders and assertion helpers should go in the test
modules or in a test-support directory. Try to avoid adding constructors, setters or bypasses that only tests use,
making an item more visible, or deriving a trait such as `PartialEq` only so that a test can compare it. If a test needs
code outside the test modules, ask the user for guidance.

If the design makes such a test hard to write, tell the user, and ask whether to change the design, write a smaller
test or leave the test out, because a change sometimes has to ship quickly with a design that is harder to test.

These rules are mainly for new code. For old code, tell the user about the problem, and only change its design if the
user asks.

## Location

If the language allows it, keep the tests in their own module or file rather than in the file of the code they test.
In Rust, for example, the tests for `src/foo.rs` should go in `src/foo/tests.rs`, and `src/foo.rs` should declare the
module with `#[cfg(test)] mod tests;`. Follow the project's convention when it differs.
