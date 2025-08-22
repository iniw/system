{
  homeModule =
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [
          ast-grep
          coreutils
          exiftool
          hut
          hyperfine
          jq
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
}
