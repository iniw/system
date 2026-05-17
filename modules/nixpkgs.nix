{
  systemModule = {
    nixpkgs.config.allowUnfree = true;

    nix.settings = {
      sandbox = true;

      extra-experimental-features = [
        "flakes"
        "nix-command"
        "pipe-operators"
      ];
    };
  };
}
