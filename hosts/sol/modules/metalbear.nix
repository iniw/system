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
    { pkgs, ... }:
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

      home.packages =
        with pkgs;
        let
          gcloud = google-cloud-sdk.withExtraComponents [
            google-cloud-sdk.components.gke-gcloud-auth-plugin
          ];
        in
        [
          # Communication
          notion-app
          slack

          # Kubernetes/Docker stuff
          orbstack
          k9s
          kubernetes-helm

          # To access the staging cluster
          gcloud

          # IDEs for the extensions
          jetbrains.idea
          vscode
        ];
    };
}
