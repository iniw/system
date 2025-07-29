# The idea of this module is to set nushell as the default user-facing shell.
#
# The problem is that this is not really viable since unix systems/programs often expect Bourne-compatible user shells. (1)
#
# Another problem is that NixOS/Nix-Darwin don't natively support nushell (i.e: the don't have a `programs.nushell.enable`),
# this means that critical nix-related configuration files to set up the environment don't get sourced. (2)
#
# What we do instead is to set a normal default shell (zsh), then run nushell when interactively launching the shell.
#
# This fixes both problems - programs that expect the native shell for that system have their expectation met and the environment is passed along
# to the child nushell process from the main shell.
#
# 1: https://www.nushell.sh/book/default_shell.html#setting-nu-as-login-shell-linux-bsd-macos
#    https://wiki.gentoo.org/wiki/Fish#Caveats (Not specifically about nushell but ilustrates the point)
# 2: https://github.com/nix-darwin/nix-darwin/issues/1028
#    https://github.com/nix-community/home-manager/issues/6901
#    https://github.com/NixOS/nixpkgs/issues/297449
{
  systemModule =
    { user, pkgs, ... }:
    {
      programs.zsh.enable = true;
      environment.shells = [ pkgs.zsh ];
      users.users.${user}.shell = pkgs.zsh;
    };

  homeModule =
    { config, ... }:
    {
      programs.nushell = {
        enable = true;

        configFile.source = ./config/config.nu;
        envFile.source = ./config/env.nu;

        # See: https://github.com/nix-community/home-manager/issues/4313
        environmentVariables = config.home.sessionVariables;
      };

      programs.zsh = {
        enable = true;
        initContent =
          # From: https://github.com/NixOS/nixpkgs/issues/297449#issuecomment-2009853257
          # zsh
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

      # Disable zsh's "last login" message.
      home.file.".hushlogin".text = "";
    };
}
