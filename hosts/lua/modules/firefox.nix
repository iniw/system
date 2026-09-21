{
  homeManagerModule = { config, ... }: {
    programs.firefox = {
      enable = true;
    };

    xdg.autostart.entries = [
      "${config.programs.firefox.finalPackage}/share/applications/firefox.desktop"
    ];
  };
}
