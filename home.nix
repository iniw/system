{ config, pkgs, lib, ... }:
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
      # dev
      clang
      clang-tools_16
      cmake
      nil
      ninja
      nixpkgs-fmt
      (python3.withPackages (python-modules: with python-modules; [
        pip
      ]))
      rustup

      # apps
      discord

      # fonts
      inter
    ];

    stateVersion = "23.11";
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

    eza = {
      enable = true;
    };

    fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
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

    home-manager = {
      enable = true;
    };

    neovim = {
      enable = true;

      defaultEditor = true;

      vimAlias = true;
      vimdiffAlias = true;
    };

    starship = {
      enable = true;
    };

    tmux = {
      enable = true;
      escapeTime = 0;
      mouse = true;
      keyMode = "vi";
      prefix = "C-p";
    };

    vscode = {
      enable = true;
    };

    zsh = {
      enable = true;

      enableAutosuggestions = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        gs = "git status \"$@\"";
        gd = "git diff \"$@\"";
        glo = "git log --oneline";
        gap = "git add -p";
        gca = "git commit --amend";
        gpr = "git pull --rebase";
        gpf = "git push --force-with-lease";

        et = "eza -T \"$@\"";
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
      '';
    };
  };
}
