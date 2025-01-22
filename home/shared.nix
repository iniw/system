{
  self,
  lib,
  pkgs,
  config,
  ...
}:
{
  fonts.fontconfig.enable = true;

  home = {
    # Warn the user when neovim's lazy{vim,-lock}.json files differ from the ones in the repo.
    activation.neovim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Paths to the source files (in nvim/lazy) and destination (nvim config folder)
      src_dir="${self}/home/nvim/lazy"
      dst_dir=".config/nvim"

      files=("lazy-lock.json" "lazyvim.json")

      # Loop over files to copy or check differences
      for file in "''${files[@]}"; do
        src_file="$src_dir/$file"
        dst_file="$dst_dir/$file"

        if [ ! -f "$dst_file" ]; then
          # If file doesn't exist in the destination, copy it over
          run cp $VERBOSE_ARG -no-preserve=all "$src_file" "$dst_file"
          run echo "Placed $file"
        else
          # If file exists, compare hashes
          src_hash=$(nix hash file "$src_file")
          dst_hash=$(nix hash file "$dst_file")
          if [[ "$src_hash" != "$dst_hash" ]]; then
            run echo -e "\033[35mwarning:\033[0m $file differs from the version in the nix store, please sync them using the 'sync-lazy' script."
          fi
        fi
      done
    '';

    file = {
      "./.config/nvim/" = {
        source = ./nvim;
        recursive = true;
      };

      "./.config/wezterm/" = {
        source = ./wezterm;
        recursive = true;
      };

      "./.config/starship.toml" = {
        source = ./starship/starship.toml;
      };
    };

    shellAliases = {
      lg = "lazygit";
    };

    packages =
      with pkgs;
      with nodePackages;
      [
        # apps
        discord

        # tools
        ast-grep
        binwalk
        coreutils
        exiftool
        hyperfine
        just
        klip
        radare2
        scc
        zlib

        # fonts
        inter

        # languages
        luajit

        # lsp
        bash-language-server
        lua-language-server
        marksman
        nil
        taplo
        texlab
        vscode-langservers-extracted
        yaml-language-server

        # formatters/linters
        eslint
        markdownlint-cli2
        nixfmt-rfc-style
        prettier
        shellcheck
        shfmt
        stylua
      ];

    stateVersion = "24.11";
  };

  xdg = {
    enable = true;
  };

  programs = {
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

    carapace = {
      enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    fd = {
      enable = true;
    };

    fzf = {
      enable = true;

      # Use fd instead of find.
      changeDirWidgetCommand = ''fd --type d --hidden --follow --exclude ".git"'';
      defaultCommand = ''fd --hidden --follow --exclude ".git"'';
      fileWidgetCommand = ''fd --hidden --follow --exclude ".git"'';
    };

    gh = {
      enable = true;
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

        # just's recipe list
        ".justfile"
      ];
    };

    home-manager = {
      enable = true;
    };

    lazygit = {
      enable = true;
    };

    neovim = {
      enable = true;

      defaultEditor = true;

      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
      ];
    };

    nushell = {
      enable = true;

      configFile.source = ./nushell/config.nu;
      envFile.source = ./nushell/env.nu;

      # See: https://github.com/nix-community/home-manager/issues/4313
      shellAliases = config.home.shellAliases;
      environmentVariables = config.home.sessionVariables;
    };

    ripgrep = {
      enable = true;
    };

    starship = {
      enable = true;
    };

    yazi = {
      enable = true;
    };

    zoxide = {
      enable = true;
    };

    zsh = {
      enable = true;
      # Run nushell when launching an interactive shell.
      # Inspired by: https://github.com/NixOS/nixpkgs/issues/297449#issuecomment-2009853257
      # See also: https://nixos.wiki/wiki/Fish#Setting_fish_as_your_shell
      #           https://wiki.archlinux.org/title/Fish#System_integration
      #           https://wiki.gentoo.org/wiki/Fish#Caveats
      initExtra = ''
        if [[ ! $(ps -T -o "comm" | tail -n +2 | grep "nu$") && -z $ZSH_EXECUTION_STRING ]]; then
            if [[ -o login ]]; then
                LOGIN_OPTION='--login'
            else
                LOGIN_OPTION='''
            fi
            exec "${lib.getExe pkgs.nushell}" "$LOGIN_OPTION"
        fi
      '';
    };
  };
}
