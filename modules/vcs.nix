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
              pusha = [
                "util"
                "exec"
                "--"
                (pkgs.writers.writeNu "jj-pusha" ''

                  # Pushes to every remote in the current repo.
                  def --wrapped main [
                    ...arguments: string # Arguments to forward to each `jj git push` invocation.
                  ] {
                    if ('--help' in $arguments) or ('-h' in $arguments) {
                      return (help main)
                    }

                    let remotes = jj git remote list
                      | lines
                      | parse '{remote} {url}'
                      | get remote

                    for remote in $remotes {
                      jj git push --remote $remote ...$arguments
                    }
                  }
                '')
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
                    gh repo fork --remote-name $trunk.remote

                    jj config set --repo git.fetch $"['($trunk.remote)', 'upstream']"
                    jj config set --repo git.push $trunk.remote
                    jj config set --repo 'revset-aliases."trunk()"' $"($trunk.bookmark)@upstream"

                    jj git fetch

                    jj bookmark track $trunk.bookmark --remote upstream
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
