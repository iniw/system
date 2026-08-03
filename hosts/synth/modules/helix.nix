{
  homeManagerModule = {
    programs.helix.settings.editor.clipboard-provider.custom = {
      # Commands from `/opt/orbstack-guest/bin`.
      # Seem to be equivalent to running `macctl run pb{copy,paste}`
      # Helix names these from its perspective: yank reads from the system
      # clipboard, while paste writes to it.
      yank.command = "pbpaste";
      paste.command = "pbcopy";
    };
  };
}
