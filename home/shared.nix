{
  lib,
  pkgs,
  pkgs-unstable,
  config,
  ...
}:
{
  fonts.fontconfig.enable = true;

  home = {
    shellAliases = {
      lg = "lazygit";
    };

    packages =
      with pkgs;
      with nodePackages;
      [
        # apps
        discord

        # tools
        coreutils
        exiftool
        hyperfine
        just
        klip
        scc
        zlib

        # fonts
        inter

        # nix
        nil
        nixfmt-rfc-style
      ];

    stateVersion = "24.11";
  };

  xdg = {
    enable = true;

    configFile = {
      "nvim" = {
        source = ./nvim;
        recursive = true;
      };

      "starship.toml" = {
        source = ./starship/starship.toml;
      };
    };
  };

  programs = {
    bat = {
      enable = true;

      config = {
        theme = "ansi";
      };
    };

    btop = {
      enable = true;

      settings = {
        color_theme = "TTY";
        vim_keys = true;
      };
    };

    carapace = {
      enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    fd = {
      enable = true;
    };

    fzf = {
      enable = true;

      # Use fd instead of find.
      changeDirWidgetCommand = ''fd --type d --hidden --follow --exclude ".git"'';
      defaultCommand = ''fd --hidden --follow --exclude ".git"'';
      fileWidgetCommand = ''fd --hidden --follow --exclude ".git"'';
    };

    gh = {
      enable = true;
    };

    git = {
      enable = true;

      userName = "Vinicius Deolindo";
      userEmail = "andrade.vinicius934@gmail.com";

      delta = {
        enable = true;
        options = {
          navigate = true;
          line-numbers = true;
        };
      };

      extraConfig = {
        pull = {
          rebase = true;
        };
      };

      ignores = [
        ".DS_Store"
        "**/.DS_Store"

        # Project-specific lazyvim config
        ".lazy.lua"

        # direnv
        ".envrc"
        ".direnv/"

        # fd's ignore list
        ".ignore"

        # just's recipe list
        ".justfile"
      ];
    };

    home-manager = {
      enable = true;
    };

    lazygit = {
      enable = true;
    };

    neovim = {
      enable = true;

      defaultEditor = true;

      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
      ];
    };

    nushell = {
      enable = true;

      configFile.source = ./nushell/config.nu;
      envFile.source = ./nushell/env.nu;

      # See: https://github.com/nix-community/home-manager/issues/4313
      shellAliases = config.home.shellAliases;
      environmentVariables = config.home.sessionVariables;
    };

    ripgrep = {
      enable = true;
    };

    starship = {
      enable = true;
    };

    yazi = {
      enable = true;
      package = pkgs-unstable.yazi;
    };

    zoxide = {
      enable = true;
    };

    zsh = {
      enable = true;
      # Run nushell when launching an interactive shell.
      # Inspired by: https://github.com/NixOS/nixpkgs/issues/297449#issuecomment-2009853257
      # See also: https://nixos.wiki/wiki/Fish#Setting_fish_as_your_shell
      #           https://wiki.archlinux.org/title/Fish#System_integration
      #           https://wiki.gentoo.org/wiki/Fish#Caveats
      initExtra = ''
        if [[ ! $(ps -T -o "comm" | tail -n +2 | grep "nu$") && -z $ZSH_EXECUTION_STRING ]]; then
            if [[ -o login ]]; then
                LOGIN_OPTION='--login'
            else
                LOGIN_OPTION='''
            fi
            exec "${lib.getExe pkgs.nushell}" "$LOGIN_OPTION"
        fi
      '';
    };
  };
}
