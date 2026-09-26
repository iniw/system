{
  homeManagerModule =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.thunderbird = {
        enable = true;

        # FIXME: Remove once https://github.com/NixOS/nixpkgs/pull/567009 is merged
        package = pkgs.thunderbird.overrideAttrs (old: {
          makeWrapperArgs = old.makeWrapperArgs ++ [
            "--prefix"
            "LD_LIBRARY_PATH"
            ":"
            (lib.makeLibraryPath [ pkgs.libdbusmenu-gtk3 ])
          ];
        });

        settings = {
          "widget.gtk.global-menu.enabled" = true;
          "widget.gtk.global-menu.wayland.enabled" = true;
        };

        profiles.default = {
          isDefault = true;

          accountsOrder = [
            "metalbear"
            "social"
            "dev"
            "work"
            "contact"
          ];

          unifiedFolders.enable = true;

          calendarAccountsOrder = [
            "metalbear"
            "social"
            "work"
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

              color = "#e6bf73";
            }
            {
              name = "social";
              address = "social@vini.cat";
              flavor = "purelymail.com";

              calendar = true;
              contacts = true;

              webdavId = "280603";
              color = "#73b6e6";
            }
            {
              name = "dev";
              address = "dev@vini.cat";
              flavor = "purelymail.com";

              webdavId = "276495";
              color = "#b6e673";
            }
            {
              name = "work";
              address = "work@vini.cat";
              flavor = "purelymail.com";

              calendar = true;
              contacts = true;

              webdavId = "280601";
              color = "#bf73e6";
            }
            {
              name = "contact";
              address = "contact@vini.cat";
              flavor = "purelymail.com";

              webdavId = "280620";
              color = "#e67373";
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
                        url = "https://purelymail.com/webdav/${account.webdavId}/caldav/default/";
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

      xdg.autostart.entries = [
        "${config.programs.thunderbird.finalPackage}/share/applications/thunderbird.desktop"
      ];
    };
}
