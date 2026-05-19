## Tool Availability

Most projects being worked on will have a nix devShell - make sure to use it by prefixing commands
with `nix develop -c`, this ensures the project's dependencies and build tools are available.

Note that system-level tools (e.g `rg`, `find`, `jj`, `git`, `kubectl`, ...) don't need to go through `nix develop -c`,
only toolchain and project-specific tools (e.g: `cargo`, `uv`, `node`, `cmake`, ...).

If a package useful for troubleshooting or one-off tasks is not installed globally and not available in the devShell,
use `nix-shell -p "${package}" --quiet --command "${command}"` to run it ephemerally.

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

Do not be afraid of long, monolithic functions. A longer function with clear, logical sections surrounded by comments
contextualizing each of them are easier to read than a chain of very small, trivial helpers.

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

    let bob  = {
        // ...
    };

    // Explain what we'll be doing now and how it fits into "The Big Picture".

    // ...
}
```
