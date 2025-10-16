{
  homeManagerModule =
    { pkgs, ... }:
    {
      home.file.".lldbinit".text =
        let
          rust-prettifier-for-lldb = pkgs.fetchFromGitHub {
            owner = "cmrschwarz";
            repo = "rust-prettifier-for-lldb";
            tag = "v0.5.1";
            hash = "sha256-6EIR901c6PVOQApKVbpLf1DPHMwef3LUxFJji2PiduI=";
          };
        in
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

      home.packages = [ pkgs.lldb ];

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
