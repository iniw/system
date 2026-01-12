{
  homeManagerModule =
    { pkgs, ... }:
    {
      home = {
        packages = [ pkgs.lldb ];

        file.".lldbinit".text =
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

            # Limit the number of fields/inner-data is shown when printing a variable
            settings set target.max-children-count 5

            # Alias to save and load the breakpoints into a known (and gitignored) file
            command alias bs breakpoint write -f .breakpoints
            command alias bl breakpoint read -f .breakpoints

            # Improve printing of Rust-specific types
            command script import "${rust-prettifier-for-lldb}/rust_prettifier_for_lldb.py"
          '';
      };

      programs.git.ignores = [
        # Project-specific lldbinit
        ".lldbinit"
        # List of breakpoints saved/loaded with the bs/bl aliases
        ".breakpoints"
      ];
    };

  darwinHomeManagerModule = {
    home.sessionVariables.LLDB_DEBUGSERVER_PATH = "/Library/Developer/CommandLineTools/Library/PrivateFrameworks/LLDB.framework/Versions/A/Resources/debugserver";
  };
}
