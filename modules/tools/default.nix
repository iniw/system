{
  homeModule =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.ast-grep
        pkgs.coreutils
        pkgs.exiftool
        pkgs.fd
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
        # Use fd instead of find.
        fzf.changeDirWidgetCommand = ''fd --type d --hidden --follow --exclude ".git" --exclude ".jj"'';
        fzf.defaultCommand = ''fd --hidden --follow --exclude ".git" --exclude ".jj"'';
        fzf.fileWidgetCommand = ''fd --hidden --follow --exclude ".git" --exclude ".jj"'';

        zoxide.enable = true;
      };

      # fd's ignore list
      programs.git.ignores = [ ".ignore" ];
    };
}
