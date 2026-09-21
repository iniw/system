{
  homeManagerModule = { config, ... }: {
    programs.ghostty.settings = {
      font-size = 12;
      maximize = true;
      window-decoration = "none";
    };

    qt.kde.settings.kdeglobals.General = {
      TerminalApplication = "ghostty";
      TerminalService = "com.mitchellh.ghostty.desktop";
    };

    xdg.autostart.entries = [
      "${config.programs.ghostty.package}/share/applications/com.mitchellh.ghostty.desktop"
    ];
  };
}
