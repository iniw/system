{
  systemModule = {
    services.openssh.enable = true;
  };

  homeModule = {
    programs.ssh = {
      enable = true;

      addKeysToAgent = "confirm";

      matchBlocks = {
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

  nixosHomeModule = {
    services.ssh-agent.enable = true;
  };
}
