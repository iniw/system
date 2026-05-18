{
  homeManagerModule =
    { pkgs, inputs, ... }:
    let
      nprt = inputs.nixpkgs-pr-tracker.packages.${pkgs.stdenv.hostPlatform.system}.nprt;
    in
    {
      home = {
        packages = with pkgs; [
          # General tools
          ansifilter
          ast-grep
          fd
          fzf
          hyperfine
          jq
          nh
          nprt
          okapi-ed
          python314
          ripgrep
          scc

          # System-wide LSP support for languages used everywhere.

          # Nix
          nixd
          nixfmt
          # Markdown
          marksman
          # Toml
          tombi
          # Yaml
          yaml-language-server
          yamlfmt # FIXME: Remove once https://github.com/helix-editor/helix/issues/15576 is fixed
          helm-ls
        ];

        sessionVariables = {
          MANPAGER = pkgs.writeShellScript "manpager" "col -bx | bat --language man --style plain";
          CARAPACE_LENIENT = "1";
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

      xdg.configFile."yamlfmt/yamlfmt.yaml".text = # yaml
        ''
          formatter:
            retain_line_breaks_single: true
        '';
    };

  darwinHomeManagerModule = {
    # See: https://github.com/NixOS/nixpkgs/issues/456879
    home.shellAliases.man = "env DEVELOPER_DIR= SDKROOT= man";
  };

  nixosHomeManagerModule = {
    # GNU groff emits SGR escapes by default, but our MANPAGER runs `col -bx`,
    # which only cleans up the classic backspace formatting that grotty -c produces.
    home.sessionVariables.MANROFFOPT = "-P-c";
  };
}
