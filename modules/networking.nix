{
  systemModule = { hostName, ... }: {
    networking = { inherit hostName; };
  };

  homeManagerModule = {
    programs.ssh = {
      enable = true;

      enableDefaultConfig = false;

      settings = {
        "*" = {
          ControlMaster = "auto";
          ControlPath = "~/.ssh/master-%r@%h:%p";
          ControlPersist = "10m";
          ForwardAgent = false;
          ServerAliveInterval = 60;
        };
      };
    };

    services.ssh-agent.enable = true;
  };
}
