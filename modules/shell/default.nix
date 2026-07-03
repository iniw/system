{
  homeManagerModule =
    { pkgs, lib, ... }:
    {
      programs =
        let
          nu = lib.getExe pkgs.nushell;
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
                if [[ -z $ZSH_EXECUTION_STRING && $TERM != dumb ]]; then
                  exec ${nu} --experimental-options native-clip
                fi
              '';
          };
        };

      home = {
        shell.enableZshIntegration = false;
        file.".hushlogin".text = "";
      };
    };

  systemModule =
    { pkgs, user, ... }:
    {
      programs.zsh = {
        enable = true;

        enableCompletion = false;
        enableBashCompletion = false;
      };

      environment.shells = [ pkgs.zsh ];
      users.users.${user}.shell = pkgs.zsh;

      environment.pathsToLink = [ "/share/nushell" ];
    };
}
