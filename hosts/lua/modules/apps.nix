{
  homeManagerModule =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        cmus
        cmusfm

        obs-studio
      ];
    };
}
