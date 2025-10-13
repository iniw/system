{
  homeManagerModule =
    let
      rust-prettifier-for-lldb = builtins.fetchGit {
        name = "rust-prettifier-for-lldb";
        url = "https://github.com/cmrschwarz/rust-prettifier-for-lldb.git";
        rev = "c97ed7a6305725655fe3b636509cc639dce31890";
      };
    in
    { pkgs, ... }:
    {
      home.file.".lldbinit".text =
        # sh
        ''
          # Show more lines when printing source code
          settings set stop-line-count-after 15

          # Load project-specific .lldbinit files
          settings set target.load-cwd-lldbinit true

          # Disable LLDB 21's statusline
          settings set show-statusline false

          # Alias to save and load the breakpoints into a known (and gitignored) file
          command alias bs breakpoint write -f .breakpoints
          command alias bl breakpoint read -f .breakpoints

          # Improve printing of Rust-specific types
          command script import "${rust-prettifier-for-lldb}/rust_prettifier_for_lldb.py"
        '';

      home.packages = [ pkgs.lldb_21 ];

      programs.git.ignores = [
        # Project-specific lldbinit
        ".lldbinit"
        # List of breakpoints saved/loaded with the bs/bl aliases
        ".breakpoints"
      ];
    };

  # Nix's LLDB doesn't find `debugserver` on darwin, so we download codelldb's version and tell LLDB to use it through `LLDB_DEBUGSERVER_PATH`.
  # This idea/code is taken from https://github.com/NixOS/nixpkgs/pull/374846 and should be removed if that ever lands (unlikely).
  # For context: https://github.com/NixOS/nixpkgs/issues/252838
  darwinHomeManagerModule =
    { pkgs, lib, ... }:
    {
      home.sessionVariables.LLDB_DEBUGSERVER_PATH = lib.getExe pkgs.debugserver;
    };
}
