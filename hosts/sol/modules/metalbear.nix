{
  homeManagerModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      linear
      notion-app
      orbstack
    ];

    programs.ssh.includes = [ "~/.orbstack/ssh/config" ];
  };
}
