{
  homeManagerModule = { pkgs, ... }: {
    home.packages = [ pkgs.spotify ];
    xdg.autostart.entries = [ "${pkgs.spotify}/share/applications/spotify.desktop" ];
  };
}
