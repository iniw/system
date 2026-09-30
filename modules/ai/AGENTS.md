# Global User Guidance

## Tool Availability

Most projects being worked on will have a nix development shell - make sure to use it by prefixing commands with
`nix develop -c`, this ensures the project's dependencies and build tools are available.

### Missing Programs

If you need a program that is not installed and is not in the devshell, run it with `nix shell`:

```sh
nix shell nixpkgs#$package -c $program $args
```

Do not use a different program in its place, and do not write a script that does the same work. For example, if `jq` is
not available, run `nix shell nixpkgs#jq -c jq '.foo'`. Do not parse the JSON with `python`.

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
