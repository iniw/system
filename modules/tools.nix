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
    # Don't override darwin's built-in `man` program with GNU's version while also installing the manpages for hm-managed programs.
    # This does essentially the same thing as the `man` module without adding the `package` to `home.packages`.
    # See: https://github.com/nix-community/home-manager/blob/26993d87fd0d3b14f7667b74ad82235f120d986e/modules/programs/man.nix#L44-L45
    home.extraOutputsToInstall = [ "man" ];
    programs.man.enable = false;

    # See: https://github.com/NixOS/nixpkgs/issues/456879
    home.shellAliases.man = "env DEVELOPER_DIR= SDKROOT= man";
  };
}
