let
  user = {
    name = "Vinicius Deolindo";
    email = "git@vini.cat";
  };
in
{
  homeManagerModule = { pkgs, inputs, ... }: {
    imports = [ inputs.jj-gh.homeManagerModules.default ];

    programs = {
      git = {
        enable = true;

        settings = {
          inherit user;
        };

        ignores = [
          ".DS_Store"
          "scratch"
          "result"
        ];
      };

      jujutsu = {
        enable = true;
        # FIXME: Go back to the nixpkgs source once a release has colocated workspaces.
        package = pkgs.jujutsu.overrideAttrs (
          finalAttrs: prevAttrs: {
            version = "trunk";
            src = prevAttrs.src.override {
              tag = null;
              rev = "92d238769cf81778be897e008519cd7b46192568";
              hash = "sha256-/IhZoSIy/r01+F1sC5d20k/64WSBRzp/UM2zp01Vst4=";
            };
            # FIXME: Set `cargoHash` instead once this is merged: https://github.com/NixOS/nixpkgs/pull/514218
            # Until then, overriding `cargoHash` has no effect, so the vendored dependencies are set directly.
            cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
              inherit (finalAttrs) pname version src;
              hash = "sha256-Hv/cHlbpo41uhVHDxkI7tURfDjjBnxbjx7hzsnESCSw=";
            };
            # The version check expects a release version.
            doInstallCheck = false;
          }
        );

        settings = {
          aliases = {
            # "Long log", shows all revisions
            ll = [
              "log"
              "-r"
              "::"
            ];

            # "Log trunk", shows all revisions in `trunk()`
            lt = [
              "log"
              "-r"
              "::trunk()"
            ];

            fork = [
              "util"
              "exec"
              "--"
              (pkgs.writers.writeNu "jj-fork" ''

                # Forks the current repo and configures jj for multi-remote workflow.
                # See: https://docs.jj-vcs.dev/latest/guides/multiple-remotes/#contributing-upstream-with-a-github-style-fork
                def main [] {
                  let trunk = jj config get 'revset-aliases."trunk()"'
                    | parse '{bookmark}@{remote}'
                    | first

                  gh repo set-default $trunk.remote
                  gh repo fork

                  jj config set --repo git.fetch $"['($trunk.remote)', 'upstream']"
                  jj config set --repo git.push $trunk.remote
                  jj config set --repo 'revset-aliases."trunk()"' $"($trunk.bookmark)@upstream"

                  jj git fetch

                  jj bookmark track $trunk.bookmark
                }
              '')
            ];

            squash-branch = [
              "util"
              "exec"
              "--"
              (pkgs.writers.writeNu "jj-squash-branch" ''

                # Squash-merges a branch into a new change on top of `trunk()`.
                def main [
                  bookmark: string # Bookmark whose changes should be squash-merged.
                ] {
                  let author = jj log --no-graph --revision $bookmark --template 'author'

                  let trunk = jj config get 'revset-aliases."trunk()"'
                    | parse '{bookmark}@{remote}'
                    | first

                  jj new $trunk.bookmark
                  jj duplicate $"($trunk.bookmark)..($bookmark)" --onto '@'
                  jj squash --from '@::' --into '@' --editor

                  jj metaedit --author $author
                }
              '')
            ];

            merge-trunk = [
              "util"
              "exec"
              "--"
              (pkgs.writers.writeNu "jj-merge-trunk" ''

                # Merges the given bookmark into `trunk()` then advances the bookmark.
                def main [
                  bookmark: string                            # Bookmark that should be merged.
                  --message (-m): string = "meta: merge main" # Message to use for the merge commit.
                ] {
                  jj new $bookmark "trunk()"
                  jj commit --message $message
                  jj bookmark advance $bookmark
                }
              '')
            ];
          };

          ui = {
            default-command = "log";
            movement.edit = true;
            merge-editor = "meld";
            diff-formatter = [
              "difft"
              "--color=always"
              "--sort-paths"
              "--syntax-highlight=off"
              "--width=$width"
              "$left"
              "$right"
            ];
          };

          inherit user;

          revsets = {
            bookmark-advance-from = # jujutsu
              ''
                coalesce(
                  heads(::to & bookmarks() & ~immutable()),
                  heads(::to & bookmarks()),
                )
              '';

            bookmark-advance-to =
              # From: https://github.com/jj-vcs/jj/issues/9055#issuecomment-4024269740
              # jujutsu
              ''
                heads(::@ & mutable() & ~description(exact:"") & (~empty() | merges()))
              '';
          };

          templates = {
            draft_commit_description = # jujutsu
              ''
                concat(
                  coalesce(description, default_commit_description, "\n"),
                  surround(
                    "\nJJ: This commit contains the following changes:\n", "",
                    indent("JJ:     ", diff.stat(72)),
                  ),
                  "\nJJ: ignore-rest\n",
                  diff.git(),
                )
              '';
          };
        };

        gh = {
          enable = true;

          aliases.pr = "pr";
        };
      };

      gh = {
        enable = true;

        settings.git_protocol = "ssh";
      };

      difftastic = {
        enable = true;

        jujutsu.enable = false;
        git.enable = true;

        options = {
          syntax-highlight = "off";
        };
      };
    };

    home.packages = with pkgs; [
      hut

      # Used by jj to track changes to the working copy in large repositories
      # See: https://docs.jj-vcs.dev/latest/config/#watchman
      watchman

      # Merge resolution tools
      meld
      # FIXME: Remove the override once this is merged into nixpkgs-unstable: https://github.com/NixOS/nixpkgs/pull/568226
      # With gcc 16, the tests fail with "corrupted size vs. prev_size". See https://codeberg.org/mergiraf/mergiraf/issues/761
      (mergiraf.overrideAttrs (prevAttrs: {
        env = (prevAttrs.env or { }) // {
          NIX_CFLAGS_COMPILE = "-fno-strict-aliasing";
        };
      }))

      # Diff viewers
      lumen
    ];
  };
}
