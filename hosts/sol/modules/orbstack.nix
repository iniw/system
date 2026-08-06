{
  homeManagerModule = { pkgs, ... }: {
    home.packages = [ pkgs.orbstack ];
    programs.ssh.includes = [ "~/.orbstack/ssh/config" ];
  };
}
