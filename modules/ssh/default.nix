{
  systemModule = {
    services.openssh.enable = true;
  };

  homeModule = {
    programs.ssh = {
      enable = true;
      addKeysToAgent = "confirm";

      matchBlocks = {
        # https://man.sr.ht/tutorials/set-up-account-and-git.md#specifying-a-key
        "*sr.ht" = {
          identityFile = "~/.ssh/id_ed25519.sourcehut";
          extraOptions.PreferredAuthentications = "publickey";
        };
      };
    };
  };

  nixosHomeModule = {
    services.ssh-agent.enable = true;
  };
}
