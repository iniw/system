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
  };

  # ssh rejects ~/.ssh/config if its owner is not the user or root. Apps wrapped with `buildFHSEnv` (e.g. Claude
  # Desktop) run in a bwrap user namespace that maps only the user's uid, so there root-owned /nix/store files show as
  # owned by `nobody`, and a symlink into the store fails. Install a copy that the user owns instead.
  nixosHomeManagerModule = { config, lib, ... }: {
    home.file.".ssh/config".enable = false;

    home.activation.sshConfig =
      let
        source = config.home.file.".ssh/config".source;
        target = "${config.home.homeDirectory}/.ssh/config";
      in
      lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        run install -D -m 600 ${source} ${target}
      '';
  };
}
