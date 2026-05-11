{
  darwinSystemModule =
    {
      config,
      inputs,
      lib,
      user,
      ...
    }:
    let
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
      };
    in
    {
      imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

      nix-homebrew = {
        enable = true;

        inherit user taps;

        mutableTaps = false;
      };

      # Local zsh-only copy of https://github.com/zhaofengli/nix-homebrew/pull/119.
      programs.zsh = lib.mkIf config.nix-homebrew.enableZshIntegration {
        shellInit = ''
          eval "$(brew shellenv 2>/dev/null || true)"
        '';
      };

      homebrew = {
        enable = true;

        global.autoUpdate = false;

        onActivation.cleanup = "zap";
        # The `cleanup = "zap"` field causes brew to try untapping taps that don't appear in the brewfile bundle,
        # so we repeat them here just to get them in the brewfile.
        # See also: https://github.com/zhaofengli/nix-homebrew/issues/5
        taps = lib.attrNames taps;
      };
    };
}
