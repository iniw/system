{
  homeManagerModule =
    {
      pkgs,
      lib,
      inputs,
      ...
    }:
    {
      programs.thunderbird =
        let
          # FIXME: Remove once https://github.com/NixOS/nixpkgs/pull/449760 is merged
          thunderbird-bin-pkg =
            {
              lib,
              stdenv,
              fetchurl,
              config,
              wrapGAppsHook3,
              autoPatchelfHook,
              alsa-lib,
              curl,
              gtk3,
              writeScript,
              writeText,
              xidel,
              coreutils,
              gnused,
              gnugrep,
              gnupg,
              runtimeShell,
              systemLocale ? config.i18n.defaultLocale or "en_US",
              patchelfUnstable, # have to use patchelfUnstable to support --no-clobber-old-sections
              generated,
              versionSuffix ? "",
              applicationName ? "Thunderbird",
              undmg,
            }:

            let
              inherit (generated) version sources;

              mozillaPlatforms = {
                i686-linux = "linux-i686";
                x86_64-linux = "linux-x86_64";
                # bundles are universal and can be re-used for both darwin architectures
                aarch64-darwin = "mac";
                x86_64-darwin = "mac";
              };

              arch = mozillaPlatforms.${stdenv.hostPlatform.system};

              isPrefixOf = prefix: string: builtins.substring 0 (builtins.stringLength prefix) string == prefix;

              sourceMatches = locale: source: (isPrefixOf source.locale locale) && source.arch == arch;

              policies = {
                DisableAppUpdate = true;
              }
              // config.thunderbird.policies or { };
              policiesJson = writeText "thunderbird-policies.json" (builtins.toJSON { inherit policies; });

              defaultSource = lib.findFirst (sourceMatches "en-US") { } sources;

              mozLocale =
                if systemLocale == "ca_ES@valencia" then
                  "ca-valencia"
                else
                  lib.replaceStrings [ "_" ] [ "-" ] systemLocale;

              source = lib.findFirst (sourceMatches mozLocale) defaultSource sources;

              pname = "thunderbird-bin";
            in

            stdenv.mkDerivation {
              inherit pname version;

              src = fetchurl {
                inherit (source) url sha256;
              };

              sourceRoot = lib.optional stdenv.hostPlatform.isDarwin ".";

              nativeBuildInputs = [
                wrapGAppsHook3
              ]
              ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
                autoPatchelfHook
                patchelfUnstable
              ]
              ++ lib.optionals stdenv.hostPlatform.isDarwin [
                undmg
              ];
              buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
                alsa-lib
              ];
              # Thunderbird uses "relrhack" to manually process relocations from a fixed offset
              patchelfFlags = [ "--no-clobber-old-sections" ];

              # don't break code signing
              dontFixup = stdenv.hostPlatform.isDarwin;

              patchPhase = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
                # Don't download updates from Mozilla directly
                echo 'pref("app.update.auto", "false");' >> defaults/pref/channel-prefs.js
              '';

              installPhase =
                if stdenv.hostPlatform.isDarwin then
                  ''
                    mkdir -p $out/Applications
                    mv Thunderbird*.app "$out/Applications/${applicationName}.app"
                  ''
                else
                  ''
                    mkdir -p "$prefix/usr/lib/thunderbird-bin-${version}"
                    cp -r * "$prefix/usr/lib/thunderbird-bin-${version}"

                    mkdir -p "$out/bin"
                    ln -s "$prefix/usr/lib/thunderbird-bin-${version}/thunderbird" "$out/bin/"

                    # wrapThunderbird expects "$out/lib" instead of "$out/usr/lib"
                    ln -s "$out/usr/lib" "$out/lib"

                    gappsWrapperArgs+=(--argv0 "$out/bin/.thunderbird-wrapped")

                    # See: https://github.com/mozilla/policy-templates/blob/master/README.md
                    mkdir -p "$out/lib/thunderbird-bin-${version}/distribution";
                    ln -s ${policiesJson} "$out/lib/thunderbird-bin-${version}/distribution/policies.json";
                  '';

              passthru.updateScript = import ./../../browsers/firefox-bin/update.nix {
                inherit
                  pname
                  writeScript
                  xidel
                  coreutils
                  gnused
                  gnugrep
                  curl
                  gnupg
                  runtimeShell
                  versionSuffix
                  ;
                baseName = "thunderbird";
                basePath = "pkgs/applications/networking/mailreaders/thunderbird-bin";
                baseUrl = "http://archive.mozilla.org/pub/thunderbird/releases/";
              };

              passthru = {
                inherit applicationName;
                binaryName = "thunderbird";
                gssSupport = true;
                gtk3 = gtk3;
              };

              meta = {
                changelog = "https://www.thunderbird.net/en-US/thunderbird/${version}/releasenotes/";
                description = "Mozilla Thunderbird, a full-featured email client (binary package)";
                homepage = "http://www.mozilla.org/thunderbird/";
                mainProgram = "thunderbird";
                sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
                license = lib.licenses.mpl20;
                maintainers = with lib.maintainers; [ lovesegfault ];
                platforms = builtins.attrNames mozillaPlatforms;
                hydraPlatforms = [ ];
              };
            };

          thunderbird-bin-unwrapped = pkgs.callPackage thunderbird-bin-pkg {
            generated = import "${inputs.nixpkgs}/pkgs/applications/networking/mailreaders/thunderbird-bin/release_sources.nix";
          };

          thunderbird-bin = pkgs.wrapThunderbird thunderbird-bin-unwrapped {
            pname = "thunderbird-bin";
          };
        in
        {
          enable = true;
          package = thunderbird-bin;

          profiles.default = {
            isDefault = true;

            accountsOrder = [
              "social"
              "git"
              "work"
              "contact"
            ];

            calendarAccountsOrder = [
              "work"
              "social"
            ];
          };
        };

      accounts =
        let
          domain = "vini.cat";
        in
        {
          email.accounts =
            [
              "social"
              "git"
              "work"
              "contact"
            ]
            |> lib.map (account: {
              ${account} = rec {
                address = "${account}@${domain}";

                userName = address;
                realName = "Vinicius Deolindo";

                primary = account == "social";

                smtp = {
                  host = "smtp.purelymail.com";
                  port = 465;
                };

                imap = {
                  host = "imap.purelymail.com";
                  port = 993;
                };

                thunderbird.enable = true;
              };
            })
            |> lib.mergeAttrsList;

          calendar.accounts =
            [
              {
                name = "social";
                webdavId = "280603";
                color = "#5d42f5";
              }
              {
                name = "work";
                webdavId = "280601";
                color = "#f5425d";
              }
            ]
            |> lib.map (account: {
              ${account.name} = {
                primary = account.name == "social";

                remote = {
                  type = "caldav";
                  url = "https://purelymail.com/webdav/${account.webdavId}/caldav/default";
                  userName = "${account.name}@${domain}";
                };

                thunderbird = {
                  enable = true;
                  color = account.color;
                };
              };
            })
            |> lib.mergeAttrsList;
        };

      programs.git.extraConfig.sendemail.identity = "git";
    };
}
