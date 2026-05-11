{
  systemModule = {
    nixpkgs.config.allowUnfree = true;

    nix.settings = {
      extra-experimental-features = [
        "flakes"
        "nix-command"
        "pipe-operators"
      ];
    };
  };
}
