{
  systemModule = {
    services.openssh.enable = true;
  };

  homeManagerModule = {
    programs.ssh = {
      enable = true;

      enableDefaultConfig = false;

      matchBlocks = {
        "*" = {
          forwardAgent = false;
          addKeysToAgent = "confirm";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };
        "*sr.ht" = {
          identityFile = "~/.ssh/id.sourcehut";
          extraOptions.PreferredAuthentications = "publickey";
        };
        "github.com" = {
          identityFile = "~/.ssh/id.github";
          extraOptions.PreferredAuthentications = "publickey";
        };
        "codeberg.org" = {
          identityFile = "~/.ssh/id.codeberg";
          extraOptions.User = "git";
          extraOptions.PreferredAuthentications = "publickey";
        };
      };
    };
  };

  nixosHomeManagerModule = {
    services.ssh-agent.enable = true;
  };
}
