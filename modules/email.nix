{
  homeManagerModule =
    { pkgs, lib, ... }:
    {
      programs.thunderbird = {
        enable = true;

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
        };
      };

      accounts =
        let
          domain = "vini.cat";
        in
        {
          email.accounts =
            [
              "social"
              "git"
              "work"
              "contact"
            ]
            |> lib.map (account: {
              ${account} = rec {
                address = "${account}@${domain}";

                userName = address;
                realName = "Vinicius Deolindo";

                primary = account == "social";

                smtp = {
                  host = "smtp.purelymail.com";
                  port = 465;
                };

                imap = {
                  host = "imap.purelymail.com";
                  port = 993;
                };

                thunderbird.enable = true;
              };
            })
            |> lib.mergeAttrsList;

          calendar.accounts =
            [
              {
                name = "social";
                webdavId = "280603";
                color = "#5d42f5";
              }
              {
                name = "work";
                webdavId = "280601";
                color = "#f5425d";
              }
            ]
            |> lib.map (account: {
              ${account.name} = {
                primary = account.name == "social";

                remote = {
                  type = "caldav";
                  url = "https://purelymail.com/webdav/${account.webdavId}/caldav/default";
                  userName = "${account.name}@${domain}";
                };

                thunderbird = {
                  enable = true;
                  color = account.color;
                };
              };
            })
            |> lib.mergeAttrsList;
        };
    };
}
