{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  coreutils,
  util-linux,
  libsecret,
  makeBinaryWrapper,
  installAgentSkills,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "linear-cli";
  version = "3.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "schpet";
    repo = "linear-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jTQeOx78GuclgLiXccOy6smdrGTEfydm4HD+/luOlFM=";
  };

  cargoHash = "sha256-ItoCHuZ1maJ8n2MagqR8x3ch6mbPplDYipRJ/jtgEGQ=";

  nativeBuildInputs = [
    installAgentSkills
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ makeBinaryWrapper ];

  # The tests use programs from `/usr/bin` and `/bin`, which the Linux sandbox does not have.
  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace crates/linear-cli/src/auth/file.rs \
      --replace-fail /usr/bin/mkfifo ${lib.getExe' coreutils "mkfifo"}

    substituteInPlace crates/linear-cli/src/auth/keyring/process/tests.rs \
      --replace-fail /bin/cat ${lib.getExe' coreutils "cat"} \
      --replace-fail /bin/sleep ${lib.getExe' coreutils "sleep"} \
      --replace-fail /bin/kill ${lib.getExe' coreutils "kill"}

    substituteInPlace crates/linear-cli/tests/cli/support/sandbox.rs \
      --replace-fail /usr/bin/script ${lib.getExe' util-linux "script"} \
      --replace-fail PATH=/usr/bin:/bin PATH=${lib.makeBinPath [ coreutils ]}
  '';

  # On Linux, the CLI stores API keys in the system keyring with `secret-tool`.
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram "$out/bin/linear" --suffix PATH : ${lib.makeBinPath [ libsecret ]}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linear without leaving the command line";
    homepage = "https://github.com/schpet/linear-cli";
    changelog = "https://github.com/schpet/linear-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ wini ];
    mainProgram = "linear";
  };
})
