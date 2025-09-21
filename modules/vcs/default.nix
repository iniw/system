let
  name = "Vinicius Deolindo";
  email = "git@vini.cat";
in
{
  homeModule =
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
            # I do a whole lot of force-pushing and history-rewriting, so immutable heads are really annoying.
            revset-aliases = {
              "immutable_heads()" = "none()";
            };

            ui.movement.edit = true;

            user = {
              inherit name email;
            };
          };
        };
      };
    };
}
