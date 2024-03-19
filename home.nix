{ config, pkgs, lib, ... }:
{
  home = {
    stateVersion = "23.11";
    packages = with pkgs; [
      clang
      clang-tools_16
      cmake
      discord
      nil
      ninja
      nixpkgs-fmt
      (python3.withPackages (python-pkgs: with python-pkgs; [
        pip
      ]))
      rustup
    ];
    username = "sol";
    homeDirectory = "/Users/sol/";
    file = {
      "./.config/nvim/" = {
        source = ./nvim;
        recursive = true;
      };
      "./.config/starship.toml" = {
        source = ./starship/starship.toml;
      };
    };
  };

  programs = {
    fzf = {
      enable = true;
      tmux = {
        enableShellIntegration = true;
      };
    };
    alacritty = {
      enable = true;
      settings = {
        env = {
          "TERM" = "xterm-256color";
        };
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
    eza = {
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
    home-manager = {
      enable = true;
    };
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      vimdiffAlias = true;
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
    starship = {
      enable = true;
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
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
