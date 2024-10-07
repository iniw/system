{
  lib,
  pkgs,
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
      # Paths to the source files (in nvim/lazy) and destination (nvim config folder)
      src_dir="$HOME/.config/nvim/lazy"
      dst_dir="$HOME/.config/nvim"

      files=("lazy-lock.json" "lazyvim.json")

      # Function to compute the nix hash of a file
      compute_hash() {
        nix hash file "$1" | cut -d' ' -f3
      }

      # Loop over files to copy or check differences
      for file in "''${files[@]}"; do
        src_file="$src_dir/$file"
        dst_file="$dst_dir/$file"

        if [ ! -f "$dst_file" ]; then
          # If file doesn't exist in the destination, copy it over
          # `--no-preserve=all` makes the output files writeable.
          cp --no-preserve=all "$src_file" "$dst_file"
          echo "neovim: Placed $file"
        else
          # If file exists, compare hashes
          src_hash=$(compute_hash "$src_file")
          dst_hash=$(compute_hash "$dst_file")

          if [[ "$src_hash" != "$dst_hash" ]]; then
            echo -e "\033[35mwarning:\033[0m $file in $dst_dir is different from the version in $src_dir."
            echo "You can check the differences using the following command:"
            echo "delta \"$src_file\" \"$dst_file\""
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

    packages = with pkgs; [
      # tools
      coreutils
      moreutils
      zlib
      cloc
      wget
      ast-grep
      tldr
      radare2

      # fonts
      inter

      # nix
      nixfmt-rfc-style
      nil

      # lua
      luajit
      luajitPackages.luarocks
      lua-language-server
      stylua
    ];

    shellAliases = {
      # Git stuff
      gs = "git status";
      gd = "git diff";
      gc = "git commit";
      gap = "git add -p";
      gaa = "git add --all";
      gca = "git commit --amend";
      glo = "git log --oneline";
      gpr = "git pull --rebase";
      gpf = "git push --force-with-lease";
      grp = "git restore -p";
      gaac = "git add --all && git commit -m";

      ls = "eza -1 --icons=always";
      la = "ls -a";

      bat = "bat --number --color=always --wrap=never";
    };

    stateVersion = "24.11";
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

    direnv = {
      enable = true;
      nix-direnv.enable = true;
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
      ];
    };

    home-manager = {
      enable = true;
    };

    jq = {
      enable = true;
    };

    lazygit = {
      enable = true;
    };

    neovim = {
      enable = true;

      defaultEditor = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
      ];
    };

    ripgrep = {
      enable = true;
    };

    starship = {
      enable = true;
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
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
        # From: https://github.com/zsh-users/zsh-autosuggestions/issues/238#issuecomment-389324292
        pasteinit() {
            OLD_SELF_INSERT=''\${''\${(s.:.)widgets[self-insert]}[2,3]}
            zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
        }

        pastefinish() {
            zle -N self-insert $OLD_SELF_INSERT
        }

        zstyle :bracketed-paste-magic paste-init pasteinit
        zstyle :bracketed-paste-magic paste-finish pastefinish
      '';
    };
  };
}
