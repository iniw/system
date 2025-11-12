let
  name = "Vinicius Deolindo";
  email = "git@vini.cat";
in
{
  homeManagerModule =
    { pkgs, ... }:
    {
      programs = {
        gh.enable = true;

        git = {
          enable = true;
          package = pkgs.gitFull;

          settings = {
            user = {
              inherit name email;
            };
          };

          ignores = [
            ".DS_Store"
            "scratch"
          ];
        };

        jujutsu = {
          enable = true;

          settings = {
            ui = {
              merge-editor = "mergiraf";

              diff-formatter = [
                "difft"
                "--color=always"
                "$left"
                "$right"
              ];

              default-command = "status";

              # Start editing commit with `jj prev` and `jj next`
              movement.edit = true;
            };

            user = {
              inherit name email;
            };

            aliases = {
              # "Long log", shows all revisions
              ll = [
                "log"
                "-r"
                "::"
              ];
            };

            templates = {
              draft_commit_description = ''
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
      };

      home = {
        packages = with pkgs; [
          difftastic
          hut
          mergiraf
        ];

        sessionVariables.DFT_SYNTAX_HIGHLIGHT = "off";
      };
    };
}
