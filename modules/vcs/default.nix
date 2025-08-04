let
  name = "Vinicius Deolindo";
  email = "andrade.vinicius934@gmail.com";
in
{
  homeModule = {
    programs = {
      gh = {
        enable = true;
        settings.git_protocol = "ssh";
      };

      git = {
        enable = true;

        userName = name;
        userEmail = email;

        delta = {
          enable = true;

          options = {
            navigate = true;
            line-numbers = true;
          };
        };

        extraConfig.diff.algorithm = "histogram";

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
