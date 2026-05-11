{
  homeManagerModule =
    { pkgs, lib, ... }:
    {
      programs =
        let
          nu = lib.getExe pkgs.nushell;
          zsh = lib.getExe pkgs.zsh;
        in
        {
          nushell = {
            enable = true;

            configFile.source = ./config.nu;
          };

          zsh = {
            enable = true;

            enableCompletion = false;
            initContent = # zsh
              ''
                if [[ -o interactive ]] && \
                  [[ -z "$ZSH_EXECUTION_STRING" ]] && \
                  [[ "$TERM" != "dumb" ]] && \
                  [[ ! "$(ps -p $PPID -o comm=)" =~ '(^|/)nu(shell)?$' ]];
                then
                  if [[ -o login ]]; then
                    exec ${nu} --login
                  else
                    exec ${nu}
                  fi
                fi
              '';
          };

          ghostty.settings.command = "direct:${zsh} -c ${nu}";
        };

      home = {
        shell.enableZshIntegration = false;
        file.".hushlogin".text = "";
      };
    };

  systemModule =
    { pkgs, user, ... }:
    {
      programs.zsh.enable = true;
      environment.shells = [ pkgs.zsh ];
      users.users.${user}.shell = pkgs.zsh;

      environment.pathsToLink = [ "/share/nushell" ];
    };
}
