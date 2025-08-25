let
  name = "Vinicius Deolindo";
  email = "vwvw.ini@gmail.com";
in
{
  homeModule =
    { pkgs, ... }:
    {
      home.packages = [
        # https://github.com/google/gmail-oauth2-tools/blob/master/go/sendgmail/README.md
        pkgs.sendgmail
      ];

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

          delta = {
            enable = true;

            options = {
              navigate = true;
              line-numbers = true;
            };
          };

          extraConfig = {
            diff.algorithm = "histogram";
            sendemail = {
              smtpServer = "${pkgs.lib.getExe' pkgs.sendgmail "sendgmail"}";
              smtpServerOption = "-sender=${email}";
            };
          };

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
