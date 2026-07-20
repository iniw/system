{
  systemModule =
    { user, ... }:
    {
      nix = {
        gc.automatic = true;

        settings = {
          auto-optimise-store = true;

          experimental-features = [
            "flakes"
            "nix-command"
            "pipe-operators"
          ];

          sandbox = true;

          trusted-users = [ user ];

          use-xdg-base-directories = true;
        };
      };
    };

  darwinSystemModule = {
    nix.gc.interval = {
      Hour = 0;
      Minute = 0;
      Weekday = 7;
    };
  };

  nixosSystemModule = {
    nix.gc.dates = "weekly";
  };
}
