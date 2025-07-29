{
  darwinSystemModule = {
    security.pam.services.sudo_local.touchIdAuth = true;

    system = {
      defaults = {
        NSGlobalDomain = {
          _HIHideMenuBar = true;

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

  nixosSystemModule = {
    services.xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  nixosHomeModule =
    { lib, ... }:
    {
      dconf = {
        enable = true;

        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            font-hinting = "full";
            font-antialiasing = "rgba";
          };

          "org/gnome/desktop/session" = {
            idle-delay = lib.hm.gvariant.mkUint32 0;
          };

          "org/gnome/shell" = {
            favorite-apps = [
              "google-chrome.desktop"
              "com.mitchellh.ghostty.desktop"
              "discord.desktop"
              "spotify.desktop"
            ];
          };
        };
      };
    };
}
