# Global User Guidance

## Tool Availability

Most projects being worked on will have a nix development shell - make sure to use it by prefixing commands with
`nix develop -c`, this ensures the project's dependencies and build tools are available.

Note that system-level tools (e.g `rg`, `find`, `jj`, `git`, `kubectl`, ...) don't need to go through `nix develop -c`,
only toolchain and project-specific tools (e.g: `cargo`, `uv`, `node`, `cmake`, ...).

If a package useful for troubleshooting or one-off tasks is not installed globally and not available in the devshell,
use `nix-shell -p "${package}" --quiet --command "${command}"` to run it ephemerally.

## Version Control

Always use `jj` instead of `git` for version control operations. Repositories are created with jujutsu and colocated
with git metadata, so git commands will work, but jujutsu commands are the more correct source of truth.

When looking at diffs specify the `--git` flag, like so: `jj diff --git`, to avoid using non-standard diff viewers the
user may have configured.

## Splitting Work Into Commits

When you implement a feature or a user request, always split the work into small, ordered steps. Make each step one
commit. Each commit must be:

- **Atomic**: it does one thing. It builds and its tests pass on their own.
- **Reviewable**: a person can read and understand it alone, without the commits that come after it.
- **Reversible**: a person can revert it without breaking the commits before it.
- **Mergeable**: it can be merged alone, without the commits that come after it.

Put preparation work (for example, refactors, renames and new helpers) in commits before the commit that uses it. Do
not mix unrelated changes, such as formatting and behavior changes, in the same commit.

This makes the review easier for me, and for the person who reviews the pull request made from these changes.

## Functions

### Tiny functions

Avoid extracting trivial, self-contained logic into micro-functions that are only used once. When the code is simple
(which it most often is), prefer inlining it at the callsite instead of introducing a helper that achieves nothing but
add indirection, hurting readability.

Functions make sense when they:

- Hide details that would distract from the callsite's flow;
- Are used in multiple places.

### Function bodies

If the language supports it, use block expressions to keep temporary variables scoped to the part of the procedure that
needs them. This reduces cognitive load by limiting the number of names in scope at a given point.

See this example that ties everything up:

```rust
/// "The Big Picture", as a function-level doc comment.
fn function() {
    // Explain what we'll be doing now and how it fits into "The Big Picture".

    let foo = {
        let bar = /* ... */;
        let foo = bar.map(/* ... */);
        let baz = foo + bar;
        // ...
    };

    // Explain what we'll be doing now and how it fits into "The Big Picture".

    let alice = {
        // ...
    };

    let bob = {
        // ...
    };

    // Explain what we'll be doing now and how it fits into "The Big Picture".

    // ...
}
```

## Language

When writing something that will be read by a human, including me, use *SIMPLE LANGUAGE*. More specifically, use the
ASD-STE100 Simplified Technical English (STE) standard.

The more condensed, buzzwordy, jargon-heavy something is, the harder it is to read. Do not write like that.

This applies to essentially everything apart from the code itself: comments, variable/function/module names, PR
titles/bodies, commit messages, replies to my prompts, etc.

This is the most important rule of all. Follow it religiously.
