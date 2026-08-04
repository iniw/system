{
  homeManagerModule = { pkgs, ... }: {
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

          # Limit the number of fields/inner-data is shown when printing a variable
          settings set target.max-children-count 5

          # Improve printing of Rust-specific types
          command script import "${rust-prettifier-for-lldb}/rust_prettifier_for_lldb.py"
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
