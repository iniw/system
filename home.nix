{ config, pkgs, lib, user, ... }:
{
  fonts.fontconfig.enable = true;

  home = {
    file = {
      "./.config/nvim/" = {
        source = ./nvim;
        recursive = true;
      };

      "./config/nvim/lazy-lock.json" = {
        source = config.lib.file.mkOutOfStoreSymlink ./nvim/lazy-lock/lazy-lock.json;
      };

      "./.config/starship.toml" = {
        source = ./starship/starship.toml;
      };
    };

    packages = with pkgs; [
      # cpp
      clang_18
      clang-tools_18
      cmake
      ninja
      bazel_7
      bazelisk
      bazel-buildtools

      # python
      (python3.withPackages (python-modules: with python-modules; [
        pip
      ]))
      ruff
      poetry

      # rust
      rustup

      # js
      nodejs_22

      # apps
      discord

      # fonts
      inter

      # general
      coreutils
      zlib
    ];

    activation.neovim = lib.hm.dag.entryAfter ["linkGeneration"] ''
      #! /bin/bash
      NVIM_WRAPPER=/etc/profiles/per-user/${user}/bin/nvim
      STATE_DIR=~/.local/state/nix/
      STATE_FILE=$STATE_DIR/lazy-lock-checksum
      LOCK_FILE=~/.config/nvim/lazy-lock.json
      HASH=$(nix-hash --flat $LOCK_FILE)

      [ ! -d $STATE_DIR ] && mkdir -p $STATE_DIR
      [ ! -f $STATE_FILE ] && touch $STATE_FILE

      if [ "$(cat $STATE_FILE)" != "$HASH" ]; then
        echo "Syncing neovim plugins"
        PATH="$PATH:${pkgs.git}/bin" $DRY_RUN_CMD $NVIM_WRAPPER --headless "+Lazy! restore" +qa
        $DRY_RUN_CMD echo $HASH >$STATE_FILE
      else
        $VERBOSE_ECHO "Neovim plugins already synced, skipping"
      fi
    '';

    sessionVariables = {
      ANDROID_HOME = "$HOME/Library/Android/sdk";
    };

    stateVersion = "24.05";
  };


  programs = {
    alacritty = {
      enable = true;

      settings = {
        font = {
          size = 18.0;

          normal.family = "Berkeley Mono";
          bold.family = "Berkeley Mono";
          italic.family = "Berkeley Mono";
        };

        window = {
          padding.x = 0;
          padding.y = 0;
          option_as_alt = "OnlyLeft";
        };
      };
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
    };

    eza = {
      enable = true;
    };

    fzf = {
      enable = true;
    };

    gh = {
      enable = true;
    };

    git = {
      enable = true;

      userName = "iniw";
      userEmail = "andrade.vinicius934@gmail.com";

      ignores = [
        ".DS_Store"
        "**/.DS_Store"
      ];
    };

    git-credential-oauth = {
      enable = true;
    };

    java = {
      enable = true;
      package = pkgs.jre;
    };

    home-manager = {
      enable = true;
    };

    neovim = {
      enable = true;

      defaultEditor = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    starship = {
      enable = true;
    };

    zellij = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        theme = "catppuccin-frappe";
        default_layout = "compact";
        pane_frames = false;
      };
    };

    vscode = {
      enable = true;
    };

    zsh = {
      enable = true;

      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        gs = "git status";
        gd = "git diff";
        glo = "git log --oneline";
        gap = "git add -p";
        gca = "git commit --amend";
        gpr = "git pull --rebase";
        gpf = "git push --force-with-lease";

        et = "eza -T";
        et1 = "eza -T -L1";

        cfg = "cd ~/.config/system";
        src = "cd ~/src";
        puc = "cd ~/puc";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [ "sudo" ];
      };

      # fix for slow copy-paste
      initExtra = ''
        autoload -Uz bracketed-paste-magic
        zle -N bracketed-paste bracketed-paste-magic
        zstyle ':bracketed-paste-magic' active-widgets '.self-*'

        bindkey -r '^T'
        bindkey '^F' fzf-file-widget
      '';

      envExtra = ''
        export PATH=$PATH:/usr/local/mysql/bin/
      '';
    };
  };
}
