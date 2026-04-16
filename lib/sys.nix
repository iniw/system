inputs:
let
  lib = inputs.nixpkgs.lib;

  modules =
    let
      collectModules =
        path:
        path
        |> lib.filesystem.listFilesRecursive
        |> lib.filter (lib.hasSuffix ".nix")
        |> lib.map import
        |> lib.zipAttrs
        |> lib.mapAttrs' (name: lib.nameValuePair "${name}s");

    in
    {
      common = collectModules ../modules;
      forHost = host: collectModules (../hosts + "/${host}/modules");
    };

  overlays =
    let
      collectDirectory =
        path:
        if builtins.pathExists path then
          path
          |> builtins.readDir
          |> lib.mapAttrs' (
            name: _: lib.nameValuePair (lib.removeSuffix ".nix" name) (import (path + "/${name}"))
          )
        else
          { };

      overlays = collectDirectory ../overlays |> lib.attrValues;

      packages =
        final: prev:
        collectDirectory ../packages
        |> lib.mapAttrs' (name: pkg: lib.nameValuePair name (final.callPackage pkg { }));

    in
    overlays ++ [ packages ];

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
      homeManagerModule = {
        home-manager = {
          users.${user} = {
            imports = inputsDefaults.homeManagerModules ++ modules.common.homeManagerModules or [ ];

            xdg.enable = true;
            home.preferXdgDirectories = true;
          };

          useGlobalPkgs = true;
          useUserPackages = true;

          extraSpecialArgs = specialArgs;

          backupFileExtension = "hm-backup";
        };
      };

      nixModule = {
        nixpkgs = {
          overlays = inputsDefaults.overlays ++ overlays;
          config.allowUnfree = true;
        };
        nix.settings = {
          extra-substituters = [ "https://cache.numtide.com" ];
          extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
          extra-experimental-features = [
            "flakes"
            "nix-command"
            "pipe-operators"
          ];
        };
      };
    in
    [
      homeManagerModule
      nixModule
    ]
    ++ modules.common.systemModules or [ ];
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
          text = # xml
            ''
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
    in
    module: host:
    let
      hostModules = modules.forHost host;

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
          modules.common.darwinHomeManagerModules or [ ] ++ hostModules.homeManagerModules or [ ];
      };
    in
    {
      darwinConfigurations.${host} = inputs.nix-darwin.lib.darwinSystem {
        inherit specialArgs;

        modules =
          commonModules
          ++ inputsDefaults.darwinModules
          ++ modules.common.darwinSystemModules or [ ]
          ++ hostModules.systemModules or [ ]
          ++ [
            module
            userConfigModule
            homebrewModule
            increaseMaxFilesModule
          ];
      };
    };

  nixosSystem =
    module: host:
    let
      hostModules = modules.forHost host;

      userConfigModule = {
        users.users.${user} = {
          home = "/user/${user}";
          extraGroups = [ "wheel" ];
          isNormalUser = true;
        };

        home-manager.users.${user}.imports =
          modules.common.nixosHomeManagerModules or [ ] ++ hostModules.homeManagerModules or [ ];
      };
    in
    {
      nixosConfigurations.${host} = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;

        modules =
          commonModules
          ++ inputsDefaults.nixosModules
          ++ modules.common.nixosSystemModules or [ ]
          ++ hostModules.systemModules or [ ]
          ++ [
            module
            userConfigModule
          ];
      };
    };
}
