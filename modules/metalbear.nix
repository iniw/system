# The local Docker and Kubernetes engine is different on each OS,
# so each host sets it up in its own `hosts/<host>/modules/metalbear.nix`.
{
  homeManagerModule = { pkgs, ... }: {
    programs =
      let
        email = "viniciusd@metalbear.com";
      in
      {
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

    home.packages =
      with pkgs;
      let
        gcloud = google-cloud-sdk.withExtraComponents [
          google-cloud-sdk.components.gke-gcloud-auth-plugin
        ];
      in
      [
        # Communication
        slack

        # Kubernetes stuff
        k9s
        kubernetes-helm

        # To interact with the staging cluster
        gcloud
      ];
  };
}
