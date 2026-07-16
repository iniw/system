let
  name = "Vinicius Deolindo";
  email = "git@vini.cat";
in
{
  homeManagerModule =
    { pkgs, ... }:
    {
      programs = {
        git = {
          enable = true;

          settings = {
            user = {
              inherit name email;
            };
          };

          ignores = [
            ".DS_Store"
            "scratch"
            "result"
          ];
        };

        jujutsu = {
          enable = true;

          settings = {
            ui = {
              default-command = "log";
              movement.edit = true;
              merge-editor = "meld";
            };

            user = {
              inherit name email;
            };

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
              # Pushes to every remote in the current repo
              pusha = [
                "util"
                "exec"
                "--"
                "bash"
                "-c"
                # bash
                ''
                  set -euo pipefail

                  jj git remote list | awk '{print $1}' | while read -r remote; do
                    jj git push --remote "$remote" "$@"
                  done
                ''
                ""
              ];
              # Forks the current repo and configures jj for multi-remote workflow
              # See: https://docs.jj-vcs.dev/latest/guides/multiple-remotes/#contributing-upstream-with-a-github-style-fork
              fork = [
                "util"
                "exec"
                "--"
                "bash"
                "-c"
                # bash
                ''
                  set -euo pipefail

                  trunk=$(jj config get 'revset-aliases."trunk()"')
                  trunk_bookmark="''${trunk%%@*}"
                  trunk_remote="''${trunk##*@}"

                  gh repo set-default "$trunk_remote"
                  gh repo fork --remote-name "$trunk_remote"

                  jj config set --repo git.fetch "['$trunk_remote', 'upstream']"
                  jj config set --repo git.push "$trunk_remote"
                  jj config set --repo 'revset-aliases."trunk()"' "$trunk_bookmark@upstream"

                  jj git fetch

                  jj bookmark track "$trunk_bookmark" --remote upstream
                ''
              ];
              # Squash-merges a branch into a new change on top of `trunk()`
              squash-branch = [
                "util"
                "exec"
                "--"
                "bash"
                "-c"
                # bash
                ''
                  set -euo pipefail

                  if [ "$#" -ne 1 ]; then
                    echo "usage: jj squash-branch <bookmark>" >&2
                    exit 2
                  fi

                  bookmark="$1"

                  author=$(jj log --no-graph --revision "$bookmark" --template 'author')

                  trunk=$(jj config get 'revset-aliases."trunk()"')
                  trunk_bookmark="''${trunk%%@*}"

                  jj new "$trunk_bookmark"
                  jj duplicate "$trunk_bookmark..$bookmark" --onto @
                  jj squash --from '@::' --into @ --editor

                  jj metaedit --author "$author"
                ''
                ""
              ];
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
        };

        gh.enable = true;

        difftastic = {
          enable = true;

          jujutsu.enable = true;
          git.enable = true;

          options = {
            syntax-highlight = "off";
          };
        };
      };

      home = {
        packages = with pkgs; [
          hut

          # Used by jj to track changes to the working copy in large repositories
          # See: https://docs.jj-vcs.dev/latest/config/#watchman
          watchman

          # Merge resolution tools
          meld
          mergiraf

          # Diff viewers
          lumen
        ];
      };
    };
}
