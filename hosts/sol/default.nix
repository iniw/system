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
        # Managed by determinate nix
        nix.enable = false;

        # For work
        homebrew.casks = [
          "android-studio"
          "notion"
        ];

        security.pam.services.sudo_local.touchIdAuth = true;

        home-manager.users.${user}.home.stateVersion = "25.05";

        system = {
          defaults = {
            dock.tilesize = 32;

            trackpad = {
              Clicking = true;
              TrackpadThreeFingerDrag = true;
            };
          };

          stateVersion = 5;
        };
      };
  };
}
