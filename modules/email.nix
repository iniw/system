{
  homeManagerModule =
    { pkgs, lib, ... }:
    {
      programs.thunderbird = {
        enable = true;
        package = pkgs.thunderbird-bin;

        profiles.default = {
          isDefault = true;

          accountsOrder = [
            "social"
            "git"
            "work"
            "contact"
          ];

          calendarAccountsOrder = [
            "work"
            "social"
          ];

          feedAccounts.feed = { };
        };
      };

      accounts =
        let
          domain = "vini.cat";
          # NOTE: The ordering of this list matters, `lib.take 2` is called later and expects to get the 'social' and 'work' accounts
          accounts = [
            {
              name = "social";
              webdavId = "280603";
              color = "#6045f7";
            }
            {
              name = "work";
              webdavId = "280601";
              color = "#f7455d";
            }
            {
              name = "git";
              webdavId = "276495";
              color = "#45a7f7";
            }
            {
              name = "contact";
              webdavId = "280620";
              color = "#45f786";
            }
          ];
        in
        {
          email.accounts =
            accounts
            |> lib.map (account: {
              ${account.name} = rec {
                address = "${account.name}@${domain}";

                userName = address;
                realName = "Vinicius Deolindo";

                primary = account.name == "social";

                smtp = {
                  host = "smtp.purelymail.com";
                  port = 465;
                };

                imap = {
                  host = "imap.purelymail.com";
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
            })
            |> lib.mergeAttrsList;

          calendar.accounts =
            accounts
            |> lib.take 2 # 'social' and 'work'
            |> lib.map (account: {
              ${account.name} = {
                remote = {
                  type = "caldav";
                  url = "https://purelymail.com/webdav/${account.webdavId}/caldav/default/";
                  userName = "${account.name}@${domain}";
                };

                thunderbird = {
                  enable = true;
                  color = account.color;
                };
              };
            })
            |> lib.mergeAttrsList;

          contact.accounts =
            accounts
            |> lib.take 2 # 'social' and 'work'
            |> lib.map (account: {
              ${account.name} = {
                remote = {
                  type = "carddav";
                  url = "https://purelymail.com/webdav/${account.webdavId}/carddav/default/";
                  userName = "${account.name}@${domain}";
                };

                thunderbird.enable = true;
              };
            })
            |> lib.mergeAttrsList;
        };

      programs.git.extraConfig.sendemail.identity = "git";
    };
}
