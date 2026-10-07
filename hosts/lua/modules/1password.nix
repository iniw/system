{
  homeManagerModule =
    { osConfig, ... }:
    {
      xdg.autostart.entries = [
        "${osConfig.programs._1password-gui.package}/share/applications/com.onepassword.OnePassword.desktop"
      ];
    };
}
