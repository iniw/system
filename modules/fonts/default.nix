{
  homeModule =
    { lib, pkgs, ... }:
    {
      home.packages = [
        pkgs.berkeley-mono
        pkgs.inter
        pkgs.tx-02
      ];

      fonts.fontconfig = {
        enable = true;

        defaultFonts = {
          monospace = [ "Berkeley Mono" ];
          sansSerif = [ "Inter" ];
          serif = [ "Inter" ];
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
