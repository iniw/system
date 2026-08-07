let
  email = "viniciusd@metalbear.com";
in
{
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
        linear
        notion-app
        slack

        # Kubernetes stuff
        k9s
        kubernetes-helm

        # To interact with the staging cluster
        gcloud
      ];
  };

  systemModule =
    {
      config,
      user,
      lib,
      ...
    }:
    {
      system.defaults.dock.persistent-apps =
        let
          inherit (config.users.users.${user}) home;
        in
        lib.mkAfter [
          { app = "${home}/Applications/Home Manager Apps/Slack.app"; }
          { app = "${home}/Applications/Home Manager Apps/Linear.app"; }
        ];
    };
}
