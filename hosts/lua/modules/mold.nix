{
  homeManagerModule =
    { pkgs, ... }:
    {
      home = {
        # The C compiler of each devshell finds `ld.mold` in PATH.
        packages = [ pkgs.mold ];

        # Nix's C compiler wrapper adds these flags each time it links. rustc, CMake and the other build tools all link
        # through it, so this switches all of them to mold.
        sessionVariables.NIX_CFLAGS_LINK = "-fuse-ld=mold";
      };
    };
}
