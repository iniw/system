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
              echo "if ('__HM_SESS_VARS_SOURCED' not-in \$env) or (('__NIXOS_SET_ENVIRONMENT_DONE' not-in \$env) and ('__NIX_DARWIN_SET_ENVIRONMENT_DONE' not-in \$env)) { ''$(${lib.getExe pkgs.nushell} -c "
                use ${pkgs.nu_scripts}/share/nu_scripts/modules/capture-foreign-env
                with-env {
                  HOME: ${config.home.homeDirectory}
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
          '';
      };

      # Setting `XDG_CONFIG_HOME` is required to avoid looking for the config in `~/Library/Application Support`
      # See also: https://www.nushell.sh/book/configuration.html#startup-variables
      programs.ghostty.settings.command = "/usr/bin/env XDG_CONFIG_HOME=${config.home.sessionVariables.XDG_CONFIG_HOME} ${lib.getExe pkgs.nushell}";

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
