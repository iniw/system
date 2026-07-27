{
  homeManagerModule =
    { config, lib, ... }:
    {
      programs.ghostty.settings.font-size = 12;

      dconf.settings =
        let
          getDefault = font: lib.head config.fonts.fontconfig.defaultFonts.${font};

          monospace = getDefault "monospace";
          sansSerif = getDefault "sansSerif";
          serif = getDefault "serif";
        in
        {
          "org/gnome/desktop/interface" = {
            font-name = "${sansSerif} 11";
            document-font-name = "${serif} 11";
            monospace-font-name = "${monospace} 10";
          };
        };
    };
}
