{
  homeManagerModule = { config, ... }: {
    programs.ghostty.settings = {
      font-size = 12;
      maximize = true;
      window-decoration = "none";
    };

    xdg.autostart.entries = [
      "${config.programs.ghostty.package}/share/applications/com.mitchellh.ghostty.desktop"
    ];
  };
}
