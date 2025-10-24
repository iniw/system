{
  systemModule =
    { user, ... }:
    {
      security.pam.services.sudo_local.touchIdAuth = true;

      system = {
        defaults = {
          NSGlobalDomain = {
            AppleKeyboardUIMode = 3;
            ApplePressAndHoldEnabled = false;
            AppleShowAllFiles = true;

            NSAutomaticCapitalizationEnabled = false;
            NSAutomaticDashSubstitutionEnabled = false;
            NSAutomaticPeriodSubstitutionEnabled = false;
            NSAutomaticQuoteSubstitutionEnabled = false;
            NSAutomaticSpellingCorrectionEnabled = false;

            NSNavPanelExpandedStateForSaveMode = true;
            NSNavPanelExpandedStateForSaveMode2 = true;
          };

          dock = {
            autohide = true;
            mru-spaces = false;
            show-recents = false;
            orientation = "bottom";
            showhidden = true;
            tilesize = 32;
            persistent-apps = [
              { app = "/Users/${user}/Applications/Home Manager Apps/Ghostty.app"; }
              { app = "/Users/${user}/Applications/Home Manager Apps/Firefox.app"; }
              { app = "/Users/${user}/Applications/Home Manager Apps/Discord.app"; }
              { app = "/Applications/Qobuz.app"; }
              { app = "/Users/${user}/Applications/Home Manager Apps/Thunderbird.app"; }
              { app = "/Applications/Slack.app"; }
              { app = "/Applications/Linear.app"; }
            ];
          };

          finder = {
            AppleShowAllExtensions = true;
            AppleShowAllFiles = true;

            FXEnableExtensionChangeWarning = false;
            FXPreferredViewStyle = "clmv";

            QuitMenuItem = true;
          };
        };
      };
    };
}
