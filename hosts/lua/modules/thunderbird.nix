{
  homeManagerModule =
    { config, lib, ... }:
    let
      accounts = [
        {
          name = "metalbear";
          address = "viniciusd@metalbear.com";
          flavor = "gmail.com";
          color = "#deddda";

          calendar = true;
        }
        {
          name = "social";
          address = "social@vini.cat";
          flavor = "purelymail.com";
          color = "#73b6e6";

          calendar = true;
          contacts = true;

          webdavId = "280603";
        }
        {
          name = "dev";
          address = "dev@vini.cat";
          flavor = "purelymail.com";
          color = "#b6e673";

          webdavId = "276495";
        }
        {
          name = "work";
          address = "work@vini.cat";
          flavor = "purelymail.com";
          color = "#bf73e6";

          calendar = true;

          webdavId = "280601";
        }
        {
          name = "contact";
          address = "contact@vini.cat";
          flavor = "purelymail.com";
          color = "#e67373";

          webdavId = "280620";
        }
      ];
    in
    {
      programs.thunderbird = {
        enable = true;

        settings = {
          "widget.gtk.global-menu.enabled" = true;
          "widget.gtk.global-menu.wayland.enabled" = true;

          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };

        profiles.default = {
          isDefault = true;

          # Thunderbird keeps account colors in folderTree.json, which it rewrites at runtime, so set
          # the CSS variables that it would derive from that file instead. Home Manager names each
          # server `server_<sha256 of the account name>`.
          userChrome = ''
            :root {
            ${
              accounts
              |> lib.map (
                account: "  --server-server_${builtins.hashString "sha256" account.name}-color: ${account.color};"
              )
              |> lib.concatLines
            }}
          '';

          accountsOrder = [
            "metalbear"
            "social"
            "dev"
            "work"
            "contact"
          ];

          calendarAccountsOrder = [
            "metalbear"
            "social"
            "work"
          ];

          unifiedFolders.enable = true;

          feedAccounts.feed = { };
        };
      };

      accounts = {
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
                if account.flavor == "purelymail.com" then
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
            ${account.name} = lib.mergeAttrsList [
              {
                thunderbird = {
                  enable = true;
                  color = account.color or "";
                };
              }
              (
                if account.flavor == "purelymail.com" then
                  {
                    remote = {
                      type = "caldav";
                      url = "https://purelymail.com/webdav/${account.webdavId}/caldav/${account.name}/";
                      userName = account.address;
                    };
                  }
                else if account.flavor == "gmail.com" then
                  {
                    remote = {
                      type = "caldav";
                      url = "https://apidata.googleusercontent.com/caldav/v2/${account.address}/events";
                      userName = account.address;
                    };
                  }
                else
                  throw "Unsupported account flavor"
              )
            ];
          })
          |> lib.mergeAttrsList;

        contact.accounts =
          accounts
          |> lib.filter (account: account.contacts or false)
          |> lib.map (account: {
            ${account.name} = lib.mergeAttrsList [
              {
                thunderbird.enable = true;
              }
              (
                if account.flavor == "purelymail.com" then
                  {
                    remote = {
                      type = "carddav";
                      url = "https://purelymail.com/webdav/${account.webdavId}/carddav/default/";
                      userName = account.address;
                    };
                  }
                else
                  throw "Unsupported account flavor"
              )
            ];
          })
          |> lib.mergeAttrsList;
      };

      xdg = {
        mimeApps.defaultApplications = lib.genAttrs [
          # Mail
          "message/rfc822"
          "x-scheme-handler/mailto"
          "x-scheme-handler/mid"

          # Calendars
          "text/calendar"
          "x-scheme-handler/webcal"
          "x-scheme-handler/webcals"

          # Feeds
          "application/rss+xml"
          "x-scheme-handler/feed"
        ] (_: "thunderbird.desktop");

        autostart.entries = [
          "${config.programs.thunderbird.finalPackage}/share/applications/thunderbird.desktop"
        ];
      };
    };
}
