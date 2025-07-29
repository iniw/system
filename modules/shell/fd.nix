{
  homeModule = {
    programs = {
      fd.enable = true;

      # Use fd instead of find.
      fzf = {
        changeDirWidgetCommand = ''fd --type d --hidden --follow --exclude ".git" --exclude ".jj"'';
        defaultCommand = ''fd --hidden --follow --exclude ".git" --exclude ".jj"'';
        fileWidgetCommand = ''fd --hidden --follow --exclude ".git" --exclude ".jj"'';
      };

      git.ignores = [ ".ignore" ];
    };
  };
}
