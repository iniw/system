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
          just
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
            theme = "ansi";
            color = "always";
            style = "numbers";
          };
        };

        btop = {
          enable = true;
          settings = {
            color_theme = "TTY";
            vim_keys = true;
          };
        };

        zoxide.enable = true;
      };
    };
}
