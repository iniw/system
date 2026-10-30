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

      op-ssh-sign =
        let
          _1password-gui = osConfig.programs._1password-gui.package;
        in
        if pkgs.stdenv.hostPlatform.isDarwin then
          "${_1password-gui}/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
        else
          "${_1password-gui}/bin/op-ssh-sign";
    in
    {
      programs.ssh.settings."*".IdentityAgent = ''"${ssh-agent-socket}"''; # Quoted because the macos path has a space.
      home.sessionVariables.SSH_AUTH_SOCK = ssh-agent-socket;

      programs = {
        git.signing.signer = op-ssh-sign;
        jujutsu.settings.signing.backends.ssh.program = op-ssh-sign;
      };

      # https://developer.1password.com/docs/ssh/agent/config/
      xdg.configFile."1Password/ssh/agent.toml".text = # toml
        ''
          [[ssh-keys]]
          vault = "Dev"
        '';
    };
}
