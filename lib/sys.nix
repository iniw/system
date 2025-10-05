inputs:
let
  lib = inputs.nixpkgs.lib;

  collectModules =
    path:
    if builtins.pathExists path then
      (lib.filesystem.listFilesRecursive path)
      |> lib.filter (lib.hasSuffix ".nix")
      |> lib.map (import)
      |> lib.zipAttrs
      |> lib.mapAttrs' (name: lib.nameValuePair "${name}s")
    else
      { };

  modules = collectModules ../modules;
  collectHostModules = host: collectModules (../hosts + "/${host}/modules");

  inputsDefaults =
    let
      collectDefaultOutputs =
        output:
        let
          path = [
            output
            "default"
          ];
        in
        inputs
        |> lib.attrValues
        |> lib.filter (lib.hasAttrByPath path)
        |> lib.map (lib.getAttrFromPath path);
    in
    [
      "darwinModules"
      "nixosModules"
      "homeManagerModules"
      "overlays"
    ]
    |> lib.map (output: {
      ${output} = collectDefaultOutputs output;
    })
    |> lib.mergeAttrsList;

  user = "vini";

  specialArgs = {
    inherit user inputs;
  };

  commonModules =
    let
      homeManager =
        { pkgs, ... }:
        {
          home-manager = {
            users.${user} = {
              imports = inputsDefaults.homeManagerModules ++ modules.homeManagerModules or [ ];

              xdg.enable = true;
            };

            useGlobalPkgs = true;
            useUserPackages = true;

            extraSpecialArgs = specialArgs;

            backupFileExtension = "hm-backup";
          };
        };

      nixSettings = {
        nixpkgs = {
          overlays = inputsDefaults.overlays;
          config.allowUnfree = true;
        };

        nix.settings.trusted-users = [ user ];
      };
    in
    [
      homeManager
      nixSettings
    ];

in
{
  darwinSystem =
    let
      homebrewModule =
        let
          taps = {
            "homebrew/homebrew-core" = inputs.homebrew-core;
            "homebrew/homebrew-cask" = inputs.homebrew-cask;
          };
        in
        {
          nix-homebrew = {
            enable = true;
            inherit user taps;
            mutableTaps = false;
          };

          homebrew = {
            enable = true;
            global.autoUpdate = false;
            # The `cleanup = "zap"` field causes brew to try untapping taps that don't appear in the brewfile bundle,
            # so we repeat them here just to get them in the brewfile.
            # See also: https://github.com/zhaofengli/nix-homebrew/issues/5
            taps = lib.attrNames taps;
            onActivation.cleanup = "zap";
          };
        };

      increaseMaxFilesModule = {
        environment.launchDaemons."limit.maxfiles.plist" = {
          text = ''
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0">
              <dict>
                <key>Label</key>
                <string>limit.maxfiles</string>
                <key>ProgramArguments</key>
                <array>
                  <string>launchctl</string>
                  <string>limit</string>
                  <string>maxfiles</string>
                  <string>4096</string>
                  <string>4096</string>
                </array>
                <key>RunAtLoad</key>
                <true/>
                <key>ServiceIPC</key>
                <false/>
              </dict>
            </plist>
          '';
        };
      };

      # FIXME: Remove once https://github.com/nix-community/home-manager/pull/7915 is merged
      appLinkingModule =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          home-manager.sharedModules = [ { targets.darwin.linkApps.enable = lib.mkDefault false; } ];
          system.build.applications = lib.mkForce (
            pkgs.buildEnv {
              name = "system-applications";
              pathsToLink = "/Applications";
              paths =
                config.environment.systemPackages
                ++ (lib.concatMap (x: x.home.packages) (lib.attrsets.attrValues config.home-manager.users));
            }
          );
        };
    in
    module: host:
    let
      hostModules = collectHostModules host;

      userConfigModule = {
        users = {
          users.${user} = {
            home = "/Users/${user}";
            uid = 501;
          };
          knownUsers = [ user ];
        };

        system.primaryUser = user;

        home-manager.users.${user}.imports =
          (modules.darwinHomeManagerModules or [ ]) ++ (hostModules.homeManagerModules or [ ]);
      };
    in
    {
      darwinConfigurations.${host} = inputs.nix-darwin.lib.darwinSystem {
        inherit specialArgs;

        modules =
          commonModules
          ++ inputsDefaults.darwinModules
          ++ (modules.systemModules or [ ])
          ++ (modules.darwinSystemModules or [ ])
          ++ (hostModules.systemModules or [ ])
          ++ [
            module
            userConfigModule
            homebrewModule
            increaseMaxFilesModule
            appLinkingModule
          ];
      };
    };

  nixosSystem =
    module: host:
    let
      hostModules = collectHostModules host;

      userConfigModule = {
        users.users.${user} = {
          home = "/user/${user}";
          extraGroups = [ "wheel" ];
          isNormalUser = true;
        };

        home-manager.users.${user}.imports =
          (modules.nixosHomeManagerModules or [ ]) ++ (hostModules.homeManagerModules or [ ]);
      };
    in
    {
      nixosConfigurations.${host} = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;

        modules =
          commonModules
          ++ inputsDefaults.nixosModules
          ++ (modules.systemModules or [ ])
          ++ (modules.nixosSystemModules or [ ])
          ++ (hostModules.systemModules or [ ])
          ++ [
            module
            userConfigModule
          ];
      };
    };
}
