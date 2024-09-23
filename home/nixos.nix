{
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./shared.nix ];

  home = {
    packages = with pkgs; [
      xclip
      firefox
      gcc14
    ];
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/input-sources" = {
        sources = [
          (lib.hm.gvariant.mkTuple [
            "xkb"
            "br"
          ])
        ];
        xkb-options = [
          "caps:escape"
        ];
      };
    };
  };
}
