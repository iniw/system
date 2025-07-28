let
  systemModule =
    { user, pkgs, ... }:
    {
      programs.zsh.enable = true;
      environment.shells = [ pkgs.zsh ];
      users.users.${user}.shell = pkgs.zsh;
    };
in
{
  darwinModule = systemModule;

  nixosModule = systemModule;

  homeModule =
    { config, ... }:
    {

      programs.nushell = {
        enable = true;

        configFile.source = ./config/config.nu;
        envFile.source = ./config/env.nu;

        # See: https://github.com/nix-community/home-manager/issues/4313
        shellAliases = config.home.shellAliases;
        environmentVariables = config.home.sessionVariables;
      };

      programs.zsh = {
        enable = true;
        # Run nushell when launching an interactive shell.
        # Inspired by: https://github.com/NixOS/nixpkgs/issues/297449#issuecomment-2009853257
        # See also: https://nixos.wiki/wiki/Fish#Setting_fish_as_your_shell
        #           https://wiki.archlinux.org/title/Fish#System_integration
        #           https://wiki.gentoo.org/wiki/Fish#Caveats
        initContent =
          # sh
          ''
            if [[ ! $(ps -T -o "comm" | tail -n +2 | grep "nu$") && -z $ZSH_EXECUTION_STRING ]]; then
                if [[ -o login ]]; then
                    LOGIN_OPTION='--login'
                else
                    LOGIN_OPTION='''
                fi
                exec nu "$LOGIN_OPTION"
            fi
          '';
      };

      # Disable zsh's "last login" message
      home.file.".hushlogin".text = "";
    };
}
