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
      };

      home.packages = with pkgs; [
        # Apps
        notion-app
        slack

        # Docker
        docker
        docker-credential-helpers

        # Kubernetes
        k9s
        kubectl
        kubernetes-helm

        # IDEs for the extensions
        jetbrains.idea
        vscode
      ];

      services.colima = {
        enable = true;

        limaHomeDir = "${config.xdg.dataHome}/lima";

        profiles.default = {
          isActive = true;
          isService = true;
          setDockerHost = true;

          settings = {
            cpu = 6;
            disk = 100;
            memory = 6;
            runtime = "docker";
            rosetta = true;
            vmType = "vz";
            kubernetes.enabled = true;
          };
        };
      };
    };
}
