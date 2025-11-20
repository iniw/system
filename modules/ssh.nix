{
  systemModule = {
    services.openssh.enable = true;
  };

  homeManagerModule =
    { pkgs, ... }:
    let
      signingKey = "~/.ssh/id_ed25519.pub";
    in
    {
      programs = {
        ssh = {
          enable = true;

          enableDefaultConfig = false;

          matchBlocks = {
            "*" = {
              forwardAgent = false;
              serverAliveInterval = 60;
              controlMaster = "auto";
              controlPath = "~/.ssh/master-%r@%h:%p";
              controlPersist = "10m";
            };
          };
        };

        gh.settings.git_protocol = "ssh";

        git.signing = {
          format = "ssh";
          key = signingKey;
          signByDefault = true;
        };

        jujutsu.settings = {
          signing = {
            backend = "ssh";
            behavior = "own";
            key = signingKey;
          };

          git.sign-on-push = true;
        };
      };

      services.ssh-agent.enable = true;
    };
}
