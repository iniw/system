{
  darwinSystemModule = {
    homebrew.casks = [ "ticktick" ];
  };

  nixosHomeModule =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.ticktick ];
    };
}
