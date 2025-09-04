{
  homeModule =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        discord
        google-chrome
      ];
    };
}
