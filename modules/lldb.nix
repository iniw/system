{
  homeManagerModule = { pkgs, ... }: {
    home = {
      packages = [ pkgs.lldb ];
      file.".lldbinit".text =
        # sh
        ''
          # Show more lines when printing source code
          settings set stop-line-count-after 15

          # Load project-specific .lldbinit files
          settings set target.load-cwd-lldbinit true

          # Limit the number of fields/inner-data is shown when printing a variable
          settings set target.max-children-count 5

          # Disable the statusline because it clears the screen when resizing, which is very annoying
          # FIXME: Remove once https://github.com/llvm/llvm-project/pull/202691 lands in a release
          settings set show-statusline false
        '';
    };

    programs.git.ignores = [
      # Project-specific lldbinit
      ".lldbinit"
      # Place to throw LLDB-specific data that can be stored for use across sessions:
      # settings stored with `settings {read,write}`, breakpoints, etc.
      ".lldb"
    ];
  };

  darwinHomeManagerModule = {
    home.sessionVariables.LLDB_DEBUGSERVER_PATH = "/Library/Developer/CommandLineTools/Library/PrivateFrameworks/LLDB.framework/Resources/debugserver";
  };
}
