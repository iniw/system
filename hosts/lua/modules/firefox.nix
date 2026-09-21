{
  homeManagerModule =
    { config, pkgs, ... }:
    {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox.override {
          nativeMessagingHosts = [ pkgs.gnome-browser-connector ];
        };
      };

      xdg.autostart.entries = [
        "${config.programs.firefox.finalPackage}/share/applications/firefox.desktop"
      ];
    };
}
