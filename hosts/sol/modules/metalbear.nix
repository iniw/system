let
  email = "viniciusd@metalbear.com";
in
{
  systemModule = {
    homebrew.casks = [
      "docker-desktop"
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

        git.includes = [
          {
            condition = "gitdir:~/work/metalbear/";
            contents.user.email = email;
          }
        ];
      };

      home.packages = with pkgs; [
        # Apps
        notion-app
        slack

        # Kubernetes
        docker
        k9s
        kubectl
        kubernetes-helm
        minikube

        # IDEs for the extensions
        jetbrains.idea
        vscode
      ];
    };
}
