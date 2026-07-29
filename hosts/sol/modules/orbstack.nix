{
  homeManagerModule = { pkgs, ... }: {
    programs.ssh.includes = [ "~/.orbstack/ssh/config" ];

    home = {
      packages = [ pkgs.orbstack ];

      # Keep the CLI and GUI on the same app copy to avoid restarting the service.
      # See https://github.com/orbstack/orbstack/issues/2614
      sessionPath = [ "$HOME/.orbstack/bin" ];
    };
  };
}
