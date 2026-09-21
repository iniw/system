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
        domain = "vini.cat";
        accounts = [
          {
            name = "social";
            flavor = "purelymail";
            webdavId = "280603";
            color = "#6045f7";
            calendar = true;
            contacts = true;
          }
          {
            name = "work";
            flavor = "purelymail";
            webdavId = "280601";
            color = "#f7455d";
            calendar = true;
            contacts = true;
          }
          {
            name = "dev";
            flavor = "purelymail";
            webdavId = "276495";
            color = "#45a7f7";
          }
          {
            name = "contact";
            flavor = "purelymail";
            webdavId = "280620";
            color = "#45f786";
          }
          {
            name = "metalbear";
            address = "viniciusd@metalbear.com";
            flavor = "gmail.com";
            calendar = true;
          }
        ];
      in
      {
        email.accounts =
          accounts
          |> lib.map (account: {
            ${account.name} =
              let
                address = account.address or "${account.name}@${domain}";
                isPurelyMail = account.flavor == "purelymail";
              in
              lib.mergeAttrsList [
                {
                  inherit address;
                  realName = "Vinicius Deolindo";

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
                  if isPurelyMail then
                    {
                      userName = address;
                      primary = account.name == "social";

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
              let
                address = account.address or "${account.name}@${domain}";
              in
              if account.flavor == "purelymail" then
                {
                  remote = {
                    type = "caldav";
                    url = "https://purelymail.com/webdav/${account.webdavId}/caldav/default/";
                    userName = address;
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
                    url = "https://apidata.googleusercontent.com/caldav/v2/${address}/events";
                    userName = address;
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
                userName = "${account.name}@${domain}";
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
