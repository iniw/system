{
  homeManagerModule =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        discord
      ];
    };
}
