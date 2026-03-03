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
              default-command = "status";
              movement.edit = true;
              merge-editor = "meld";
            };

            user = {
              inherit name email;
            };

            revsets = {
              bookmark-advance-to = "heads(first_ancestors(@) & ~empty())";
            };

            aliases = {
              # "Long log", shows all revisions
              ll = [
                "log"
                "-r"
                "::"
              ];
              # "Log trunk", shows all revisions in trunk()
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
                ''
                  set -euo pipefail
                  original=$(jj git remote list | awk '/^origin /{print $2}')
                  gh repo fork
                  gh repo set-default "$original"
                  jj config set --repo git.fetch '["upstream", "origin"]'
                  jj config set --repo git.push origin
                  trunk=$(jj config get 'revset-aliases."trunk()"')
                  jj config set --repo 'revset-aliases."trunk()"' "''${trunk/origin/upstream}"
                  jj git fetch
                ''
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

            fsmonitor = {
              backend = "watchman";
              watchman.register-snapshot-trigger = true;
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

          # Used by jj to track changes to the working copy
          # See: https://docs.jj-vcs.dev/latest/config/#watchman
          watchman

          # Merge resolution tools
          meld
          mergiraf
        ];
      };
    };
}
