{
  homeManagerModule = {
    programs.nushell = {
      enable = true;

      configFile.source = ./config.nu;
    };

    home.file.".hushlogin".text = "";
  };

  darwinHomeManagerModule = {
    programs.zsh = {
      enable = true;

      enableCompletion = false;

      initContent =
        # zsh
        ''
          if [[ -z $ZSH_EXECUTION_STRING && $TERM != dumb ]]; then
            exec nu --experimental-options native-clip
          fi
        '';
    };

    home.shell.enableZshIntegration = false;
  };

  nixosHomeManagerModule = {
    programs.bash = {
      enable = true;

      enableCompletion = false;

      initExtra =
        # bash
        ''
          if [[ -z $BASH_EXECUTION_STRING && $TERM != dumb ]]; then
            exec nu --experimental-options native-clip
          fi
        '';
    };

    home.shell.enableBashIntegration = false;
  };

  systemModule = {
    environment.pathsToLink = [ "/share/nushell" ];
  };

  darwinSystemModule = { pkgs, user, ... }: {
    programs.zsh = {
      enable = true;

      enableCompletion = false;
      enableBashCompletion = false;
    };

    environment.shells = [ pkgs.zsh ];
    users.users.${user}.shell = pkgs.zsh;
  };

  nixosSystemModule = { pkgs, user, ... }: {
    programs.bash = {
      enable = true;

      completion.enable = false;
    };

    environment.shells = [ pkgs.bashInteractive ];
    users.users.${user}.shell = pkgs.bashInteractive;
  };
}
