{
  homeManagerModule = { config, lib, ... }: {
    programs.ghostty.settings.font-size = 12;

    dconf.settings."org/gnome/desktop/interface" =
      let
        defaultFont = style: lib.head config.fonts.fontconfig.defaultFonts.${style};

        monospace = defaultFont "monospace";
        sansSerif = defaultFont "sansSerif";
        serif = defaultFont "serif";
      in
      {
        monospace-font-name = "${monospace} 10";
        font-name = "${sansSerif} 11";
        document-font-name = "${serif} 11";
      };
  };
}
