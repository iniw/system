let
  name = "Vinicius Deolindo";
  email = "git@vini.cat";
in
{
  homeManagerModule =
    { pkgs, ... }:
    {
      programs = {
        difftastic = {
          enable = true;
          jujutsu.enable = true;

          options = {
            syntax-highlight = "off";
          };
        };

        gh.enable = true;

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
          ];
        };

        jujutsu = {
          enable = true;

          settings = {
            ui = {
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

        mergiraf.enable = true;
      };

      home = {
        packages = with pkgs; [
          hut
        ];
      };
    };
}
