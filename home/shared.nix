{
  pkgs,
  pkgs-unstable,
  config,
  ...
}:
{
  home = {
    file = {
      # Disable zsh's "last login" message
      ".hushlogin".text = "";
    };

    packages = with pkgs; [
      # Apps
      discord
      google-chrome
      # FIXME: Go back to stable once the app actually works on macos.
      pkgs-unstable.spotify

      # Tools
      ast-grep
      coreutils
      exiftool
      hyperfine
      jq
      just
      klip
      python314
      scc

      # Fonts
      berkeley-mono
      inter
      tx-02
    ];

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

      config = {
        global = {
          hide_env_diff = true;
          strict_env = true;
        };
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

      settings = {
        git_protocol = "ssh";
      };
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
        ".claude"
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
      package = pkgs-unstable.helix;

      defaultEditor = true;

      # System-wide LSP support for languages used everywhere.
      extraPackages = with pkgs-unstable; [
        # Nix
        nil
        nixfmt
        # Markdown
        marksman
        # Toml
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
