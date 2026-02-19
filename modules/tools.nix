{
  homeManagerModule =
    { pkgs, config, ... }:
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
            proc_tree = true;
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
