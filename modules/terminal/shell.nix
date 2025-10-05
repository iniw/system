{
  homeManagerModule =
    {
      config,
      osConfig,
      user,
      pkgs,
      lib,
      ...
    }:
    {
      programs = {
        nushell.configFile.source = ./nushell/config.nu;

        # Use nu as the interactive shell
        ghostty.settings.command =
          let
            shell = lib.getExe osConfig.users.users.${user}.shell;
            nu = lib.getExe pkgs.nushell;
          in
          "${shell} -l -c '${nu} $0' -l";

        nushell.enable = true;
        zsh.enable = true;
        bash.enable = true;
      };

      home.file.".hushlogin".text = "";
    };

  systemModule =
    { pkgs, user, ... }:
    {
      programs = {
        zsh.enable = true;
        bash.enable = true;
      };

      environment.shells = [
        pkgs.zsh
        pkgs.bash
      ];

      users.users.${user}.shell = if pkgs.stdenv.isDarwin then pkgs.zsh else pkgs.bash;
    };
}
