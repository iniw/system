let
  email = "viniciusd@metalbear.com";
in
{
  systemModule = {
    homebrew = {
      brews = [ "docker" ];
      casks = [
        "docker-desktop"
        "linear-linear"
        "notion"
        "slack"
      ];
    };
  };

  homeManagerModule =
    { lib, ... }:
    {
      programs = {
        thunderbird.profiles.default = {
          accountsOrder = lib.mkBefore [ "metalbear" ];
          calendarAccountsOrder = lib.mkBefore [ "metalbear" ];
        };

        jujutsu.settings."--scope" = [
          {
            "--when".repositories = [ "~/work/metalbear" ];
            user.email = email;
          }
        ];

        git.includes = [
          {
            condition = "gitdir:~/work/metalbear/";
            contents.user.email = email;
          }
        ];
      };

      accounts = {
        email.accounts.metalbear = rec {
          address = email;

          userName = address;
          realName = "Vinicius Deolindo";

          flavor = "gmail.com";

          smtp = {
            host = "smtp.gmail.com";
            port = 465;
          };

          imap = {
            host = "imap.gmail.com";
            port = 993;
          };

          thunderbird = {
            enable = true;
            perIdentitySettings = id: {
              "mail.identity.id_${id}.reply_on_top" = 1;
              "mail.identity.id_${id}.sig_bottom" = false;

              # See: https://github.com/nix-community/home-manager/issues/7959
              "calendar.registry.calendar_${id}.imip.identity.key" = "id_${id}";
            };
          };
        };

        calendar.accounts.metalbear = {
          remote = {
            type = "caldav";
            url = "https://apidata.googleusercontent.com/caldav/v2/${email}/events";
            userName = email;
          };

          thunderbird.enable = true;
        };
      };
    };
}
