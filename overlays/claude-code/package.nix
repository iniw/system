{
  lib,
  writeShellApplication,
  nodejs_22,
  testers,
}:
writeShellApplication {
  name = "claude";

  runtimeInputs = [
    nodejs_22
  ];

  text = ''
    exec npx --yes @anthropic-ai/claude-code "$@"
  '';

  passthru.tests.version = testers.testVersion {
    package = writeShellApplication {
      name = "claude-code";
      runtimeInputs = [ nodejs_22 ];
      text = ''exec npx --yes @anthropic-ai/claude-code "$@"'';
    };
    command = "HOME=$(mktemp -d) claude --version";
  };

  meta = {
    description = "Agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster";
    homepage = "https://claude.ai/code";
    downloadPage = "https://www.npmjs.com/package/@anthropic-ai/claude-code";
    license = lib.licenses.unfree;
    maintainers = [ ];
    mainProgram = "claude";
  };
}
