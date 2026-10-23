{
  systemModule = { hostName, user, ... }: {
    networking = { inherit hostName; };

    services.tailscale.enable = true;

    # The `login` key in 1Password's `Dev` vault, kept apart from the commit signing key.
    users.users.${user}.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPPtZoW52yZ80MOo1JvwwguISEPETJsd+wztEiWyWEfp"
    ];
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
  };
}
