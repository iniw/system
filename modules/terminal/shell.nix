{
  homeManagerModule =
    { pkgs, lib, ... }:
    {
      programs = {
        nushell = {
          enable = true;
          configFile.source = ./nushell/config.nu;
        };

        zsh = {
          enable = true;
          initContent = # sh
            ''
              if [[ -z $ZSH_EXECUTION_STRING ]]; then
                  if [[ -o login ]]; then
                      LOGIN_OPTION='--login'
                  else
                      LOGIN_OPTION='''
                  fi
                  exec nu "$LOGIN_OPTION"
              fi
            '';
        };

        ghostty.settings.command =
          let
            zsh = lib.getExe pkgs.zsh;
            nu = lib.getExe pkgs.nushell;
          in
          "${zsh} -l -c '${nu} $0' -l";
      };

      home.file.".hushlogin".text = "";
    };

  systemModule =
    { pkgs, user, ... }:
    {
      programs.zsh.enable = true;
      environment.shells = [ pkgs.zsh ];
      users.users.${user}.shell = pkgs.zsh;
    };
}
