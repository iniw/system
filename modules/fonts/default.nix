{
  homeModule =
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
    };

  nixosHomeModule = {
    dconf = {
      "org/gnome/desktop/interface" = {
        font-name = "Inter Variable 11";
        document-font-name = "Inter Variable 11";
        monospace-font-name = "Berkeley Mono 10";
      };
    };
  };
}
