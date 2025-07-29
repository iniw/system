{
  homeModule =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.ast-grep
        pkgs.coreutils
        pkgs.exiftool
        pkgs.hyperfine
        pkgs.jq
        pkgs.just
        pkgs.klip
        pkgs.python314
        pkgs.ripgrep
        pkgs.scc
      ];

      home.sessionVariables = {
        PAGER = "less -FRX";
      };

      programs = {
        bat.enable = true;
        bat.config.theme = "ansi";

        btop.enable = true;
        btop.settings.color_theme = "TTY";
        btop.settings.vim_keys = true;

        carapace.enable = true;

        fzf.enable = true;

        zoxide.enable = true;
      };
    };
}
