{
  homeManagerModule = { pkgs, ... }: {
    home.packages = [ pkgs.kubectl ];

    xdg.autostart.entries = [ "${pkgs.slack}/share/applications/slack.desktop" ];
  };
}
