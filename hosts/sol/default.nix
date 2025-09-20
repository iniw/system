sys:
sys.darwinSystem (
  { user, ... }:
  {
    # Managed by determinate nix.
    nix.enable = false;

    homebrew.brews = [
      "docker"
    ];

    homebrew.casks = [
      "notion"
      "stremio"
      "qobuz"
      "zoom"
      "docker-desktop"
    ];

    system.defaults.dock.tilesize = 32;

    home-manager.users.${user}.home.stateVersion = "25.05";
    system.stateVersion = 5;
  }
)
