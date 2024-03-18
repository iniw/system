{ config, pkgs, lib, ... }:
{
  home = {
    stateVersion = "23.11";
    packages = with pkgs; [
      discord
      python3
      inter

      cmake
      clang
      clang-tools_16

      nixpkgs-fmt
      nil
    ];
  };

  fonts.fontconfig.enable = true;

  home.file."./.config/nvim/" = {
    source = ./nvim;
    recursive = true;
  };

  home.file."./.config/vscode/" = {
    source = ./vscode;
    recursive = true;
  };

  programs = {
    vscode = {
      enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
    gh = {
      enable = true;
    };
    home-manager = {
      enable = true;
    };
    htop = {
      enable = true;
      settings.show_program_path = true;
    };
    git = {
      enable = true;
      extraConfig = {
        credential.helper = "oauth";
      };
    };
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
    starship = {
      enable = true;
    };
  };
}
