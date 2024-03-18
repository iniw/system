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
