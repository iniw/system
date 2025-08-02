{
  homeModule =
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [
          ast-grep
          coreutils
          exiftool
          hyperfine
          jq
          klip
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
          };
        };

        fzf.enable = true;

        zoxide.enable = true;
      };
    };
}
