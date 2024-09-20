{
  lib,
  pkgs,
  minimal-tmux,
  ...
}:
{
  fonts.fontconfig.enable = true;

  home = {
    # Copy over `lazy{-lock,vim}.json` to the nvim's config folder, if they don't exist.
    # This guarantees version stability when installing the flake on fresh systems while also leaving the version management itself to lazy, 
    # since the file is not a read-only link to the nix-store.
    # This, paired with the post-commit hook in the git repo, gives us effective and simple two-way synchronization between lazy and nix.
    activation.neovim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # `--no-preserve=all` makes the output files writeable.

      if [ ! -f ~/.config/nvim/lazy-lock.json ]; then
        cp --no-preserve=all ~/.config/nvim/lazy/lazy-lock.json ~/.config/nvim/lazy-lock.json
        echo "Placed lazy-lock"
      fi

      if [ ! -f ~/.config/nvim/lazyvim.json ]; then
        cp --no-preserve=all ~/.config/nvim/lazy/lazyvim.json ~/.config/nvim/lazyvim.json
        echo "Placed lazyvim"
      fi
    '';

    file = {
      "./.config/nvim/" = {
        source = ./nvim;
        recursive = true;
      };

      "./.config/starship.toml" = {
        source = ./starship/starship.toml;
      };
    };

    packages = with pkgs; [
      # tools
      coreutils
      moreutils
      zlib
      cloc
      wget
      ast-grep
      tldr

      # fonts
      inter

      # nix
      nixfmt-rfc-style
      nil

      # lua
      luajit
      luajitPackages.luarocks
      lua-language-server
      stylua

      nodejs_22
    ];

    shellAliases = {
      gs = "git status";
      gd = "git diff";
      glo = "git log --oneline";
      gap = "git add -p";
      gaa = "git add --all";
      gc = "git commit";
      gca = "git commit --amend";
      gpr = "git pull --rebase";
      gpf = "git push --force-with-lease";

      ls = "eza -1 --icons=always";
      la = "ls -a";

      bat = "bat --number --color=always --wrap=never";
    };

    stateVersion = "24.11";
  };

  programs = {
    alacritty = {
      enable = true;

      settings = {
        font = {
          size = 15.0;

          # TODO: install this font with the flake.
          normal.family = "BerkeleyMono Nerd Font Mono";
        };

        window = {
          option_as_alt = "OnlyLeft";
        };

        colors = {
          primary = {
            background = "#121212";
          };
        };
      };
    };

    bat = {
      enable = true;
    };

    btop = {
      enable = true;
      settings = {
        color_theme = "TTY";
        vim_keys = true;
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
    };

    fd = {
      enable = true;
    };

    fzf = {
      enable = true;

      # Use fd instead of find. Way faster.
      changeDirWidgetCommand = "fd --type d";
      defaultCommand = "fd --type f";
      fileWidgetCommand = "fd --type f";
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
      ];
    };

    git-credential-oauth = {
      enable = true;
    };

    home-manager = {
      enable = true;
    };

    jq = {
      enable = true;
    };

    lazygit = {
      enable = true;
    };

    neovim = {
      enable = true;

      defaultEditor = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    ripgrep = {
      enable = true;
    };

    starship = {
      enable = true;
    };

    tmux = {
      enable = true;

      baseIndex = 1;
      disableConfirmationPrompt = true;
      escapeTime = 0;
      keyMode = "vi";
      terminal = "screen-256color";
      shortcut = "t";

      extraConfig = ''
        # Don't enter a login shell on new panes/windows.
        set -g default-command "''${SHELL}" 
        set-option -a terminal-features 'alacritty:RGB'
        set-option -a terminal-features 'xterm-256color:RGB'
      '';

      plugins = with pkgs; [
        {
          plugin = minimal-tmux.packages.${pkgs.system}.default;
          extraConfig = ''
            set -g @minimal-tmux-bg "#ff265c"
            set -g @minimal-tmux-status-right-extra " %H:%M"
          '';
        }
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60'
          '';
        }
      ];
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
    };

    zsh = {
      enable = true;

      enableCompletion = true;
      enableVteIntegration = true;

      autosuggestion.enable = true;
      oh-my-zsh.enable = true;
      syntaxHighlighting.enable = true;

      initExtra = ''
        # Fixes slow zsh copy-paste.
        # From: https://github.com/zsh-users/zsh-autosuggestions/issues/238#issuecomment-389324292
        pasteinit() {
            OLD_SELF_INSERT=''\${''\${(s.:.)widgets[self-insert]}[2,3]}
            zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
        }

        pastefinish() {
            zle -N self-insert $OLD_SELF_INSERT
        }

        zstyle :bracketed-paste-magic paste-init pasteinit
        zstyle :bracketed-paste-magic paste-finish pastefinish

        # Tmux uses <C-t> so make fzf use <C-f> instead.
        bindkey -r '^T'
        bindkey '^F' fzf-file-widget
      '';
    };
  };
}
