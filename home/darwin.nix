{ pkgs, ... }:
{
  imports = [ ./shared.nix ];

  programs = {
    java = {
      enable = true;
      package = pkgs.jdk17;
    };
  };
}
