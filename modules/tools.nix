{
  homeManagerModule = { pkgs, inputs, ... }: {
    home = {
      packages =
        let
          nprt = inputs.nixpkgs-pr-tracker.packages.${pkgs.stdenv.hostPlatform.system}.nprt;
        in
        with pkgs;
        [
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

      carapace = {
        enable = true;

        extraPackages = with pkgs; [
          fish
          inshellisense
        ];

        settings = {
          lenient = true;
          bridges = "fish,inshellisense";
        };
      };

      fzf =
        let
          fd = "${pkgs.lib.getExe pkgs.fd} --hidden --follow --exclude .git --exclude .jj";
        in
        {
          enable = true;

          changeDirWidget.command = "${fd} --type directory";
          fileWidget.command = fd;
        };

      # ignored files list used by rg, fd, etc.
      git.ignores = [ ".ignore" ];

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
  };

  nixosHomeManagerModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      wl-clipboard
    ];
  };
}
