{
  systemModule =
    { user, ... }:
    {
      security.pam.services.sudo_local.touchIdAuth = true;

      system.defaults = {
        controlcenter = {
          BatteryShowPercentage = true;
          Bluetooth = true;
        };

        CustomSystemPreferences = {
          "com.apple.AdLib" = {
            allowApplePersonalizedAdvertising = false;
            allowIdentifierForAdvertising = false;
            personalizedAdsMigrated = false;
          };

          "com.apple.finder" = {
            FXArrangeGroupViewBy = "Name";
          };
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

          _FXSortFoldersFirst = true;
          FXDefaultSearchScope = "SCcf";
          FXEnableExtensionChangeWarning = false;
          FXPreferredViewStyle = "Nlsv";
          FXRemoveOldTrashItems = true;

          NewWindowTarget = "Home";

          ShowPathbar = true;

          QuitMenuItem = true;
        };

        LaunchServices = {
          LSQuarantine = false;
        };

        loginwindow = {
          DisableConsoleAccess = true;
          GuestEnabled = false;
        };

        menuExtraClock = {
          ShowSeconds = true;
        };

        NSGlobalDomain = {
          ApplePressAndHoldEnabled = false;
          AppleShowAllFiles = true;

          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;

          NSDocumentSaveNewDocumentsToCloud = false;
        };

        screencapture = {
          target = "clipboard";
        };

        screensaver = {
          askForPassword = true;
          askForPasswordDelay = 0;
        };
      };
    };
}
