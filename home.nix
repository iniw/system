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

      # FIXME(zellij_flicker): zellij is currently being manually built/installed from source until https://github.com/zellij-org/zellij/issues/3208 ships.
      "./.config/zellij/" = {
        source = ./zellij;
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
      swiProlog
    ];

    sessionPath = [
      # I manually install mysql version 8.0.23 because it is the last version to support my old MacOS, 
      # meaning it has be manually added to $PATH.
      "/usr/local/mysql/bin/"

      # FIXME(zellij_flicker): Remove once a new zellij version is shipped
      "${config.home.homeDirectory}/.cargo/bin/"
    ];

    sessionVariables = {
      # The android SDK should be manually installed here using Android Studio (or QTCreator).
      ANDROID_HOME = "$HOME/Library/Android/sdk";

      # Fix for libioconv linker errors when compiling rust code.
      # TODO: Manage brew with nix-darwin.
      LIBRARY_PATH = "$LIBRARY_PATH:$(brew --prefix)/lib:$(brew --prefix libiconv)/lib";
    };

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
      tree = "eza -T -L1";
    };

    stateVersion = "24.05";
  };

  programs = {
    alacritty = {
      enable = true;

      settings = {
        font = {
          size = 15.0;

          # TODO: install this font with the flake.
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

      # Use fd instead of find. Way faster.
      changeDirWidgetCommand = "fd --type d";
      defaultCommand = "fd --type f";
      fileWidgetCommand = "fd --type f";
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
        # Our `nvim-config-local` config is setup to use ".nvim/local.lua" as the per-project local config path,
        # adding the entire folder here to the global .gitignore prevents us from polluting project-specific .gitignore's with our own configs.
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
      # Compiling android code with gradle fails when JDK > 17.
      package = pkgs.jdk17;
    };

    lazygit = {
      enable = true;
    };

    neovim = {
      # Stable neovim is still at 0.9 and a lot of our plugins require 0.10, so fetch it from unstable.
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
        # The newest ruff versions require this flag to be launched with conform/mason.
        lint.preview = true;
      };
    };

    starship = {
      enable = true;
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
        # From: https://github.com/zsh-users/zsh-autosuggestions/issues/102#issuecomment-183770990
        autoload -Uz bracketed-paste-magic
        zle -N bracketed-paste bracketed-paste-magic
        zstyle ':bracketed-paste-magic' active-widgets '.self-*'

        # Our zellij setup uses <C-t> for entering Tmux mode, so make fzf use <C-f> instead.
        bindkey -r '^T'
        bindkey '^F' fzf-file-widget
      '';

      loginExtra = ''
        # Join our zellij session
        # FIXME(zellij_flicker): Remove the carge prefix once zellij is managed by home-manager again.
        exec zellij attach --create ':3'
      '';
    };
  };
}
