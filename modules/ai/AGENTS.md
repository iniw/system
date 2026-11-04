# Global user guidelines

## Tool availability

Most projects have a nix development shell, which provides the project's dependencies and build tools. Run commands in
it by prefixing them with `nix develop -c`.

### Missing programs

If you need a program that is neither installed nor in the devshell, run it through `nix shell`:

```sh
nix shell nixpkgs#$package -c $program $args
```

Don't use a different program instead, or write a script that does the same job. For example, if `yq` is missing,
don't parse the YAML file with a Python script. Run `nix shell nixpkgs#yq-go -c yq .foo config.yaml` instead.

The package name can differ from the program name. For example, `dig` comes from the `dnsutils` package.

To use several packages in a pipeline, list all of them and run the pipeline through `sh -c`:

```sh
nix shell nixpkgs#curl nixpkgs#htmlq -c sh -c 'curl -s https://example.com | htmlq --text title'
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
