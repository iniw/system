{
  homeManagerModule =
    { inputs, pkgs, ... }:
    let
      monospace = "Berkeley Mono";
      sansSerif = "Inter";
      serif = "Source Serif 4";
    in
    {
      home.packages =
        with pkgs;
        let
          inherit (inputs.fonts.packages.${stdenv.hostPlatform.system}) berkeley-mono;
        in
        [
          berkeley-mono
          inter
          source-serif
        ];

      fonts.fontconfig = {
        enable = true;

        defaultFonts = {
          monospace = [ monospace ];
          sansSerif = [ sansSerif ];
          serif = [ serif ];
        };
      };

      programs.ghostty.settings.font-family = monospace;
    };
}
