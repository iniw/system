{
  systemModule = {
    services.openssh.enable = true;
  };

  homeModule = {
    programs.ssh = {
      enable = true;
      addKeysToAgent = "confirm";
    };
  };

  nixosHomeModule = {
    services.ssh-agent.enable = true;
  };
}
