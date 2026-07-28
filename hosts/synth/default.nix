sys:
sys.nixosSystem (
  { user, modulesPath, ... }:
  {
    imports = [ "${modulesPath}/virtualisation/lxc-container.nix" ];

    time.timeZone = "America/Sao_Paulo";

    home-manager.users.${user} = {
      dconf.enable = false;
      home.stateVersion = "26.11";
    };

    system.stateVersion = "26.11";
  }
)
