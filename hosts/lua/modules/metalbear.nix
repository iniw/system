let
  email = "viniciusd@metalbear.com";
in
{
  systemModule = {
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };

    systemd.services."user@".serviceConfig.Delegate = "cpu cpuset io memory pids";
  };

  homeManagerModule = { pkgs, ... }: {
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
        k3d
        k9s
        kubectl
        kubernetes-helm

        # To interact with the staging cluster
        gcloud
      ];

    xdg.autostart.entries = [ "${pkgs.slack}/share/applications/slack.desktop" ];
  };
}
