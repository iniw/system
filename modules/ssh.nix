{
  systemModule = {
    services.openssh.enable = true;

    programs = {
      _1password.enable = true;
      _1password-gui.enable = true;
    };
  };

  homeManagerModule =
    { pkgs, ... }:
    let
      socket =
        if pkgs.stdenv.isDarwin then
          ''~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock''
        else
          ''~/.1password/agent.sock'';

      signing = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNGcLtjqxIbJpTB1fT8ou1XRu4K9kPTneAIE23eF5z8";
        program =
          if pkgs.stdenv.isDarwin then
            "${pkgs._1password-gui}/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
          else
            "${pkgs._1password-gui}/bin/op-ssh-sign";
      };
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
              identityAgent = socket;
            };
          };
        };

        gh.settings.git_protocol = "ssh";

        git.signing = {
          format = "ssh";
          key = signing.key;
          signer = signing.program;
          signByDefault = true;
        };

        jujutsu.settings = {
          signing = {
            backend = "ssh";
            key = signing.key;
            backends.ssh.program = signing.program;
            behavior = "drop";
          };

          git.sign-on-push = true;
        };
      };

      xdg.configFile."1Password/ssh/agent.toml".source = (pkgs.formats.toml { }).generate "agent.toml" {
        ssh-keys = [ { vault = "Dev"; } ];
      };

      home.sessionVariables.SSH_AUTH_SOCK = socket;
    };
}
