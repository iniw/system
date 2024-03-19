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
    file = {
      "./.config/nvim/" = {
        source = ./nvim;
        recursive = true;
      };
    };
    username = "sol";
    homeDirectory = "/Users/sol";
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
      settings = {
        format = ''$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$character'';
        character = {
          success_symbol = "[❯](white)";
          error_symbol = "[❯](red)";
          vimcmd_symbol = "[❮](green)";
        };
        git_branch = {
          format = "[$branch]($style)";
          style = "bright-black";
        };
        git_status = {
          format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
          style = "cyan";
          conflicted = "​";
          untracked = "​";
          modified = "​";
          staged = "​";
          renamed = "​";
          deleted = "​";
          stashed = "≡";
        };
        git_state = {
          format = "\([$state( $progress_current/$progress_total)]($style)\)";
          style = "bright-black";
        };
        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
        };
      };
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      initExtra = ''
        autoload -Uz bracketed-paste-magic
        zle -N bracketed-paste bracketed-paste-magic
        zstyle ':bracketed-paste-magic' active-widgets '.self-*'
      '';
      syntaxHighlighting = {
        enable = true;
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" ];
      };
    };
  };
}
