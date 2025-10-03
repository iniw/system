{
  homeModule =
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [
          ast-grep
          exiftool
          hyperfine
          jq
          nh
          python314
          ripgrep
          scc
        ];

        sessionVariables = {
          PAGER = "less -RXSF";
        };

        shellAliases = {
          less = "less -RXS";
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

        fzf.enable = true;

        zoxide.enable = true;
      };
    };

  darwinHomeModule = {
    # Don't override darwin's built-in `man` program with GNU's version while also installing the manpages for hm-managed programs.
    # This does essentially the same thing as the `man` module without adding the `package` to `home.packages`.
    # See: https://github.com/nix-community/home-manager/blob/26993d87fd0d3b14f7667b74ad82235f120d986e/modules/programs/man.nix#L44-L45
    home.extraOutputsToInstall = [ "man" ];
    programs.man.enable = false;
  };
}
