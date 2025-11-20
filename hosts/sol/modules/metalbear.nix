let
  email = "viniciusd@metalbear.com";
in
{
  systemModule = {
    homebrew = {
      brews = [
        "docker"
        "helm"
      ];
      casks = [
        "docker-desktop"
        "linear-linear"
        "notion"
        "slack"
      ];
    };
  };

  homeManagerModule =
    { pkgs, ... }:
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
        kubectl
        minikube
        k9s

        jetbrains.idea-ultimate
      ];

      programs.vscode = {
        enable = true;

        profiles.default = {
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;

          extensions =
            with pkgs.vscode-extensions;
            [
              mkhl.direnv
            ]
            ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              {
                name = "mirrord";
                publisher = "MetalBear";
                version = "3.66.1";
                sha256 = "sha256-jB0yP/RnMmoEQ89pu3QrFDLfAqf4ntrZPdoCF+h0Qpo=";
              }
            ];
        };
      };
    };
}
