{
  systemModule = {
    nixpkgs.overlays = [
      (final: prev: {
        fzf = prev.fzf.overrideAttrs {
          patches = [
            (final.fetchpatch {
              url = "https://github.com/junegunn/fzf/commit/24832e97ef9640e5f859ede8dc163cf3c27145cb.patch";
              hash = "sha256-Ul4IphXeWB3evUy/X0pj6vNzKEoPGwaY53pdjZTGG+8=";
            })
          ];
        };
      })
    ];
  };

  homeManagerModule =
    { pkgs, inputs, ... }:
    {
      home = {
        packages =
          let
            nprt = inputs.nixpkgs-pr-tracker.packages.${pkgs.stdenv.hostPlatform.system}.nprt;
          in
          with pkgs;
          [
            ansifilter
            ast-grep
            fd
            ffmpeg
            hyperfine
            jq
            nprt
            okapi-ed
            python314
            ripgrep
            scc
          ];

        sessionVariables.CARAPACE_LENIENT = "1";

        shellAliases.ns = "nix shell --impure -f '<nixpkgs>'";
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

        fzf =
          let
            fd = "${pkgs.lib.getExe pkgs.fd} --hidden --follow --exclude .git --exclude .jj";
          in
          {
            enable = true;

            changeDirWidget.command = "${fd} --type directory";
            fileWidget.command = fd;
          };

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
}
