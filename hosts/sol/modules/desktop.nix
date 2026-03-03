{
  systemModule =
    { user, ... }:
    {
      security.pam.services.sudo_local.touchIdAuth = true;

      system.defaults = {
        CustomSystemPreferences = {
          "com.apple.AdLib" = {
            allowApplePersonalizedAdvertising = false;
            allowIdentifierForAdvertising = false;
            personalizedAdsMigrated = false;
          };

          "com.apple.finder" = {
            FXArrangeGroupViewBy = "Name";
          };

          "com.apple.desktopservices" = {
            # Avoid creating .DS_Store files on network or USB volumes
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };
        };

        dock = {
          autohide = true;
          mru-spaces = false;
          show-recents = false;
          orientation = "bottom";
          showhidden = true;
          tilesize = 48;
          persistent-apps = [
            { app = "/Users/${user}/Applications/Home Manager Apps/Ghostty.app"; }
            { app = "/System/Cryptexes/App/System/Applications/Safari.app"; }
            { app = "/Users/${user}/Applications/Home Manager Apps/Discord.app"; }
            { app = "/Applications/WhatsApp.app"; }
            { app = "/System/Applications/Music.app"; }
            { app = "/System/Applications/Mail.app"; }
            { app = "/System/Applications/Calendar.app"; }
            { app = "/Users/${user}/Applications/Home Manager Apps/NetNewsWire.app"; }
            { app = "/Users/${user}/Applications/Home Manager Apps/Slack.app"; }
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
