sys:
sys.nixosSystem (
  { user, modulesPath, ... }:
  {
    imports = [ "${modulesPath}/virtualisation/lxc-container.nix" ];

    security.sudo.wheelNeedsPassword = false;

    time.timeZone = "America/Sao_Paulo";

    system.stateVersion = "26.05";
    home-manager.users.${user}.home.stateVersion = "26.05";
  }
)
