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
          monospace = [ "Berkeley Mono" ];
          sansSerif = [ "Inter" ];
          serif = [ "Source Serif 4" ];
        };
      };

      programs.ghostty.settings = {
        font-family = "Berkeley Mono";
        font-size = 15;
      };
    };

  nixosHomeManagerModule = {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        font-name = "Inter Variable 11";
        document-font-name = "Inter Variable 11";
        monospace-font-name = "Berkeley Mono 10";
      };
    };
  };
}
