let
  name = "Vinicius Deolindo";
  email = "git@vini.cat";
in
{
  homeManagerModule =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.hut ];

      programs = {
        gh = {
          enable = true;
          settings.git_protocol = "ssh";
        };

        git = {
          enable = true;
          package = pkgs.gitFull;

          userName = name;
          userEmail = email;

          ignores = [ ".DS_Store" ];
        };

        jujutsu = {
          enable = true;

          settings = {
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

            ui = {
              default-command = "status";
              # Start editing commit with `jj prev` and `jj next`
              movement.edit = true;
            };

            user = {
              inherit name email;
            };
          };
        };
      };
    };
}
