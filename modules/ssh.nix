{
  homeManagerModule =
    let
      signingKey = "~/.ssh/id_ed25519.pub";
    in
    {
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
