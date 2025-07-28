let
  systemModule = {
    services.openssh.enable = true;
  };
in
{
  darwinModule = systemModule;

  nixosModule = systemModule;

  homeModule =
    { lib, pkgs, ... }:
    {
      programs.ssh = {
        enable = true;

        addKeysToAgent = "confirm";
      };

      services = lib.optionalAttrs pkgs.stdenv.isLinux {
        ssh-agent.enable = true;
      };
    };
}
