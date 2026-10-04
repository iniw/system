{
  systemModule = {
    programs = {
      _1password.enable = true;
      _1password-gui.enable = true;
    };
  };

  homeManagerModule =
    {
      config,
      osConfig,
      pkgs,
      ...
    }:
    let
      ssh-agent-socket =
        let
          home = config.home.homeDirectory;
        in
        if pkgs.stdenv.hostPlatform.isDarwin then
          "${home}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
        else
          "${home}/.1password/agent.sock";

      commit-signing = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNGcLtjqxIbJpTB1fT8ou1XRu4K9kPTneAIE23eF5z8";
        program =
          let
            pkg = osConfig.programs._1password-gui.package;
          in
          if pkgs.stdenv.hostPlatform.isDarwin then
            "${pkg}/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
          else
            "${pkg}/bin/op-ssh-sign";
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
            behavior = "drop";
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

      programs.ssh.settings."*".IdentityAgent = ''"${ssh-agent-socket}"''; # Quoted because the macos path has a space.
      home.sessionVariables.SSH_AUTH_SOCK = ssh-agent-socket;
    };
}
