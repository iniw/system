let
  monospace = "Berkeley Mono";
  sansSerif = "Inter";
  serif = "Source Serif 4";
in
{
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

      programs = {
        ghostty.settings = {
          font-family = monospace;
          font-size = 15;
        };

        thunderbird.settings = {
          "font.name.monospace.x-western" = monospace;
          "font.size.monospace.x-western" = 13;

          "font.name.sans-serif.x-western" = sansSerif;
          "font.size.variable.x-western" = 16;

          "font.name.serif.x-western" = serif;
          "mail.uifontsize" = 15;
        };
      };
    };

  nixosHomeManagerModule = {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        font-name = "${sansSerif} 11";
        document-font-name = "${serif} 11";
        monospace-font-name = "${monospace} 10";
      };
    };
  };
}
