{
  homeManagerModule =
    { pkgs, inputs, ... }:
    let
      nprt = inputs.nixpkgs-pr-tracker.packages.${pkgs.stdenv.hostPlatform.system}.nprt;
    in
    {
      home = {
        packages = with pkgs; [
          ansifilter
          ast-grep
          fd
          fzf
          hyperfine
          jq
          nh
          python314
          ripgrep
          scc
          xld
          nprt

          # System-wide LSP support for languages used everywhere.

          # Nix
          nixd
          nixfmt
          # Markdown
          marksman
          # Toml
          taplo
          # Yaml
          yaml-language-server
          helm-ls
        ];

        sessionVariables = {
          MANPAGER = "col -bx | bat --language man --style plain";
        };
      };

      programs = {
        bat = {
          enable = true;
          config = {
            style = "numbers";
            theme = "ansi";
          };
        };

        btop = {
          enable = true;
          settings = {
            color_theme = "TTY";
            vim_keys = true;
          };
        };

        carapace.enable = true;

        less = {
          enable = true;

          options = {
            RAW-CONTROL-CHARS = true;
            chop-long-lines = true;
            ignore-case = true;
            incsearch = true;
            no-init = true;
            quit-if-one-screen = true;
            quit-on-intr = true;
            status-column = true;
            use-color = true;
          };
        };

        zoxide.enable = true;
      };

      # ignored files list used by rg, fd, etc.
      programs.git.ignores = [ ".ignore" ];
    };

  darwinHomeManagerModule = {
    # See: https://github.com/NixOS/nixpkgs/issues/456879
    home.shellAliases.man = "env DEVELOPER_DIR= SDKROOT= man";
  };
}
