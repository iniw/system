{
  homeManagerModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      discord
      firefox
      obs-studio
      spotify
      wl-clipboard
    ];
  };
}
