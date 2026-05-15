{
  homeManagerModule =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        cmus
        cmusfm
        discord
        obs-studio
      ];
    };
}
