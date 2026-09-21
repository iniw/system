{
  homeManagerModule =
    { osConfig, ... }:
    {
      xdg.autostart.entries = [
        "${osConfig.programs._1password-gui.package}/share/applications/1password.desktop"
      ];
    };
}
