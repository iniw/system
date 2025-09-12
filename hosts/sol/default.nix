sys:
sys.darwinSystem (
  { user, ... }:
  {
    imports = [ ./hardware.nix ];

    # Managed by determinate nix.
    nix.enable = false;

    homebrew.casks = [
      "notion"
      "stremio"
      "qobuz"
      "zoom"
    ];

    system.defaults.dock.tilesize = 32;

    home-manager.users.${user}.home.stateVersion = "25.05";
    system.stateVersion = 5;
  }
)
