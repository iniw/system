{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bun,
  installAgentSkills,
  makeBinaryWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "slackcli";
  version = "0.17.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "shaharia-lab";
    repo = "slackcli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EPvs4bjq+mbaLy0Pd/YZHXvPMTFvLJQsf8DsJh4w7x8=";
  };

  node_modules = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) version src;

    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      bun install --frozen-lockfile --ignore-scripts --no-progress --production

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp -R node_modules "$out"

      runHook postInstall
    '';

    dontFixup = true;

    outputHash = "sha256-Nw37VF9VEBbVUnLA5O+7sASvJkBNts+TFQFx3WK406E=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    installAgentSkills
    makeBinaryWrapper
  ];

  # `node_modules` also has skills, so we install only the skill of this project.
  dontInstallAgentSkills = true;

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node_modules} node_modules
    chmod -R u+w node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    bun run scripts/build.ts --outfile=dist/slackcli

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 dist/slackcli "$out/bin/slackcli"
    installSkill plugins/slackcli/skills/slackcli

    # Nix installs the CLI, so it must not tell the user to update it with `slackcli update`.
    wrapProgram "$out/bin/slackcli" --set-default SLACKCLI_NO_UPDATE_NOTIFIER 1

    runHook postInstall
  '';

  # `bun build --compile` appends the program to a copy of the `bun` executable. Stripping the result removes the
  # program.
  dontStrip = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "node_modules"
    ];
  };

  meta = {
    description = "Slack CLI for humans and AI agents";
    homepage = "https://slackcli.dev/";
    changelog = "https://github.com/shaharia-lab/slackcli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wini ];
    mainProgram = "slackcli";
    inherit (bun.meta) platforms;
  };
})
