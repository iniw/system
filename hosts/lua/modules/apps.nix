{
  homeManagerModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      cmus
      cmusfm
      discord
      firefox
      obs-studio
      wl-clipboard
    ];
  };
}
