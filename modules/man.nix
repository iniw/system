{
  homeManagerModule =
    { pkgs, ... }:
    {
      home.sessionVariables.MANPAGER =
        let
          bat = pkgs.lib.getExe pkgs.bat;
        in
        pkgs.writeShellScript "manpager" "col -bx | ${bat} --language man --style plain";
    };

  darwinHomeManagerModule = {
    # See: https://github.com/NixOS/nixpkgs/issues/456879
    home.shellAliases.man = "env DEVELOPER_DIR= SDKROOT= man";
  };

  nixosHomeManagerModule = {
    # GNU groff emits SGR escapes by default, but our MANPAGER runs `col -bx`,
    # which only cleans up the classic backspace formatting that grotty -c produces.
    home.sessionVariables.MANROFFOPT = "-P-c";
  };
}
