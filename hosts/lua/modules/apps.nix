{
  homeManagerModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      discord
      firefox
      obs-studio
      wl-clipboard
    ];
  };
}
