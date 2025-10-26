let
  name = "Vinicius Deolindo";
  email = "git@vini.cat";
in
{
  homeManagerModule =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        hut
        meld
      ];

      programs = {
        gh.enable = true;

        git = {
          enable = true;
          package = pkgs.gitFull;

          settings = {
            merge.tool = "meld";
            user = {
              inherit name email;
            };
          };

          ignores = [ ".DS_Store" ];
        };

        jujutsu = {
          enable = true;

          settings = {
            ui = {
              merge-editor = [
                "meld"
                "$left"
                "$base"
                "$right"
                "-o"
                "$output"
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
    };
}
