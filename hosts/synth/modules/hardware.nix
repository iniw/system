{
  systemModule = {
    # Indicate builder support for emulated architectures
    nix.settings.extra-platforms = [
      "x86_64-linux"
      "i686-linux"
    ];

    nixpkgs.hostPlatform = "aarch64-linux";
  };
}
