{
  homeModule =
    {
      config,
      osConfig,
      pkgs,
      lib,
      ...
    }:
    {
      programs.nushell = {
        enable = true;

        configFile.source = ./config/config.nu;

        envFile.text =
          let
            # Modified from: https://github.com/nix-community/home-manager/pull/6941
            environment = pkgs.runCommand "setup-env-vars.nu" { } ''
              echo "if (\$env.__HM_SESS_VARS_SOURCED? | is-empty) or ((\$env.__NIXOS_SET_ENVIRONMENT_DONE? | is-empty) and (\$env.__NIX_DARWIN_SET_ENVIRONMENT_DONE? | is-empty)) { ''$(${lib.getExe pkgs.nushell} -c "
                use ${pkgs.nu_scripts}/share/nu_scripts/modules/capture-foreign-env
                with-env {
                  HOME: ${config.home.path}
                  USER: ${config.home.username}
                } {
                  open ${osConfig.system.build.setEnvironment} ${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh | str join "\n" | capture-foreign-env | to nuon
                }
              ") | load-env}" >> "$out"
            '';
          in
          # nu
          ''
            source ${environment}
            hide-env -i SSH_AUTH_SOCK
          '';
      };

      programs.ghostty.settings.command =
        with config.home.sessionVariables;
        # Setting `XDG_CONFIG_HOME` is required to avoid looking for the config in `~/Library/Application Support`
        # See also: https://www.nushell.sh/book/configuration.html#startup-variables
        "env XDG_CONFIG_HOME=${XDG_CONFIG_HOME} XDG_DATA_HOME=${XDG_DATA_HOME} ${lib.getExe pkgs.nushell}";

      home.file.".hushlogin".text = "";
    };

  darwinSystemModule =
    { pkgs, user, ... }:
    {
      programs.zsh.enable = true;
      environment.shells = [ pkgs.zsh ];
      users.users.${user}.shell = pkgs.zsh;
    };

  darwinHomeModule = {
    programs.zsh.enable = true;
  };

  nixosHomeModule = {
    programs.bash.enable = true;
  };
}
