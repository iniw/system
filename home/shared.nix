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
      # Apps
      discord
      google-chrome
      spotify

      # Tools
      aichat
      coreutils
      exiftool
      hyperfine
      just
      jq
      klip
      scc
      zlib
      # Very useful as a calculator REPL
      (python314.withPackages (
        py: with py; [
          sympy
        ]
      ))

      # Fonts
      berkeley-mono
      inter
      tx-02
    ];

    shellAliases = {
      ng = "nvim -c \"Neogit\"";
    };

    sessionVariables = {
      PAGER = "less -FRX";
    };

    stateVersion = "25.05";
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

      # Store direnv caches in a unified location
      # From: https://github.com/direnv/direnv/wiki/Customizing-cache-location#human-readable-directories
      stdlib =
        # sh
        ''
          : "''${XDG_CACHE_HOME:="''${HOME}/.cache"}"
          declare -A direnv_layout_dirs
          direnv_layout_dir() {
            local hash path
            echo "''${direnv_layout_dirs[$PWD]:=$(
              hash="$(sha1sum - <<< "$PWD" | head -c40)"
              path="''${PWD//[^a-zA-Z0-9]/-}"
              echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
            )}"
          }
        '';
    };

    fd = {
      enable = true;
    };

    fzf = {
      enable = true;

      # Use fd instead of find.
      changeDirWidgetCommand = ''fd --type d --hidden --follow --exclude ".git" --exclude ".jj"'';
      defaultCommand = ''fd --hidden --follow --exclude ".git" --exclude ".jj"'';
      fileWidgetCommand = ''fd --hidden --follow --exclude ".git" --exclude ".jj"'';
    };

    gh = {
      enable = true;
    };

    ghostty = {
      enable = true;
      package = if pkgs.stdenv.isDarwin then pkgs-unstable.ghostty-bin else pkgs-unstable.ghostty;
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
        core = {
          fsmonitor = true;
          untrackedcache = true;
        };

        diff = {
          algorithm = "histogram";
        };

        pull = {
          rebase = true;
        };

        push = {
          autoSetupRemote = true;
        };
      };

      ignores = [
        ".DS_Store"
        "justfile"
        # Project-specific lazy.nvim spec/config
        ".lazy.lua"
        # Project-specific helix config
        ".helix"
        # direnv
        ".envrc"
        # fd's ignore list
        ".ignore"
      ];
    };

    helix = {
      enable = true;
      # NOTE: The `helix` packaged is overlayed and points to the github repo.
      package = pkgs.helix;

      defaultEditor = true;

      extraPackages = with pkgs-unstable; [
        # System-wide LSP support for languages used everywhere.
        # nix
        nil
        nixfmt-rfc-style
        # lua
        lua-language-server
        stylua
        # markdown
        marksman
        # toml
        taplo
      ];
    };

    jujutsu = {
      enable = true;

      settings = {
        revset-aliases = {
          # I do a whole lot of force-pushing and history-rewriting, so immutable heads are really annoying.
          "immutable_heads()" = "none()";
        };

        user = {
          name = "Vinicius Deolindo";
          email = "andrade.vinicius934@gmail.com";
        };

        ui = {
          movement = {
            edit = true;
          };
        };
      };
    };

    neovim = {
      enable = true;
      package = pkgs-unstable.neovim-unwrapped;

      extraPackages = with pkgs-unstable; [
        # For `snacks.image`.
        imagemagick
        # To compile treesitter grammars.
        gcc
        tree-sitter

        # System-wide LSP support for languages used everywhere.
        # nix
        nil
        nixfmt-rfc-style
        # lua
        lua-language-server
        stylua
        # markdown
        marksman
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

    yazi = {
      enable = true;
      package = pkgs-unstable.yazi;

      keymap = {
        mgr.prepend_keymap = [
          {
            run = ''shell -- ya emit cd "$(git rev-parse --show-toplevel)"'';
            on = [
              "g"
              "r"
            ];
            desc = "Go to git root";
          }
        ];
      };
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
  };

  xdg = {
    enable = true;

    configFile = {
      "ghostty" = {
        source = ./ghostty;
        recursive = true;
      };

      "helix" = {
        source = ./helix;
        recursive = true;
      };

      "nvim" = {
        source = ./nvim;
        recursive = true;
      };

      "starship.toml" = {
        source = ./starship/starship.toml;
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
