{
  homeManagerModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      kind
      kubectl
    ];

    xdg.autostart.entries = [ "${pkgs.slack}/share/applications/slack.desktop" ];
  };
}
