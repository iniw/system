{
  homeManagerModule =
    { pkgs, lib, ... }:
    {
      home = {
        packages = [ pkgs.sccache ];

        # Cargo does not use the XDG folders. It reads its config from `$CARGO_HOME`, which is `~/.cargo` by default.
        file.".cargo/config.toml".text = # toml
          ''
            [build]
            rustc-wrapper = "${lib.getExe pkgs.sccache}"
          '';
      };
    };
}
