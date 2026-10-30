let
  keys = {
    # Logs into the hosts in this repository.
    remote-access = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPPtZoW52yZ80MOo1JvwwguISEPETJsd+wztEiWyWEfp";

    # Signs commits.
    commit-signing = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNGcLtjqxIbJpTB1fT8ou1XRu4K9kPTneAIE23eF5z8";
  };
in
{
  systemModule = { hostName, user, ... }: {
    networking = { inherit hostName; };

    services = {
      openssh.enable = true;
      tailscale.enable = true;
    };

    users.users.${user}.openssh.authorizedKeys.keys = [ keys.remote-access ];
  };

  homeManagerModule = {
    programs = {
      ssh = {
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

      git.signing = {
        format = "ssh";
        key = keys.commit-signing;
        signByDefault = true;
      };

      jujutsu.settings = {
        signing = {
          backend = "ssh";
          behavior = "drop";
          key = keys.commit-signing;
        };

        git.sign-on-push = true;
      };
    };
  };
}
