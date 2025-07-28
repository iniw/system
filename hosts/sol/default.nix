{
  name,
  inputs,
  sys,
}:
{
  darwinConfigurations.${name} = sys.darwinSystem {
    inherit (inputs.nix-darwin) lib;
    system = "x86_64-darwin";
    module =
      { user, ... }:
      {
        # Managed by determinate nix.
        nix.enable = false;

        # For work.
        homebrew.casks = [
          "android-studio"
          "notion"
        ];

        system.defaults.dock.tilesize = 32;

        home-manager.users.${user}.home.stateVersion = "25.05";
        system.stateVersion = 5;
      };
  };
}
