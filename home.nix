{ config, pkgs, lib, ... }:
{
  home = {
    stateVersion = "23.11";
    packages = with pkgs; [
      discord
      inter

      (python3.withPackages (python-pkgs: with python-pkgs; [
        pip
      ]))
      cmake
      clang
      clang-tools_16
      rustup

      nixpkgs-fmt
      nil
    ];
    file = {
      "./.config/nvim/" = {
        source = ./nvim;
        recursive = true;
      };
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
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
          decorations = "buttonless";
        };
      };
    };
    gh = {
      enable = true;
    };
    git = {
      enable = true;
      userName = "iniw";
      userEmail = "andrade.vinicius934@gmail.com";
      extraConfig = {
        credential.helper = "oauth";
      };
    };
    home-manager = {
      enable = true;
    };
    htop = {
      enable = true;
      settings.show_program_path = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
    tmux = {
      enable = true;
      shortcut = "q";
    };
    vscode = {
      enable = true;
    };
    zsh = {
      enable = true;

      enableAutosuggestions = true;
      enableCompletion = true;

      oh-my-zsh.enable = true;
    };
  };
}
