{
  systemModule = {
    services.openssh.enable = true;
  };

  homeModule =
    { lib, pkgs, ... }:
    {
      programs.ssh = {
        enable = true;
        addKeysToAgent = "confirm";
      };
    };

  nixosHomeModule = {
    services.ssh-agent.enable = true;
  };
}
