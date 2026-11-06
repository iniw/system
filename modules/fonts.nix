{
  homeManagerModule =
    { pkgs, ... }:
    let
      # Berkeley Mono must be installed manually.
      monospace = "Berkeley Mono";
      sansSerif = "Inter";
      serif = "Source Serif 4";
    in
    {
      home.packages = with pkgs; [
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
