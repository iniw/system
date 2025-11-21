{
  homeManagerModule =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        discord
        nicotine-plus
      ];
    };
}
