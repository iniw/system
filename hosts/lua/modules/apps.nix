{
  homeManagerModule = { pkgs, inputs, ... }: {
    home.packages =
      with pkgs;
      let
        inherit (inputs.sidra.packages.${stdenv.hostPlatform.system}) sidra;
      in
      [
        discord
        firefox
        obs-studio
        sidra
        wl-clipboard
      ];
  };
}
