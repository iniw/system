{
  homeModule = {
    programs = {
      fd.enable = true;

      # Use fd instead of find.
      fzf.changeDirWidgetCommand = ''fd --type d --hidden --follow --exclude ".git" --exclude ".jj"'';
      fzf.defaultCommand = ''fd --hidden --follow --exclude ".git" --exclude ".jj"'';
      fzf.fileWidgetCommand = ''fd --hidden --follow --exclude ".git" --exclude ".jj"'';

      git.ignores = [ ".ignore" ];
    };
  };
}
