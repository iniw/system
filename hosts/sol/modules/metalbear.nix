let
  email = "viniciusd@metalbear.com";
in
{
  systemModule = {
    homebrew.casks = [
      "linear-linear"
    ];
  };

  homeManagerModule =
    { pkgs, config, ... }:
    {
      programs = {
        jujutsu.settings."--scope" = [
          {
            "--when".repositories = [ "~/work/metalbear" ];
            user.email = email;
          }
        ];

        git = {
          ignores = [ ".mirrord/" ];
          includes = [
            {
              condition = "gitdir:~/work/metalbear/";
              contents.user.email = email;
            }
          ];
        };

        ssh.includes = [ "~/.orbstack/ssh/config" ];
      };

      home.packages = with pkgs; [
        # Apps
        notion-app
        slack

        # Containers
        orbstack
        k9s
        kubernetes-helm

        # IDEs for the extensions
        jetbrains.idea
        vscode
      ];
    };
}
