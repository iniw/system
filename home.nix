{
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  fonts.fontconfig.enable = true;

  home = {
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
      # cpp
      clang_18
      clang-tools_18
      cmake
      ninja

      # python
      (python3.withPackages (python-modules: with python-modules; [ pip ]))
      pkgs-unstable.uv

      # rust
      rustup

      # js
      nodejs_22

      # apps
      discord

      # general
      coreutils
      zlib
      cloc
      wget

      # fp
      ocaml
      coq

      # java
      jdt-language-server

      # lua
      luajit
      luajitPackages.luarocks

      # fonts
      inter

      # other
      ast-grep
      nixfmt-rfc-style
      nodePackages.prettier
    ];

    activation.neovim = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ ! -f ~/.config/nvim/lazy-lock.json ]; then
          cp ~/.config/nvim/lazy/lazy-lock.json ~/.config/nvim/lazy-lock.json
          echo "Synced lazy-lock"
        fi

        if [ ! -f ~/.config/nvim/lazyvim.json ]; then
          cp ~/.config/nvim/lazy/lazyvim.json ~/.config/nvim/lazyvim.json
          echo "Synced lazyvim"
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
          size = 15.0;

          normal.family = "BerkeleyMono Nerd Font Mono";
          bold.family = "BerkeleyMono Nerd Font Mono";
          italic.family = "BerkeleyMono Nerd Font Mono";
        };

        window = {
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

    fd = {
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

      userName = "vini";
      userEmail = "andrade.vinicius934@gmail.com";

      ignores = [
        ".DS_Store"
        "**/.DS_Store"
        ".nvim/"
      ];
    };

    git-credential-oauth = {
      enable = true;
    };

    gradle = {
      enable = true;
    };

    home-manager = {
      enable = true;
    };

    java = {
      enable = true;
      package = pkgs.jdk17; # pinned to jdk 17 because of gradle
    };

    lazygit = {
      enable = true;
    };

    neovim = {
      package = pkgs-unstable.neovim-unwrapped;

      enable = true;

      defaultEditor = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    ripgrep = {
      enable = true;
    };

    ruff = {
      enable = true;
      package = pkgs-unstable.ruff;
      settings = {
        lint.preview = true;
      };
    };

    starship = {
      enable = true;
    };

    vscode = {
      enable = false;
    };

    zellij = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        theme = "catppuccin-mocha";
        default_layout = "compact";
        pane_frames = false;
      };
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
        gaa = "git add --all";
        gc = "git commit";
        gca = "git commit --amend";
        gpr = "git pull --rebase";
        gpf = "git push --force-with-lease";

        el = "eza -L";
        et = "eza -T";
        et1 = "eza -T -L1";

        cfg = "cd ~/.config/system";
        src = "cd ~/src";
        puc = "cd ~/puc";
      };

      oh-my-zsh = {
        enable = true;
      };

      # fix for slow copy-paste and also rebind fzf-file-widget because zellij steals ctrl+t
      initExtra = ''
        autoload -Uz bracketed-paste-magic
        zle -N bracketed-paste bracketed-paste-magic
        zstyle ':bracketed-paste-magic' active-widgets '.self-*'

        bindkey -r '^T'
        bindkey '^F' fzf-file-widget
      '';

      envExtra = ''
        export PATH=$PATH:/usr/local/mysql/bin/
        export LIBRARY_PATH=$LIBRARY_PATH:$(brew --prefix)/lib:$(brew --prefix libiconv)/lib
      '';
    };
  };
}
