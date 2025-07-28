{
  systemModule = {
    services.openssh.enable = true;
  };

  homeModule =
    { pkgs, ... }:
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
