{
  homeManagerModule = { pkgs, inputs, ... }: {
    home.packages =
      with pkgs;
      let
        inherit (inputs.nixpkgs-pr-tracker.packages.${stdenv.hostPlatform.system}) nprt;
      in
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

      nix-your-shell.enable = true;

      zoxide.enable = true;
    };
  };

  nixosHomeManagerModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      wl-clipboard
    ];
  };
}
