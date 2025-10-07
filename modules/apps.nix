{
  homeManagerModule =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs;
        let
          # `firefox-bin` is not properly codesigned on darwin
          firefox = if stdenv.isDarwin then firefox-bin-unwrapped else firefox-bin;
        in
        [
          discord
          firefox
        ];
    };
}
