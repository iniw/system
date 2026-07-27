let
  monospace = "Berkeley Mono";
  sansSerif = "Inter";
  serif = "Source Serif 4";
in
{
  systemModule =
    { inputs, ... }:
    {
      nixpkgs.overlays = [ inputs.fonts.overlays.default ];
    };

  homeManagerModule =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        berkeley-mono
        inter
        source-serif
        tx-02
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
