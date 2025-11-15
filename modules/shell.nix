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
            configFile.source = ./shell.config.nu;
          };

          zsh = {
            enable = true;
            initContent = "exec ${nu}";
          };

          ghostty.settings.command = "direct:${zsh} -c ${nu}";
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
