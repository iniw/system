{
  systemModule = {
    programs = {
      _1password.enable = true;
      _1password-gui.enable = true;
    };
  };

  homeManagerModule =
    { pkgs, ... }:
    let
      ssh-agent-socket =
        if pkgs.stdenv.hostPlatform.isDarwin then
          ''~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock''
        else
          "~/.1password/agent.sock";

      commit-signing = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNGcLtjqxIbJpTB1fT8ou1XRu4K9kPTneAIE23eF5z8";
        program =
          if pkgs.stdenv.hostPlatform.isDarwin then
            "${pkgs._1password-gui}/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
          else
            "${pkgs._1password-gui}/bin/op-ssh-sign";
      };
    in
    {
      programs = {
        git.signing = {
          format = "ssh";
          key = commit-signing.key;
          signer = commit-signing.program;
          signByDefault = true;
        };

        jujutsu.settings = {
          signing = {
            backend = "ssh";
            behavior = "own";
            key = commit-signing.key;
            backends.ssh.program = commit-signing.program;
          };

          git.sign-on-push = true;
        };
      };

      # https://developer.1password.com/docs/ssh/agent/config/
      xdg.configFile."1Password/ssh/agent.toml".text = # toml
        ''
          [[ssh-keys]]
          vault = "Dev"
        '';

      programs.ssh.settings."*".IdentityAgent = ssh-agent-socket;
      home.sessionVariables.SSH_AUTH_SOCK = ssh-agent-socket;
    };
}
