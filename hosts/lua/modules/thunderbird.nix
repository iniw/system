{
  homeManagerModule =
    { config, lib, ... }:
    let
      accounts = {
        metalbear = {
          address = "viniciusd@metalbear.com";
          flavor = "gmail.com";
          color = "#deddda";

          calendar = true;
        };

        social = {
          address = "social@vini.cat";
          flavor = "purelymail.com";
          color = "#73b6e6";

          calendar = true;
          contacts = true;

          webdavId = "280603";
        };

        dev = {
          address = "dev@vini.cat";
          flavor = "purelymail.com";
          color = "#b6e673";

          webdavId = "276495";
        };

        work = {
          address = "work@vini.cat";
          flavor = "purelymail.com";
          color = "#bf73e6";

          calendar = true;

          webdavId = "280601";
        };

        contact = {
          address = "contact@vini.cat";
          flavor = "purelymail.com";
          color = "#e67373";

          webdavId = "280620";
        };
      };
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
              |> lib.mapAttrsToList (
                name: account: "  --server-server_${builtins.hashString "sha256" name}-color: ${account.color};"
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
          |> lib.mapAttrs (
            name: account: {
              inherit (account) address flavor;

              realName = "Vinicius Deolindo";

              primary = name == "social";

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
          );

        calendar.accounts =
          accounts
          |> lib.filterAttrs (_: account: account.calendar or false)
          |> lib.mapAttrs (
            name: account: {
              remote = {
                type = "caldav";
                url =
                  if account.flavor == "purelymail.com" then
                    "https://purelymail.com/webdav/${account.webdavId}/caldav/${name}/"
                  else if account.flavor == "gmail.com" then
                    "https://apidata.googleusercontent.com/caldav/v2/${account.address}/events"
                  else
                    throw "Unsupported account flavor";
                userName = account.address;
              };

              thunderbird = {
                enable = true;
                color = account.color or "";
              };
            }
          );

        contact.accounts =
          accounts
          |> lib.filterAttrs (_: account: account.contacts or false)
          |> lib.mapAttrs (
            _: account: {
              remote = {
                type = "carddav";
                url =
                  if account.flavor == "purelymail.com" then
                    "https://purelymail.com/webdav/${account.webdavId}/carddav/default/"
                  else
                    throw "Unsupported account flavor";
                userName = account.address;
              };

              thunderbird.enable = true;
            }
          );
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
