{
  lib,
  pkgs,
  pkgs-unstable,
  config,
  ...
}:
{
  home = {
    packages = with pkgs; [
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
      tx-02
      berkeley-mono
    ];

    shellAliases = {
      lg = "lazygit";
    };

    stateVersion = "24.11";
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

      nix-direnv = {
        enable = true;
      };
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

        # Project-specific lazyvim config
        ".lazy.lua"

        # direnv
        ".envrc"
        ".direnv/"

        # fd's ignore list
        ".ignore"

        "justfile"
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
      package = pkgs-unstable.neovim-unwrapped;

      defaultEditor = true;

      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
      ];

      extraPackages = with pkgs; [
        # For grug-far.nvim
        ast-grep

        # System-wide LSP support languages used everywhere.

        # nix
        nil
        nixfmt-rfc-style
        # lua
        lua-language-server
        stylua
        # markdown
        marksman
        markdownlint-cli2
        # toml
        taplo
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

    ssh = {
      enable = true;

      addKeysToAgent = "confirm";
    };

    starship = {
      enable = true;
    };

    wezterm = {
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
            exec nu "$LOGIN_OPTION"
        fi
      '';
    };
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

      "wezterm" = {
        source = ./wezterm;
        recursive = true;
      };
    };
  };

  fonts = {
    fontconfig = {
      enable = true;

      defaultFonts = {
        monospace = [ "Berkeley Mono" ];
        sansSerif = [ "Inter" ];
        serif = [ "Inter" ];
      };
    };
  };
}
