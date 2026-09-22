{
  homeManagerModule = { config, lib, ... }: {
    programs.thunderbird = {
      enable = true;

      profiles.default = {
        isDefault = true;

        accountsOrder = [
          "metalbear"
          "social"
          "dev"
          "work"
          "contact"
        ];

        calendarAccountsOrder = [
          "metalbear"
          "work"
          "social"
        ];

        feedAccounts.feed = { };
      };
    };

    accounts =
      let
        accounts = [
          {
            name = "metalbear";
            address = "viniciusd@metalbear.com";
            flavor = "gmail.com";

            calendar = true;
          }
          {
            name = "social";
            address = "social@vini.cat";
            flavor = "purelymail";

            calendar = true;
            contacts = true;

            webdavId = "280603";
            color = "#6045f7";
          }
          {
            name = "work";
            address = "work@vini.cat";
            flavor = "purelymail";

            calendar = true;
            contacts = true;

            webdavId = "280601";
            color = "#f7455d";
          }
          {
            name = "dev";
            address = "dev@vini.cat";
            flavor = "purelymail";

            webdavId = "276495";
            color = "#45a7f7";
          }
          {
            name = "contact";
            address = "contact@vini.cat";
            flavor = "purelymail";

            webdavId = "280620";
            color = "#45f786";
          }
        ];
      in
      {
        email.accounts =
          accounts
          |> lib.map (account: {
            ${account.name} = lib.mergeAttrsList [
              {
                inherit (account) address;
                realName = "Vinicius Deolindo";

                primary = account.name == "social";

                thunderbird = {
                  enable = true;

                  perIdentitySettings = id: {
                    "mail.identity.id_${id}.reply_on_top" = 1;
                    "mail.identity.id_${id}.sig_bottom" = false;

                    # See: https://github.com/nix-community/home-manager/issues/7959
                    "calendar.registry.calendar_${id}.imip.identity.key" = "id_${id}";
                  };
                };
              }
              (
                if account.flavor == "purelymail" then
                  {
                    userName = account.address;

                    smtp = {
                      host = "smtp.purelymail.com";
                      port = 465;
                    };

                    imap = {
                      host = "imap.purelymail.com";
                      port = 993;
                    };
                  }
                else
                  { inherit (account) flavor; }
              )
            ];
          })
          |> lib.mergeAttrsList;

        calendar.accounts =
          accounts
          |> lib.filter (account: account.calendar or false)
          |> lib.map (account: {
            ${account.name} =
              if account.flavor == "purelymail" then
                {
                  remote = {
                    type = "caldav";
                    url = "https://purelymail.com/webdav/${account.webdavId}/caldav/default/";
                    userName = account.address;
                  };

                  thunderbird = {
                    enable = true;
                    color = account.color;
                  };
                }
              else
                {
                  remote = {
                    type = "caldav";
                    url = "https://apidata.googleusercontent.com/caldav/v2/${account.address}/events";
                    userName = account.address;
                  };

                  thunderbird.enable = true;
                };
          })
          |> lib.mergeAttrsList;

        contact.accounts =
          accounts
          |> lib.filter (account: account.contacts or false)
          |> lib.map (account: {
            ${account.name} = {
              remote = {
                type = "carddav";
                url = "https://purelymail.com/webdav/${account.webdavId}/carddav/default/";
                userName = account.address;
              };

              thunderbird.enable = true;
            };
          })
          |> lib.mergeAttrsList;
      };

    xdg.autostart.entries = [
      "${config.programs.thunderbird.package}/share/applications/thunderbird.desktop"
    ];
  };
}
