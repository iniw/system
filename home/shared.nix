{
  self,
  lib,
  pkgs,
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
        moreutils
        radare2
        scc
        tldr
        wget
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
      gaac = "git add --all && git commit";
      gaaca = "git add --all && git commit --amend";
      lg = "lazygit";

      ls = "eza -1 --icons=always";
      la = "ls -a";
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

    carapace = {
      enable = true;
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

    jq = {
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

      initExtraBeforeCompInit =
        # Using fd for fzf completion lists.
        # From: https://ivergara.github.io/Supercharging-shell.html
        ''
          _fzf_compgen_path() { fd --hidden --follow --exclude ".git" . "$1" }
          _fzf_compgen_dir() { fd --type d --hidden --follow --exclude ".git" . "$1" }
        '';

      initExtra =
        # Fixes slow zsh copy-paste.
        # From: https://github.com/zsh-users/zsh-autosuggestions/issues/238#issuecomment-389324292
        ''
          pasteinit() {
              OLD_SELF_INSERT=''\${''\${(s.:.)widgets[self-insert]}[2,3]}
              zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
          }

          pastefinish() {
              zle -N self-insert $OLD_SELF_INSERT
          }

          zstyle :bracketed-paste-magic paste-init pasteinit
          zstyle :bracketed-paste-magic paste-finish pastefinish
        ''
        # Binding <Ctrl>z to `fg`.
        # Inspired by: https://www.reddit.com/r/vim/comments/9bm3x0/ctrlz_binding/
        #              https://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
        + ''
          function togglefg {
            if [[ $#BUFFER -eq 0 ]]; then
              # No need to consume a line when the buffer is empty
              fg
            else
              fg
              zle push-input
              BUFFER=""
              zle accept-line
            fi
          }
          zle -N togglefg
          bindkey "^Z" togglefg
        '';
    };
  };
}
